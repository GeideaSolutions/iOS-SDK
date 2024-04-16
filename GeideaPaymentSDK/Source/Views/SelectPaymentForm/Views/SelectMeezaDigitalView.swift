//
//  MeezaDigitalView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 24.10.2022.
//

import UIKit

class SelectMeezaDigitalView: PaymentMethodsView {
    
    let customerIdInvalid = "CUSTOMER_ID_INVALID".localized
    let phoneNumberInvalid = "PHONE_NUMBER_INVALID".localized
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var circleView: RadialCircleView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var logosSV: UIStackView!
  
    @IBOutlet weak var phoneNumberError: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    var paymentMethods: [String]?
    
    var phoneNumberTimer: Timer? = nil
    var onPhoneNumberEntered: ((String) -> Void)?
    
    override  var paymentMethod: PaymentTypeStatus? {
          didSet {
              configurePaymentMethod()
          }
      }
      
      override var selected: Bool  {
          didSet {
              setSelected(isSelected: selected)
          }
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        let view = viewFromNibForClass()
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        borderView.withBorder(isVisible: true, radius: 8, width: 2,color: UIColor.borderDisabled.cgColor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        borderView.addGestureRecognizer(tap)
        
        phoneNumberTF.delegate = self
        phoneNumberTF.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: "DONE_BUTTON".localized)
        
        phoneNumberLabel.text = "PHONE_NUMBER_LABEL".localized
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
        phoneNumberTF.resignFirstResponder()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let safeSelected = paymentMethod?.onSelected else {
            return
        }
        selected = true
        safeSelected(paymentMethod)
    }
    
    func setSelected(isSelected: Bool) {
        
        if !isSelected {
            phoneNumberTF.text = ""
        }
        phoneNumberView.isHidden = !isSelected
        
        circleView.enabled(enabled: selected, config: paymentMethod?.config)
        if selected {
            borderView.withBorder(isVisible: true, radius: 8, width: 2,color: circleView.enabledColor.cgColor)
        } else {
            borderView.withBorder(isVisible: true, radius: 8, width: 2,color: UIColor.borderDisabled.cgColor)
        }
        
    }
    
    func configurePaymentMethod() {
        
        title.text = paymentMethod?.item.label
        
        if let logos = paymentMethod?.logos {
            for logo in logos {
                logosSV.addArrangedSubview(Utils.getImageView(with: logo,width: 27))
            }
        }
    }
}

extension SelectMeezaDigitalView: UITextFieldDelegate {
    
    
    func isPhoneNumberFieldValid() -> Bool {
        var isValid = false
    
        
        
        
        
        if let validator = customerIdValidator(customerId: phoneNumberTF.text ?? "") {
            phoneNumberError.text = validator
            phoneNumberError.isHidden = false
            isValid = false
        } else {
            phoneNumberError.isHidden = true
        }
        
        var length = 10
        if let pn = phoneNumberTF.text {
            if pn.starts(with: "0") {
                length = 11
            } else {
                length = 10
            }
        }
        if let safephoneEntered = onPhoneNumberEntered {
            if phoneNumberTF.text?.count ?? 0 >= length && phoneNumberError.isHidden {
                isValid = true
                safephoneEntered(phoneNumberTF.text ?? "")
            } else{
                safephoneEntered("")
            }
        }
   
        
        return isValid
    }
    
    func customerIdValidator(customerId: String) -> String? {
        if let error = isCustomerIdValid(customerId: customerId){
            return error
        }
        return nil
    }
    
    func isCustomerIdValid(customerId: String) -> String? {


        if customerId.count > 255  {
            return customerIdInvalid
        }

        if !customerId.isNumeric && !customerId.isEmpty  {
            return customerIdInvalid
        }
        
        if  !customerId.isEmpty {
            guard customerId.isValidEgiptPhonWOPrefix else {
                return phoneNumberInvalid
            }
            return nil
        }

        return nil
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        
        if textField == phoneNumberTF {
            phoneNumberTimer?.invalidate()
            
            phoneNumberTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(self.phoneNumberCheck),
                userInfo: ["textField": textField],
                repeats: false)
            
            if let pn = phoneNumberTF.text {
                if pn.starts(with: "0") {
                    return newLength <= 11
                } else {
                    return newLength <= 10
                }
            }
            
        }
       
       
        return true
    }
    
    @objc func phoneNumberCheck() {
      _ = isPhoneNumberFieldValid()
//        validateButton()
    }
    
   
}
