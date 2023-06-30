//
//  OTPViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 15.02.2022.
//

import UIKit

struct OTPConstants {
    static let timerCount = 60
    static let attemptsCount = 1
}

class OTPViewController: BaseViewController {
    
    @IBOutlet weak var otpDescriptionLabel: UILabel!
    @IBOutlet weak var otpResendTitle: UILabel!
    @IBOutlet weak var otpView: UIStackView!
    @IBOutlet weak var otp1: RichTextField!
    @IBOutlet weak var otp2: RichTextField!
    @IBOutlet weak var otp3: RichTextField!
    @IBOutlet weak var otp4: RichTextField!
    @IBOutlet weak var otp5: RichTextField!
    @IBOutlet weak var otp6: RichTextField!
    
    @IBOutlet weak var OTP6View: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var finalizebutton: RoundedButton!
    @IBOutlet weak var resendBtn: RoundedButton!
    @IBOutlet weak var bnplLogo: UIImageView!
    
    @IBOutlet weak var attemptsLabel: UILabel!
    @IBOutlet weak var counter: UILabel!
    private var inputs: [UITextField]!
    
    @IBOutlet weak var trView: UIStackView!
    @IBOutlet weak var attemptsView: UIStackView!
    
    @IBOutlet weak var trValue: UILabel!
    @IBOutlet weak var attemptsValue: UILabel!
    
    var secondsRemaining = OTPConstants.timerCount
    var attemptsCount = OTPConstants.attemptsCount
    var viewModel: OTPViewModel!
    
    @IBOutlet var mainView: UIView!
    var otpFieldTimer: Timer? = nil
    var otp = ""
    
    var bnplVC: BNPLViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bnpl = self.parent as? BNPLViewController {
            bnplVC = bnpl
        }
        setupViews()
        generateOTP()
    }
    
    func resendOTP() {
        if let bnpl = self.parent as? BNPLViewController {
            //            self.trValue.text = String(OTPConstants.timerCount)
            self.errorLabel.isHidden = true
            
            let details = GDSouhoolaResendOTPDetails(customerIdentifier: bnplVC.viewModel.customerId, customerPin: bnplVC.viewModel.pin )
            bnpl.viewModel.souhoolaResendOTP(with: details, completion: { response, error in
                if let err = error {
                    if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015") {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = err.detailedResponseMessage
                    } else {
                        bnpl.showReceipt(receipt: nil, error: error, receiptFlow: .SOUHOOLA)
                    }
                } else {
                    
                }
                self.trView.isHidden = true
            })
        }
        
    }
    
    func generateOTP() {
        if let bnpl = self.parent as? BNPLViewController {
            modifyOTP()
            
            switch bnplVC.viewModel.provider {
                
            case .Souhoola:
                self.trValue.text = String(OTPConstants.timerCount)
                self.errorLabel.isHidden = true
                let details = GDSouhoolaOTPDetails(customerIdentifier: bnplVC.viewModel.customerId, customerPin: bnplVC.viewModel.pin, orderId: bnplVC.viewModel.orderId, souhoolaTransactionId: bnplVC.viewModel.bnplOrderID)
                bnpl.viewModel.souhoolaGenerateOTP(with: details, completion: { response, error in
                    self.setupSouhoolaResponse(response: response, error: error)
                })
            case .ValU:
                bnpl.viewModel.generateOTP(with: bnpl.viewModel.customerId ?? "", bnplOrderID: bnpl.viewModel.bnplOrderID ?? "", completion: { response, errror in
                    if let err = errror {
                        self.errorLabel.text = err.detailedResponseMessage
                    } else {
                        bnpl.viewModel.bnplOrderID = response?.bnplOrderId
                    }
                })
            default: break
            }
            
        }
    }
    
    func setupSouhoolaResponse(response:GDSouhoolaBasicResponse?, error: GDErrorResponse? ) {
        if let err = error {
            if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015") {
                self.errorLabel.isHidden = false
                self.errorLabel.text = err.responseMessage
            } else {
                self.bnplVC.showReceipt(receipt: nil, error: err, receiptFlow: .SOUHOOLA)
            }
            
        } else {
            
        }
        self.configureResendTimer()
    }
    
    func setupViews() {
        localizeStrings()
        setBranding()
        setupInputs()
        otpView.semanticContentAttribute = .forceLeftToRight
//        resendBtn.setTitleColor(UIColor.buttonBlue, for: .normal)
        
        if let bnpl = self.parent as? BNPLViewController {
            
            bnpl.stepView.backBtn.isHidden = true
            bnpl.xBtn.isHidden = false
            
        }
        
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            attemptsValue.text = String(OTPConstants.attemptsCount)
            otpResendTitle.isHidden = true
            OTP6View.isHidden = true
            switch GlobalConfig.shared.language {
            case .arabic:
                bnplLogo.image = UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            default:
                bnplLogo.image = UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            }
        case .ValU:
            otpResendTitle.isHidden = false
            bnplLogo.image = UIImage(named: "valU_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            trView.isHidden = true
            attemptsView.isHidden = true
        default: break
        }
        
        finalizebutton.enabled(isEnabled: false, config: bnplVC.viewModel.selectPaymentVM.config )
        
    }
    
    func setBranding() {
        resendBtn.applyBrandingCancel(config: bnplVC.viewModel?.selectPaymentVM.config)
        finalizebutton.enabled(isEnabled: true, config: bnplVC.viewModel?.selectPaymentVM.config)
        
    }
    
    override func localizeStrings() {
        resendBtn.setTitle(viewModel.resendBtnTitle, for: .normal)
        finalizebutton.setTitle(viewModel.purchaseBtnTitle, for: .normal)
        otpResendTitle.text = viewModel.resendTitle
        otpDescriptionLabel.text = viewModel.OTPDescriptionTitle
        attemptsLabel.text = viewModel.attemptsLeftTitle
    }
    
    func configureResendTimer() {
        self.trValue.text = String(OTPConstants.timerCount)
        self.secondsRemaining = OTPConstants.timerCount
        self.resendBtn.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                
                self.trValue.text  = "\(self.secondsRemaining) \(self.viewModel.secondsTitle)"
                self.secondsRemaining -= 1
            } else {
                Timer.invalidate()
                self.trValue.text  = "\(self.secondsRemaining) \(self.viewModel.secondsTitle)"
                self.resendBtn.isEnabled = self.attemptsCount > 0
                self.attemptsValue.text = String(self.attemptsCount)
                if self.attemptsCount > 0 {
                    
                } else {
                    self.resendBtn.isHidden = true
                    self.trView.isHidden = true
                }
            }
        }
    }
    
    func setupInputs() {
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            inputs = [otp1, otp2, otp3, otp4, otp5]
        case .ValU:
            inputs = [otp1, otp2, otp3, otp4, otp5,otp6]
        default: break
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mainView.addGestureRecognizer(tap)
        
        handleTextFields()
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        for input in inputs {
            input.resignFirstResponder()
        }
        
    }
    
    @objc func modifyOTP() {
        
        self.otp = ""
        otp += otp1.text ?? ""
        otp += otp2.text ?? ""
        otp += otp3.text ?? ""
        otp += otp4.text ?? ""
        otp += otp5.text ?? ""
        
        if bnplVC.viewModel.provider == .ValU {
            otp += otp6.text ?? ""
        }
        
        
        if !otp.isAlphanumeric && !otp.isEmpty  {
            errorLabel.isHidden = false
            errorLabel.text = "Only alphanumeric values allowed"
        }
        
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            if otp.count == 5 && errorLabel.isHidden == true {
                finalizebutton.enabled(isEnabled: true, config: bnplVC.viewModel.selectPaymentVM.config)
            } else {
                finalizebutton.enabled(isEnabled: false, config: bnplVC.viewModel.selectPaymentVM.config)
            }
        case .ValU:
            if otp.count == 6 && errorLabel.isHidden == true {
                finalizebutton.enabled(isEnabled: true, config: bnplVC.viewModel.selectPaymentVM.config)
            } else {
                finalizebutton.enabled(isEnabled: false, config: bnplVC.viewModel.selectPaymentVM.config)
            }
        default: break
        }
        
    }
    
    func resetOTP() {
        self.otp = ""
        otp1.text = ""
        otp2.text = ""
        otp3.text = ""
        otp4.text = ""
        otp5.text = ""
        otp6.text = ""
        
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            if otp.count == 5 {
                finalizebutton.enabled(isEnabled: true, config: bnplVC.viewModel.selectPaymentVM.config)
            } else {
                finalizebutton.enabled(isEnabled: false, config: bnplVC.viewModel.selectPaymentVM.config)
            }
        case .ValU:
            if otp.count == 6 {
                finalizebutton.enabled(isEnabled: true, config: bnplVC.viewModel.selectPaymentVM.config)
            } else {
                finalizebutton.enabled(isEnabled: false, config: bnplVC.viewModel.selectPaymentVM.config)
            }
        default: break
        }
        
        
        
    }
    
    func handleTextFields() {
        (0..<inputs.count).forEach { index in
            let textField = inputs[index] as! RichTextField
            textField.delegate = self
            textField.richTFDelegate = self
            textField.tag = index
            textField.semanticContentAttribute = .forceLeftToRight
            var buttonText = viewModel.nextTitle
            if index == inputs.count - 1 {
                buttonText = viewModel.doneTitle
            }
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: buttonText)
            
        }
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
        if sender.tag == inputs.count - 1 {
            inputs[sender.tag].resignFirstResponder()
        } else {
            inputs[sender.tag + 1].becomeFirstResponder()
        }
    }
    
    init() {
        super.init(nibName: "OTPViewController", bundle: Bundle(for: OTPViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "OTPViewController", bundle: Bundle(for: OTPViewController.self))
    }
    
    @IBAction func resendCodeTapped(_ sender: Any) {
        self.attemptsCount -= 1
        if self.attemptsCount == 0 {
            resendBtn.isHidden = true
            attemptsView.isHidden = true
            trView.isHidden = true
        }
        self.attemptsValue.text = String(self.attemptsCount)
        
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            resendOTP()
        case .ValU:
            generateOTP()
        default: break
        }
        
    }
    
    
    @IBAction func finalizePurchaseTapped(_ sender: Any) {
        finalizebutton.showLoading()
        
        switch bnplVC.viewModel.provider {
        case .Souhoola:
            let details = GDSouhoolaConfirmDetails(customerIdentifier: bnplVC.viewModel.customerId, customerPin: bnplVC.viewModel.pin, orderId: bnplVC.viewModel.orderId, souhoolaTransactionId: bnplVC.viewModel.bnplOrderID, otp: otp)
            GeideaBNPLAPI.souhoolaConfirm(with: details, completion:{ response, error in
                self.finalizebutton.hideLoading()
                if let err = error {
                    
                    if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015") {
                        self.resetOTP()
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = err.detailedResponseMessage
                    } else {
                        self.bnplVC.showReceipt(receipt: nil, error: error, receiptFlow: .SOUHOOLA)
                    }
                } else {
                    
                    ReceiptManager().receipt(with: self.bnplVC.viewModel.orderId ?? "", completion:{ response, error in
                        self.bnplVC.showReceipt(receipt: response, error: error, receiptFlow: .SOUHOOLA)
                    })
                    
                }
            })
        case .ValU:
            let details = GDBNPLPurchaseDetails(customerIdentifier: bnplVC.viewModel.customerId, orderId: bnplVC.viewModel.orderId, bnplOrderId: bnplVC.viewModel.bnplOrderID, otp: otp, totalAmount: bnplVC.viewModel.selectPaymentVM.amount.amount, currency: bnplVC.viewModel.selectPaymentVM.amount.currency, downPayment: bnplVC.viewModel.downPayment?.amount ?? 0, giftCardAmount: bnplVC.viewModel.toUAmount?.amount ?? 0, campaignAmount: bnplVC.viewModel.cashBackAmount?.amount ?? 0, tenure: bnplVC.viewModel.tenure, adminFees: bnplVC.viewModel.adminFees)
            GeideaBNPLAPI.VALUPurchase(with: details, completion:{ response, error in
                self.finalizebutton.hideLoading()
                if let err = error {
                    if err.detailedResponseCode == "010" || err.detailedResponseCode == "009" || err.detailedResponseCode == "012" {
                        
                        self.resetOTP()
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = err.detailedResponseMessage
                    } else {
                        self.bnplVC.showReceipt(receipt: nil, error: err, receiptFlow: .VALU)
                    }
                    
                } else {
                    ReceiptManager().receipt(with: response?.orderId ?? "", completion:{ response, error in
                        self.bnplVC.showReceipt(receipt: response, error: error, receiptFlow: .VALU)
                    })
                }
            })
        default: break
        }
        
    }
}

extension OTPViewController: UITextFieldDelegate, RichTextFieldDelegate {
    func textFieldDidDelete(textField: RichTextField) {
        if textField == otp1 {
            otp1.text = ""
        } else if textField == otp2 {
            otp2.text = ""
            otp1.becomeFirstResponder()
        } else if textField == otp3 {
            otp3.text = ""
            otp2.becomeFirstResponder()
            
        } else if textField == otp4 {
            otp4.text = ""
            otp3.becomeFirstResponder()
        } else if textField == otp5 {
            otp5.text = ""
            otp4.becomeFirstResponder()
        } else if textField == otp6 {
            otp6.text = ""
            otp5.becomeFirstResponder()
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        otpFieldTimer?.invalidate()
        
        otpFieldTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.modifyOTP),
            userInfo: ["textField": textField],
            repeats: false)
        let isBack = string.isEmpty
        self.errorLabel.isHidden = true
        
        if textField == otp1 {
            otp1.text = string
            otp2.becomeFirstResponder()
        } else if textField == otp2 {
            
            if !isBack {
                otp2.text = string
                otp3.becomeFirstResponder()
            } else {
                otp2.text = ""
                otp1.becomeFirstResponder()
            }
            
        } else if textField == otp3 {
            otp3.text = string
            if !isBack {otp4.becomeFirstResponder()}
        } else if textField == otp4 {
            otp4.text = string
            if !isBack { otp5.becomeFirstResponder()}
        } else if textField == otp5 {
            otp5.text = string
            if bnplVC.viewModel.provider == .Souhoola {
                otp5.resignFirstResponder()
            } else {
                if !isBack { otp6.becomeFirstResponder()}
            }
           
        } else if textField == otp6 {
            
            otp6.resignFirstResponder()
            if !isBack {
                otp6.text = string
            }
        }
        
        if !isBack {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

