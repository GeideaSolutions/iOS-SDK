//
//  PhoneNumberViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 04.02.2022.
//

import UIKit

protocol PhoneNumberDelegate {
  func phoneNumber()
}


class PhoneNumberViewController: BaseViewController {

    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var nextBtn: RoundedButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var phoneNumberErrorLabel: UILabel!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var pinError: UILabel!
    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var logo: UIImageView!
    var phoneNumberTimer: Timer? = nil
    var pinTimer: Timer? = nil
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var registerhereBtn: UIButton!
    
    @IBOutlet var phoneNumberView: UIView!
    @IBOutlet weak var pinView: UIStackView!
    @IBOutlet var contentView: UIView!
    var viewModel: PhoneNumberViewModel!
    var bnplVC: BNPLViewController!
    
    init() {
        super.init(nibName: "PhoneNumberViewController", bundle: Bundle(for: PhoneNumberViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "PhoneNumberViewController", bundle: Bundle(for: PhoneNumberViewController.self))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        phoneNumberView.addGestureRecognizer(tap)

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bnpl = self.parent as? BNPLViewController {
            bnplVC = bnpl
        }
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePreferredSize()
        
        if let bnpl = self.parent as? BNPLViewController {
            bnplVC = bnpl 
        }

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        pinTF.resignFirstResponder()
        phoneNumberTF.resignFirstResponder()
    }

    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width, height: view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
        preferredContentSize = contentView.systemLayoutSizeFitting(targetSize)
    }
    
    func setupViews() {
        localizeStrings()
        setBranding()
        phoneNumberTF.delegate = self
        pinTF.delegate = self
        
        switch bnplVC.viewModel.provider {
        case .ValU:
            pinView.isHidden = true
            logo.image = UIImage(named: "valU_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            registerhereBtn.isHidden = true
            accountLabel.isHidden = true
        case .Souhoola:
            pinView.isHidden = false
            switch GlobalConfig.shared.language {
                case .arabic:
                    logo.image = UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
                default:
                   logo.image = UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            }
        default:
            break
        }
        
//       clearFields()
       validateButton()
    }
    
    func clearFields() {
        phoneNumberTF.text = ""
        pinTF.text = ""
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: bnplVC.viewModel.selectPaymentVM.config)
        nextBtn.enabled(isEnabled: false, config: bnplVC.viewModel.selectPaymentVM.config)
        
        
    }
    
    func handleTextFields() {
        phoneNumberTF.delegate = self
        phoneNumberTF.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: viewModel.doneTitle)
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
        phoneNumberTF.resignFirstResponder()
    }
    
    override func localizeStrings() {
        phoneNumberLabel.text = viewModel.phoneTitle
        pinLabel.text = viewModel.pinTitle
        accountLabel.text = viewModel.accountTitle
        registerhereBtn.setTitle(viewModel.registerTitle, for: .normal)
        
        nextBtn.setTitle(viewModel.nextTitle, for: .normal)
        cancelBtn.setTitle(viewModel.cancelTitle, for: .normal)
        
    }

 
    @IBAction func nextBtnTapped(_ sender: Any) {
        if let bnpl = self.parent as? BNPLViewController {
            nextBtn.showLoading()
            bnpl.phoneNumberNextTapped(with: phoneNumberTF.text ?? "", pin: pinTF.text ?? "")
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        if let orderId = bnplVC?.viewModel.selectPaymentVM.orderId, !orderId.isEmpty {
            logEvent("Cancelled By User \(orderId)")
            let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
            CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                self.viewModel.orderId = nil
            })
        }
        dismiss(animated: false)
    }
    
    @IBAction func registerHereTapped(_ sender: Any) {
        let appURL = "itms-apps://apps.apple.com/eg/app/souhoola-%D8%B3%D9%87%D9%88%D9%84%D8%A9/id1514405177".fixedArabicURL ?? ""
        if let url = URL(string: appURL)
        {
                   if #available(iOS 10.0, *) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   }
            
                   else {
                         if UIApplication.shared.canOpenURL(url as URL) {
                            UIApplication.shared.openURL(url as URL)
                        }
                   }
        }
    }
}

extension PhoneNumberViewController: UITextFieldDelegate {

    
    fileprivate func areFieldsValid() -> Bool {
    
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            return isPinFieldValid() && isPhoneNumberFieldValid()
        default: return  isPhoneNumberFieldValid()
        }
      
    }
    
    func isPinFieldValid() -> Bool {
        var isValid = false
        guard let pin  = pinTF.text else {
            return false
        }
            
        if  !pin.isEmpty {
            isValid = true
        }
        
        if let validator = viewModel.pinValidator(pin: pin) {
            pinError.text = validator
            pinError.isHidden = false
            isValid = false
        } else {
            pinError.isHidden = true
        }
        
        return isValid
    }
    
    func isPhoneNumberFieldValid() -> Bool {
        var isValid = false
        
        if phoneNumberTF.text?.count ?? 0 >= 3 {
            isValid = true
        }
        
        if let validator = viewModel.customerIdValidator(customerId: phoneNumberTF.text ?? "") {
            phoneNumberErrorLabel.text = validator
            phoneNumberErrorLabel.isHidden = false
            isValid = false
        } else {
            phoneNumberErrorLabel.isHidden = true
        }
        
        return isValid
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {

           pinTF.resignFirstResponder()
           phoneNumberTF.resignFirstResponder()
           return true
       }

    func validateButton() {        switch bnplVC.viewModel.provider {
        case .Souhoola:
            nextBtn.enabled(isEnabled: phoneNumberTF.text?.count ?? 0 > 8 && pinTF.text?.count ?? 0 >= 1 && areFieldsValid(), config: bnplVC.viewModel.selectPaymentVM.config)
        default:
            nextBtn.enabled(isEnabled: phoneNumberTF.text?.count ?? 0 > 8 && areFieldsValid(), config: bnplVC.viewModel.selectPaymentVM.config)
        }
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
            
        } else {
            pinTimer?.invalidate()
            
            pinTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(self.pinNumberCheck),
                userInfo: ["textField": textField],
                repeats: false)
            
        }
       
       
        return true
    }
    
    @objc func phoneNumberCheck() {
        _ = isPhoneNumberFieldValid
        validateButton()
    }
    
    @objc func pinNumberCheck() {
        _ = isPinFieldValid()
        validateButton()
    }
    
   
}
