//
//  ViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 15/10/2020.
//

import UIKit
import GeideaPaymentSDK
import PassKit

class ViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var currencyTF: UITextField!
    @IBOutlet weak var cardHolderNameTF: UITextField!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var expiryMonthTF: UITextField!
    @IBOutlet weak var expiryYearTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var callbackTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var publicKeyTF: UITextField!
    @IBOutlet weak var paymentMethodSelection: UISegmentedControl!
    @IBOutlet weak var paymentDetailsView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginSwitch: UISwitch!
    @IBOutlet weak var merchentRefidTF: UITextField!
    @IBOutlet weak var shippingCountryCodeTF: UITextField!
    @IBOutlet weak var shippingCityTF: UITextField!
    @IBOutlet weak var shippingStreetTF: UITextField!
    @IBOutlet weak var shippingPostalCodeTF: UITextField!
    @IBOutlet weak var billingCountryCodeTF: UITextField!
    @IBOutlet weak var billingCityTF: UITextField!
    @IBOutlet weak var billingStreetTF: UITextField!
    @IBOutlet weak var billingPostalCodeTF: UITextField!
    @IBOutlet weak var applePayBtnView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var paymentOperationBtn: UIButton!
    @IBOutlet weak var captureLabel: UILabel!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet weak var cardOnFileView: UIView!
    @IBOutlet weak var cardOnFileSwitch: UISwitch!
    @IBOutlet weak var cardOnFileLabel: UILabel!
    @IBOutlet weak var initiatedByButton: UIButton!
    @IBOutlet weak var initiateByLabel: UILabel!
    @IBOutlet weak var initiatedByView: UIView!
    @IBOutlet weak var agrementView: UIView!
    @IBOutlet weak var agreementIdTF: UITextField!
    @IBOutlet weak var agreementTypeTF: UITextField!
    @IBOutlet weak var agreementType: UILabel!
    @IBOutlet weak var payTokenBtn: UIButton!
    @IBOutlet weak var configBtn: UIButton!
    @IBOutlet weak var initiatedByViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customerDetailsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eInvoiceTF: UITextField!
    @IBOutlet weak var showAddressSwitch: UISwitch!
    @IBOutlet weak var showAddressView: UIView!
    @IBOutlet weak var showEmailSwitch: UISwitch!
    @IBOutlet weak var cardSchemeLogoIV: UIImageView!
    @IBOutlet weak var generateInvoice: UIButton!
    
    
    private var inputs: [UITextField]!
    var paymentOperation: PaymentOperation = .NONE
    var orderId: String?
    var customerDetailsTopConstraintConstant: CGFloat = 0
    var initiatedByViewHeight: CGFloat = 0
    var paymentMethodViewHeight: CGFloat = 345
    var merchantConfig: GDConfigResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentMethodSelection.selectedSegmentIndex = 1
        paymentMethodSelection.sendActions(for: UIControl.Event.valueChanged)
        
        self.title = "Payment Sample Swift"
        scrollView.keyboardDismissMode = .onDrag
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.contentView.addGestureRecognizer(tap)
        
        refreshConfig()
        setupAppplePay()
        
        initiatedByViewHeight = initiatedByView.bounds.height
        customerDetailsTopConstraintConstant =  customerDetailsTopConstraint.constant
        self.customerDetailsTopConstraint.constant = self.customerDetailsTopConstraintConstant - 20
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Orders", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    @objc func addTapped() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
            return
        }
        
        let vc = OrdersViewController()
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        detectCardScheme()
        configureComponents()
    }
    
    func refreshConfig() {
        GeideaPaymentAPI.getMerchantConfig(completion:{ response, error in
            guard let config = response else {
                self.configBtn.isHidden = true
                self.merchantConfig = nil
                self.configureComponents()
                return
            }
            self.configBtn.isHidden = false
            self.merchantConfig = config
            self.configureComponents()
        })
    }
    
    func configureComponents() {
        captureBtn.isHidden = orderId == nil
        captureLabel.isHidden = orderId == nil
        
        inputs = [amountTF, currencyTF, cardHolderNameTF, cardNumberTF, cvvTF, expiryMonthTF, expiryYearTF, emailTF, callbackTF, publicKeyTF, passwordTF, billingCountryCodeTF, billingCityTF, billingStreetTF, billingPostalCodeTF, shippingCountryCodeTF, shippingCityTF, shippingStreetTF, shippingPostalCodeTF, agreementIdTF, agreementTypeTF]
        
        inputs.forEach {
            $0.delegate = self
        }
        
        loginSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        if GeideaPaymentAPI.isCredentialsAvailable() {
            loginSwitch.setOn(true, animated: true)
            loginLabel.text = "Already Loggedin"
            passwordTF.isEnabled = false
            publicKeyTF.isEnabled = false
            applePayBtnView.isHidden = false
        } else {
            loginSwitch.setOn(false, animated: true)
            loginLabel.text = "Login"
            passwordTF.isEnabled = true
            publicKeyTF.isEnabled = true
            applePayBtnView.isHidden = true
        }
        
        guard let isTokenizationEnabled = merchantConfig?.isTokenizationEnabled, isTokenizationEnabled else {
            cardOnFileView.isHidden = true
            cardOnFileSwitch.setOn(false, animated: false)
            initiatedByView.isHidden = true
            self.customerDetailsTopConstraint.constant = self.customerDetailsTopConstraintConstant - 210
            return
        }
        
        cardOnFileView.isHidden = false
        if !cardOnFileSwitch.isOn {
            initiatedByView.isHidden = true
            self.customerDetailsTopConstraint.constant = self.customerDetailsTopConstraintConstant - 170
        } else {
            initiatedByView.isHidden = false
            self.customerDetailsTopConstraint.constant = self.customerDetailsTopConstraintConstant
        }
        
        showPayWithToken()
        
    }
    
    private func showPayWithToken() {
        if let tokens = getTokens() {
            for token in tokens {
                if token["environment"] as! Int == 0{
                    payTokenBtn.isHidden = false
                } else {
                    payTokenBtn.isHidden = true
                }
            }
        } else {
            payTokenBtn.isHidden = true
        }
    }
    
    private func unfocusFields() {
        inputs.forEach {
            $0.endEditing(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == amountTF || textField == currencyTF {
            setupAppplePay()
        }
        
        if textField == cardNumberTF  {
            detectCardScheme()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unfocusFields()
        return true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        unfocusFields()
    }
    
    @IBAction func generateInvoiceTapped(_ sender: Any) {
        
        GeideaPaymentAPI.startEInvoice(withEInvoiceID: eInvoiceTF.text, viewController: self, completion: { response, error in
            
            
            if let err = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)")
                    }
                }
            } else {
                guard let eInvoice = response?.eInvoice else {
                    return
                }
                
                if let safeResponse = response,  let orderString = GeideaPaymentAPI.getEInvoiceString(order: safeResponse) {
                    let vc = SuccessViewController()
                    vc.json = orderString
                    self.present(vc, animated: true, completion: nil)
                }
                
                self.eInvoiceTF.text = eInvoice.eInvoiceId
                
                
            }
        })
        
    }
    
    @IBAction func cardOnFileSwitchTapped(_ sender: Any) {
        configureComponents()
    }
    
    @IBAction func paymentMethodSelected(_ sender: Any) {
        switch paymentMethodSelection.selectedSegmentIndex {
        case 0:
            paymentDetailsView.isHidden = true
            showAddressView.isHidden = false
            break
        case 1:
            paymentDetailsView.isHidden = false
            showAddressView.isHidden = true
            break
        default:
            break
        }
    }
    
    @IBAction func initiatedByTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Initiated By", message: "Please Select the initiated by option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Internet", style: .default , handler:{ (UIAlertAction)in
            self.initiatedByButton.setTitle("Internet", for: .normal)
            self.cardOnFileView.isHidden = false
            self.agreementTypeTF.isHidden = false
            self.agreementType.isHidden = false
        }))
        
        alert.addAction(UIAlertAction(title: "Merchant", style: .default , handler:{ (UIAlertAction)in
            self.initiatedByButton.setTitle("Merchant", for: .normal)
            self.cardOnFileView.isHidden = true
            self.agreementTypeTF.isHidden = true
            self.agreementType.isHidden = true
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func switchChanged(loginSwitch: UISwitch) {
        
        if !loginSwitch.isOn {
            GeideaPaymentAPI.removeCredentials()
        }
        configureComponents()
    }
    
    @IBAction func showConfigTapped(_ sender: Any) {
        
        if let config = merchantConfig,  let orderString = GeideaPaymentAPI.getConfigString(config: config) {
            let vc = SuccessViewController()
            vc.json = orderString
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func captureTapped(_ sender: Any) {
        guard let id = orderId else {
            return
        }
        
        if captureBtn.title(for: .normal) == "Refund" {
            refund(with: id)
        } else {
           capture(with: id)
        }
    }
    
    @IBAction func paymentOperationTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Payment operation", message: "Please Select the payment operation", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Pay", style: .default , handler:{ (UIAlertAction)in
            self.paymentOperationBtn.setTitle("Pay", for: .normal)
            self.paymentOperation = PaymentOperation.pay
        }))
        
        alert.addAction(UIAlertAction(title: "PreAuthorize", style: .default , handler:{ (UIAlertAction)in
            self.paymentOperationBtn.setTitle("PreAuthorize", for: .normal)
            self.paymentOperation = PaymentOperation.preAuthorize
        }))
        
        alert.addAction(UIAlertAction(title: "AuthorizeCapture", style: .default , handler:{ [self] (UIAlertAction)in
            self.paymentOperationBtn.setTitle("AuthorizeCapture", for: .normal)
            self.paymentOperation = PaymentOperation.authorizeCapture
        }))
        
        alert.addAction(UIAlertAction(title: "NONE", style: .cancel, handler:{ (UIAlertAction)in
            self.paymentOperationBtn.setTitle("NONE", for: .normal)
            self.paymentOperation = PaymentOperation.NONE
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func LoginTapped(_ sender: Any) {
        guard let publicKey = publicKeyTF.text, let password = passwordTF.text, !publicKey.isEmpty, !password.isEmpty else {
            return
        }
        
        GeideaPaymentAPI.updateCredentials(withMerchantKey: publicKeyTF.text ?? "", andPassword: passwordTF.text ?? "")
        loginSwitch.setOn(true, animated: true)
        refreshConfig()
        setupAppplePay()
    }
    
    
    @IBAction func payTokenTapped(_ sender: Any) {
        if !GeideaPaymentAPI.isCredentialsAvailable() {
            GeideaPaymentAPI.setCredentials(withMerchantKey:  publicKeyTF.text ?? "", andPassword: passwordTF.text ?? "")
        }
        
        let alert = UIAlertController(title: "Token Id", message: "Please Select the card with token ", preferredStyle: .actionSheet)
        
        if let myTokens = getTokens() {
            for token in myTokens {
                if token["environment"] as! Int == 0 {
                    
                    alert.addAction(UIAlertAction(title: " \((token["maskedCardNumber"] as! String).suffix(4) ): \(token["tokenId"] ?? "")", style: .default , handler:{ (UIAlertAction)in
                        self.payWithToken(tokenId: token["tokenId"] as! String)
                    }))
                    
                }
            }
        }
        alert.addAction(UIAlertAction(title: "CLEAR TOKENS", style: .default, handler:{ (UIAlertAction) in
            self.clearTokens()
        }))
        
        alert.addAction(UIAlertAction(title: "DISMISS", style: .cancel, handler:{ (UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func payTapped(_ sender: Any) {
        if !GeideaPaymentAPI.isCredentialsAvailable() {
            GeideaPaymentAPI.setCredentials(withMerchantKey:  publicKeyTF.text ?? "", andPassword: passwordTF.text ?? "")
        }
        guard let safeAmount = Double(amountTF.text ?? "") else {
            return
        }
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "")
        
        let shippingAddress = GDAddress(withCountryCode: shippingCountryCodeTF.text, andCity: shippingCityTF.text, andStreet: shippingStreetTF.text, andPostCode: shippingPostalCodeTF.text)
        let billingAddress = GDAddress(withCountryCode: billingCountryCodeTF.text, andCity: billingCityTF.text, andStreet: billingStreetTF.text, andPostCode: billingPostalCodeTF.text)
        let customerDetails = GDCustomerDetails(withEmail: emailTF.text, andCallbackUrl: callbackTF.text, merchantReferenceId: merchentRefidTF.text, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: paymentOperation)
        
        var eInvoiceidString: String? = nil
        if let eInvoiceid = eInvoiceTF.text, !eInvoiceid.isEmpty {
            eInvoiceidString = eInvoiceTF.text
        }
        
        if paymentMethodSelection.selectedSegmentIndex == 1 {
            guard let safeExpiryMonth = Int(expiryMonthTF.text ?? "") else {
                return
            }
            
            guard let safeExpiryYear = Int(expiryYearTF.text ?? "") else {
                return
            }
            
            let cardDetails = GDCardDetails(withCardholderName: cardHolderNameTF.text ?? "", andCardNumber:  cardNumberTF.text ?? "", andCVV: cvvTF.text ?? "", andExpiryMonth: safeExpiryMonth, andExpiryYear: safeExpiryYear)
            var initiatedByString = initiatedByButton.currentTitle
            if !cardOnFileSwitch.isOn {
                initiatedByString =
                    nil
            }
            let tokenizationDetails = GDTokenizationDetails(withCardOnFile:  cardOnFileSwitch.isOn, initiatedBy: initiatedByString, agreementId: agreementIdTF.text, agreementType: agreementTypeTF.text)
            pay(amount: amount, cardDetails: cardDetails, tokenizationDetails: tokenizationDetails, eInvoice: eInvoiceidString, customerDetails: customerDetails)
        } else {
            payWithGeideaForm(amount: amount, customerDetails: customerDetails, eInvoiceId: eInvoiceidString)
        }
        
    }
    
    func refund(with id: String) {
        GeideaPaymentAPI.refund(with: id, callbackUrl: callbackTF.text, navController: self, completion:{ response, error in
            if let err = error {
                if err.errors.isEmpty {
                    var message = ""
                    if err.responseCode.isEmpty {
                        message = "\n responseMessage: \(err.responseMessage)"
                        
                    } else if !err.orderId.isEmpty {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                    } else {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                    }
                    self.displayAlert(title: err.title,  message: message)
                    
                } else {
                    self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)")
                }
            } else {
                guard let orderResponse = response else {
                    return
                }
                
                if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                    let vc = SuccessViewController()
                    vc.json = orderString
                    self.present(vc, animated: true, completion: nil)
                }
                self.orderId = nil
                self.configureComponents()
            }
        })
    }
    
    func capture(with id: String) {
        GeideaPaymentAPI.capture(with: id, callbackUrl: callbackTF.text, navController: self, completion:{ response, error in
            if let err = error {
                if err.errors.isEmpty {
                    var message = ""
                    if err.responseCode.isEmpty {
                        message = "\n responseMessage: \(err.responseMessage)"
                        
                    } else if !err.orderId.isEmpty {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                    } else {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                    }
                    self.displayAlert(title: err.title,  message: message)
                    
                } else {
                    self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)")
                }
            } else {
                guard let orderResponse = response else {
                    return
                }
                
                if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                    let vc = SuccessViewController()
                    vc.json = orderString
                    self.present(vc, animated: true, completion: nil)
                }
//                self.orderId = nil
                self.captureBtn.setTitle("Refund", for: .normal)
                self.configureComponents()
                
            }
        })
    }
    
    func payWithToken(tokenId: String) {
        guard let safeAmount = Double(amountTF.text ?? "") else {
            return
        }
        
        var eInvoiceIdString: String? = nil
        if let eInvoiceid = eInvoiceTF.text, !eInvoiceid.isEmpty {
            eInvoiceIdString = eInvoiceTF.text
        }
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "")
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: cardOnFileSwitch.isOn, initiatedBy: initiatedByButton.currentTitle, agreementId: agreementIdTF.text, agreementType: agreementTypeTF.text)
        let shippingAddress = GDAddress(withCountryCode: shippingCountryCodeTF.text, andCity: shippingCityTF.text, andStreet: shippingStreetTF.text, andPostCode: shippingPostalCodeTF.text)
        let billingAddress = GDAddress(withCountryCode: billingCountryCodeTF.text, andCity: billingCityTF.text, andStreet: billingStreetTF.text, andPostCode: billingPostalCodeTF.text)
        let customerDetails = GDCustomerDetails(withEmail: emailTF.text, andCallbackUrl: callbackTF.text, merchantReferenceId: merchentRefidTF.text, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: paymentOperation)
        
        GeideaPaymentAPI.payWithToken(theAmount: amount, withTokenId: tokenId, tokenizationDetails: tokenizationDetails, andEInvoiceId: eInvoiceIdString, andCustomerDetails: customerDetails, navController: self, completion:{ response, error in
            DispatchQueue.main.async {
                
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: nil, eInvoice: self.eInvoiceTF.text, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: nil, eInvoice: self.eInvoiceTF.text, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                    }
                } else {
                    guard let orderResponse = response else {
                        return
                    }
                    
                    if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    if orderResponse.detailedStatus == "Authorized" {
                        self.orderId = orderResponse.orderId
                        self.captureLabel.text = self.orderId
                        self.configureComponents()
                    }
                }
            }
        })
    }
    
    func pay(amount: GDAmount, cardDetails: GDCardDetails, tokenizationDetails: GDTokenizationDetails?, eInvoice: String?, customerDetails: GDCustomerDetails?) {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
            return
        }
        
        GeideaPaymentAPI.pay(theAmount: amount, withCardDetails: cardDetails, andTokenizationDetails: tokenizationDetails, andEInvoice: eInvoice,andCustomerDetails: customerDetails, navController: self, completion:{ response, error in
            DispatchQueue.main.async {
                
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: cardDetails, eInvoice: self.eInvoiceTF.text, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: cardDetails, eInvoice: self.eInvoiceTF.text, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                    }
                } else {
                    guard let orderResponse = response else {
                        return
                    }
                    
                    if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    if orderResponse.detailedStatus == "Authorized" {
                        self.orderId = orderResponse.orderId
                        self.captureLabel.text = self.orderId
                        self.captureBtn.setTitle("Capture", for: .normal)
                        self.configureComponents()
                    } else if orderResponse.detailedStatus == "Paid" || orderResponse.detailedStatus == "Captured"  {
                        self.orderId = orderResponse.orderId
                        self.captureLabel.text = self.orderId
                        self.captureBtn.setTitle("Refund", for: .normal)
                        self.configureComponents()
                    }
                    
                    if let tokenId = orderResponse.tokenId, let cardNumber = orderResponse.paymentMethod?.maskedCardNumber {
                        
                        self.saveTokenId(tokenId: tokenId, maskedCardNumber: cardNumber)
                    }
                }
            }
        })
    }
    
    func payWithGeideaForm(amount: GDAmount, customerDetails: GDCustomerDetails?, eInvoiceId: String?) {
        
        let applePayDetails = GDApplePayDetails(forMerchantIdentifier: "merchant.geidea.test.applepay", withCallbackUrl: callbackTF.text, andReferenceId:  merchentRefidTF.text)
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: cardOnFileSwitch.isOn, initiatedBy: initiatedByButton.currentTitle, agreementId: agreementIdTF.text, agreementType: agreementTypeTF.text)
        
        GeideaPaymentAPI.payWithGeideaForm(theAmount: amount, showAddress: showAddressSwitch.isOn, showEmail: showEmailSwitch.isOn, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePayDetails: applePayDetails, config: self.merchantConfig, eInvoiceId: eInvoiceId, viewController: self, completion:{ response, error, applePayResponse  in
            DispatchQueue.main.async {
                
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: nil, eInvoice: self.eInvoiceTF.text, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: nil, eInvoice: self.eInvoiceTF.text, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if let response = applePayResponse {
                            let message = "\n responseCode: \(response.responseCode)  \n responseMessage: \(response.responseMessage) \n detailedResponseCode: \(response.detailedResponseCode)  \n detailedResponseMessage: \(response.detailedResponseMessage) \n orderId: \(response.orderId)"
                            self.displayAlert(title: "APPLE PAY payment was successful", message: message)
                        }
                    }
                    
                    guard let orderResponse = response else {
                        return
                    }
                    
                    if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    if orderResponse.detailedStatus == "Authorized" {
                        self.orderId = orderResponse.orderId
                        self.captureLabel.text = self.orderId
                        self.configureComponents()
                    }
                    
                    if let tokenId = orderResponse.tokenId, let cardNumber = orderResponse.paymentMethod?.maskedCardNumber {
                        
                        self.saveTokenId(tokenId: tokenId, maskedCardNumber: cardNumber)
                    }
                }
            }
        })
    }
    
    func detectCardScheme() {
        
        cardSchemeLogoIV.image = nil
        let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
            cardSchemeLogoIV.image = GeideaPaymentAPI.getCardSchemeLogo(withCardNumber: cardNumber)
        
    }
    
    func displayAlert(title: String, message: String, amount: GDAmount, cardDetails: GDCardDetails?, eInvoice: String?, tokenizationDetails: GDTokenizationDetails?, customerDetails: GDCustomerDetails? ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "RETRY", style: .default, handler: {_ in
            DispatchQueue.main.async { [weak self] in
                if let safeCardDetails = cardDetails {
                    self?.pay(amount: amount, cardDetails: safeCardDetails, tokenizationDetails: tokenizationDetails, eInvoice: eInvoice ?? "", customerDetails: customerDetails)
                } else {
                    self?.payWithGeideaForm(amount: amount, customerDetails: customerDetails, eInvoiceId: eInvoice)
                }
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        let activeField: UITextField? = inputs.first { $0.isFirstResponder }
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func setupAppplePay() {
        applePayBtnView.isHidden = false
        guard let safeAmount = Double(amountTF.text ?? "") else {
            return
        }
        
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "")
        let applePayDetails = GDApplePayDetails(in: self, andButtonIn: applePayBtnView, forMerchantIdentifier: "merchant.geidea.test.applepay", withCallbackUrl: callbackTF.text, andReferenceId:  merchentRefidTF.text)
        GeideaPaymentAPI.setupApplePay(forApplePayDetails: applePayDetails, with: amount, config: merchantConfig, completion: { response, error in
            if let err = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    var message = ""
                    message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                    self.displayAlert(title: err.title, message: message)
                }
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    guard let response = response else {
                        return
                    }
                    
                    let message = "\n responseCode: \(response.responseCode)  \n responseMessage: \(response.responseMessage) \n detailedResponseCode: \(response.detailedResponseCode)  \n detailedResponseMessage: \(response.detailedResponseMessage) \n orderId: \(response.orderId)"
                    self.displayAlert(title: "APPLE PAY payment succesfully", message: message)
                }
            }
        })
    }
    
    func saveTokenId(tokenId: String, maskedCardNumber: String) {
        var tokens: [[String: Any]] = []
        if let myTokens = getTokens() {
            tokens = myTokens
            var index = 0
            for token in myTokens {
                if token["tokenId"] as! String == tokenId {
                    if tokens.count > index {
                        tokens.remove(at: index)
                    }
                }
                index += 1
            }
        }
        tokens.append(["environment": 0, "maskedCardNumber": maskedCardNumber, "tokenId": tokenId])
        UserDefaults.standard.set(tokens, forKey: "myTokens")
    }
    
    func getTokens() -> [[String: Any]]? {
        if let tokens = UserDefaults.standard.array(forKey: "myTokens") as? [[String: Any]] {
            return tokens
        }
        return nil
    }
    
    func clearTokens() {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "myTokens")
        defaults.synchronize()
        
    }
}
