//
//  CVVViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.07.2022.
//

import UIKit

class CVVViewController: BaseViewController  {

    @IBOutlet weak var cvvAlertView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardSchemeLogo: UIImageView!
    @IBOutlet weak var cardExpiryDate: UILabel!
    
    @IBOutlet weak var cvvTitle: UILabel!
    @IBOutlet weak var cvvError: UILabel!
    @IBOutlet weak var cvvTF: RoundedTextField!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var enterCVVLabel: UILabel!
    var cvvTimer: Timer? = nil
    
    @IBOutlet weak var nextBtn: RoundedButton!
    @IBOutlet weak var cvvTFTitle: UILabel!
    var viewModel:CVVViewModel!

    
    init() {
        super.init(nibName: "CVVViewController", bundle: Bundle(for: CVVViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func localizeStrings() {
        enterCVVLabel.text = viewModel.cvvEnter
        cvvTitle.text = viewModel.cvvScreenTitle
        nextBtn.setTitle(viewModel.nextTitle, for: .normal)
        cvvTF.placeholder = viewModel.cvvTitle
        
    }
    
    func setBranding() {
        if let accessTextColor = viewModel.config?.branding?.accentTextColor {
            nextBtn.setTitleColor(UIColor(hex: accessTextColor), for: .normal)
        }
    }
    
    func setupViews() {
        self.cardView.withBorder(isVisible: true, radius: 8, width: 1, color: UIColor.borderCVV.cgColor)
        self.cardView.addShadow(offset: CGSize(width: 2, height: 8), color: UIColor.white, opacity: 0.07, radius: 4)
        localizeStrings()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cvvAlertView.addGestureRecognizer(tap)
        
        handleTextFields()
        
        switch viewModel.tokenResponse?.schema?.lowercased() {
        case "visa":
            self.cardSchemeLogo.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: CardType.Visa)
        case "mastercard":
            self.cardSchemeLogo.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: CardType.MasterCard)
        case "mada":
            self.cardSchemeLogo.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: CardType.Mada)
        case "meeza":
            self.cardSchemeLogo.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: CardType.Meeza)
        case "amex":
            self.cardSchemeLogo.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: CardType.Amex)
        default:
            break
        }
        nextBtn.enabled(isEnabled: false, config: viewModel.config)
        cvvTF.delegate = self
        
        if let myImage = UIImage(named: "cvvIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
            cvvTF.withImage(image: myImage)
        }
        
        
        cardLabel.text =  String(format: viewModel.cardTitle, viewModel.tokenResponse?.schema?.uppercased() ?? "", viewModel.tokenResponse?.lastFourDigits?.uppercased() ?? "" )
        let safeMonth = viewModel.tokenResponse?.expiryDate?.month ?? 1
        let monthName = DateFormatter().shortMonthSymbols[safeMonth - 1]
        cardExpiryDate.text = String(format: viewModel.expiresTitle, monthName, String(viewModel.tokenResponse?.expiryDate?.year ?? 0 ))
        
   }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        cvvTF.resignFirstResponder()
    }
    

    func handleTextFields() {
        if let textField = cvvTF {
            textField.delegate = self
            var buttonText = "DONE_BUTTON".localized

           textField.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: buttonText)
        }
            
    }
    
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
        cvvTF.resignFirstResponder()
    }
    
    func displaySimpleAlert(title: String, message:String) {
        let vc = PaymentFactory.makeCVVAlertViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
        vc.config = viewModel.config
        self.present(vc, animated: true)
        
    }
    
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()

           // Call the roundCorners() func right there.
        self.cvvAlertView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft], radius: 30)
       
       }


    @IBAction func nextBtnTapped(_ sender: Any) {
        viewModel.completion(cvvTF.text)

    }
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        let message = viewModel.cvvHintTitle
        
        displaySimpleAlert(title: viewModel.cvvTitle, message: message)
    }
    @IBAction func xBtnTapped(_ sender: Any) {
        dismiss(animated: false)
    }
   
}

extension CVVViewController: UITextFieldDelegate {
    
    fileprivate func isPayButtonValid() {
        if viewModel.isPayButonValid( cvv: cvvTF.text ?? "") {
            nextBtn.enabled(isEnabled: true, config: viewModel.config)
        } else {
            nextBtn.enabled(isEnabled: false, config: viewModel.config)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        
        if textField == cvvTF {
            
            guard let validator = viewModel.cvvValidator(cvv: cvvTF.text ?? "") else {
                cvvError.isHidden = true
                return
            }
            cvvError.text = validator
            cvvError.isHidden = false
            
        }
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        cvvTimer?.invalidate()
        
        cvvTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.cvvCheck),
            userInfo: ["textField": textField],
            repeats: false)
        
        let newLength = (textField.text ?? "").count + string.count - range.length
      
        if textField == cvvTF {
            return newLength <= 4
        }
        

        
        return true
    }
    
    @objc func cvvCheck() {
       isPayButtonValid()
    }
}

