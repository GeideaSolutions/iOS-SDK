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
    @IBOutlet weak var environmentSelection: UISegmentedControl!
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
    @IBOutlet weak var payQRBtn: UIButton!
    @IBOutlet weak var configBtn: UIButton!
    @IBOutlet weak var initiatedByViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customerDetailsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var paymentMethodsTF: UITextField!
    
    @IBOutlet weak var showReceiptSwitch: UISwitch!
    @IBOutlet weak var paymentIntentTF: UITextField!
    @IBOutlet weak var showAddressSwitch: UISwitch!
    @IBOutlet weak var showAddressView: UIView!
    @IBOutlet weak var showEmailSwitch: UISwitch!
    @IBOutlet weak var cardSchemeLogoIV: UIImageView!
    @IBOutlet weak var generateInvoice: UIButton!
    
    @IBOutlet weak var geideaGoBtn: UIButton!
    @IBOutlet weak var languageSelectionControl: UISegmentedControl!
    
    @IBOutlet weak var is3DSReqV2Switch: UISwitch!
    @IBOutlet weak var isCVVReqSwitch: UISwitch!
    
    
    @IBOutlet weak var paymentMethodsSV: UIStackView!
    private var inputs: [UITextField]!
    var paymentOperation: PaymentOperation = .NONE
    var orderId: String?
    var status: String?
    var type: String?
    var customerDetailsTopConstraintConstant: CGFloat = 0
    var initiatedByViewHeight: CGFloat = 0
    var paymentMethodViewHeight: CGFloat = 345
    var merchantConfig: GDConfigResponse?
    var paymentMethodsViews: [PMView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        environmentSelection.selectedSegmentIndex = 1
        #else
        environmentSelection.isHidden = true
        environmentSelection.selectedSegmentIndex = 3
        #endif
        if let savedLanguageIndex = UserDefaults.standard.object(forKey: "language") {
            
            languageSelectionControl.selectedSegmentIndex = savedLanguageIndex as! Int
        }
        languageSelectionControl.sendActions(for: UIControl.Event.valueChanged)
        
        environmentSelection.sendActions(for: UIControl.Event.valueChanged)
        
        
        paymentMethodSelection.selectedSegmentIndex = 0
        paymentMethodSelection.sendActions(for: UIControl.Event.valueChanged)
        
        
        self.title = "Payment Sample Swift"
        scrollView.keyboardDismissMode = .onDrag
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.contentView.addGestureRecognizer(tap)
        
        setupAppplePay()
        initiatedByViewHeight = initiatedByView.bounds.height
        customerDetailsTopConstraintConstant =  customerDetailsTopConstraint.constant
        self.customerDetailsTopConstraint.constant = self.customerDetailsTopConstraintConstant - 20
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Features", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    @IBAction func addPaymentOptionTapped(_ sender: Any) {
        let pmView = PMView()
        paymentMethodsSV.addArrangedSubview(pmView)
        paymentMethodsViews.append(pmView)
    }
    
    @objc func addTapped() {
        
        
        showFeaturesAS()
        
    }
    
    func showFeaturesAS() {
        
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
            return
        }
        
        let alert = UIAlertController(title: "Choose feature", message: "Please Select what feature you need", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Orders", style: .default , handler:{ (UIAlertAction)in
            
            let vc = OrdersViewController()
            navigationController.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Payment Intent / EInvoice", style: .default , handler:{ (UIAlertAction)in
            GeideaPaymentAPI.startPaymentIntent(withPaymentIntentID: self.paymentIntentTF.text, status: self.status, type: self.type ?? "EInvoice", currency: self.merchantConfig?.currencies?.first, viewController: self, completion: { response, error in
                
                
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
                    guard let paymentIntent = response?.paymentIntent else {
                        return
                    }
                    
                    if let safeResponse = response,  let orderString = GeideaPaymentAPI.getPaymentIntentString(order: safeResponse) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    self.paymentIntentTF.text = paymentIntent.paymentIntentId
                    self.status = paymentIntent.status
                    self.type = paymentIntent.type
                    
                }
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
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
        
        if let config = merchantConfig {
            payQRBtn.isHidden = !(config.isMeezaQrEnabled )
        }
        
        if let config = merchantConfig {
            
            if config.merchantCountryTwoLetterCode == "EG" {
                currencyTF.text = "EGP"
            } else {
                currencyTF.text = config.currencies?.first
            }
            
        }
        
        
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
    
    private func showPayQRAlert() {
        
        let customerDetails = GDPICustomer(phoneNumber: nil, andPhoneCountryCode: nil,andEmail: nil, name: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  Locale(identifier: "en_us")
//        let expiryDate = dateFormatter.string(from: Date().adding(days: 90))
        
        
        let vc = QRPaymentDetailsViewController()
        vc.amount = Double(amountTF.text ?? "") ?? 0
        vc.currency = currencyTF.text ?? "EGP"
        vc.name = customerDetails.name
        vc.email = customerDetails.email
        vc.phoneNumber = customerDetails.phoneNumber
        vc.callbackUrl = callbackTF.text
        vc.expiryDate = nil
        vc.showReceipt = showReceiptSwitch.isOn
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
            return
        }
        
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    private func showPayWithToken() {
        if let tokens = getTokens() {
            for token in tokens {
                if token["environment"] as! Int == environmentSelection.selectedSegmentIndex {
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
    
    @IBAction func mConfigTapped(_ sender: Any) {
        let params = GDProductMConfig(withMerchantId: nil, andStoreId: nil, isTest: true)
        let configParams = GDSDKMerchantConfig(withToken: "bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ0LTMzREp2TTNFaGF0MUxDQTJwRGdVRmYxa0xUU1JBM2ZRU2lJOXUwNVlZIn0.eyJleHAiOjE2MzUzNDE3MjAsImlhdCI6MTYzNTM0MTQyMCwianRpIjoiMmEyNzIwYzgtMjljZi00NmY1LTk0NDQtNjYzZGIwZWNjNDBmIiwiaXNzIjoiaHR0cHM6Ly9hcGkuZ2QtcHByb2QtaW5mcmEubmV0L2F1dGgvcmVhbG1zL3ByZXByb2QiLCJhdWQiOlsiZ3Nkay1iYWNrZW5kIiwiZ3Nkay1iYWNrZW5kLWVneXB0IiwiYWNjb3VudCJdLCJzdWIiOiI0ZDJlMWRkOS1mZWIzLTRiM2ItOTE1Yy0xZTZjM2JlMGI0MWYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJwb3J0YWwiLCJzZXNzaW9uX3N0YXRlIjoiOGNmNDE4ODYtYTQzMy00Y2E1LWJkZDMtZDEwYTdkZTY3NjI1IiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwczovL2FwaS5nZC1wcHJvZC1pbmZyYS5uZXQiLCJodHRwczovL3d3dy5nZC1wcHJvZC1pbmZyYS5uZXQiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJnc2RrLWJhY2tlbmQiOnsicm9sZXMiOlsibWVyY2hhbnQiXX0sImdzZGstYmFja2VuZC1lZ3lwdCI6eyJyb2xlcyI6WyJtZXJjaGFudCJdfSwicG9ydGFsIjp7InJvbGVzIjpbIm1lcmNoYW50LWdlbmVyYWwiXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSBncm91cHMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsIm5hbWUiOiJBbm5hIFRlc3RpbmciLCJncm91cHMiOlsibWVyY2hhbnQiXSwicHJlZmVycmVkX3VzZXJuYW1lIjoiMjA5NTg3NDU4OTYyIiwiZ2l2ZW5fbmFtZSI6IkFubmEiLCJmYW1pbHlfbmFtZSI6IlRlc3RpbmciLCJlbWFpbCI6ImFubmEudGVzdGluZ0BlbmRhdmEuYmcifQ.ZUZGwSAENq76_QdvKfBzSAun7dLoG2vP9mYohvZoNKONUCnCTP7vqqKDNeyQtiEubkU1HFhSuz_dMuGhKrg1PkevATlSjJoMopmmEy_e_BJ3570DrkhgnKdrC_hUh34kXpsKXC9EOFZIc3tfkJuVVeXYngIxRc_yBEQwaa39D-N7WM4fskzN7IlPh9GndFeNNLa10DxpjDmioLG3YQBavepMAh2rtPiEiuxVZrdH-OEst020bMou17lmsm4RwcTRDdeU_4_-SEYvh-T1v-nE0aMraVpcLsiQkyNDe0FNzSHcG_-v-5bh2P8Pk4ZxrymMw2UMjSZVW5OH4t_aoeeoLw", andCountryHeader: "GEIDEA_EGYPT", params: params)
        GeideaPaymentAPI.getMerchantConfig(with: configParams, completion: { config, error in
            if let safeConfig = config?.first {
                print(safeConfig.data?.merchantGatewayKey ?? "")
            } else {
                print(error?.responseMessage ?? "")
            }
        })
    }
    
    @IBAction func geideaGoTapped(_ sender: Any) {
        
        let application = UIApplication.shared
        if let appUrl = URL(string: "geideago://PaymentMethods?total=23.35&govTax=15&currency=SAR&callbackLink=geideagocbk://hostMethod?merchantReferenceId=idRef123") {
            if application.canOpenURL(appUrl) {
                application.open(appUrl, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "itms://apps.apple.com/us/app/geidea/id1519264188") {
                    if application.canOpenURL(url) {
                        application.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func generateInvoiceTapped(_ sender: Any) {
        
        GeideaPaymentAPI.startPaymentIntent(withPaymentIntentID: paymentIntentTF.text, status: self.status, type: self.type ?? "EInvoice", currency: self.merchantConfig?.currencies?.first, viewController: self, completion: { response, error in
            
            
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
                guard let paymentIntent = response?.paymentIntent else {
                    return
                }
                
                if let safeResponse = response,  let orderString = GeideaPaymentAPI.getPaymentIntentString(order: safeResponse) {
                    let vc = SuccessViewController()
                    vc.json = orderString
                    self.present(vc, animated: true, completion: nil)
                }
                
                self.paymentIntentTF.text = paymentIntent.paymentIntentId
                
                
            }
        })
        
    }
    
    @IBAction func cardOnFileSwitchTapped(_ sender: Any) {
        configureComponents()
    }
    
    @IBAction func languageSelection(_ sender: Any) {
        
        switch languageSelectionControl.selectedSegmentIndex {
        case 0:
            GeideaPaymentAPI.setlanguage(language: Language.english)
            UserDefaults.standard.set(Language.english.rawValue, forKey: "language")
            
            break
        case 1:
            GeideaPaymentAPI.setlanguage(language: Language.arabic)
            
            UserDefaults.standard.set(Language.arabic.rawValue, forKey: "language")
            
            break
        default:
            break
        }
        
        
        
        if #available(iOS 13.0, *) {
            if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                mySceneDelegate.resetViewController()
            }
        } else {
            ( UIApplication.shared.delegate as! AppDelegate?)?.resetViewController()
        }
        
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
    
    @IBAction func envSelectionTapped(_ sender: Any) {
        switch environmentSelection.selectedSegmentIndex {
        case 0: GeideaPaymentAPI.setEnvironment(environment: Environment.dev)
            break
        case 1: GeideaPaymentAPI.setEnvironment(environment: Environment.test)
            break
        case 2: GeideaPaymentAPI.setEnvironment(environment: Environment.preprod)
            break
        case 3: GeideaPaymentAPI.setEnvironment(environment: Environment.prod)
            break
        default:
            break
        }
        
        self.paymentIntentTF.text = ""
        refreshConfig()
        showPayWithToken()
        setupAppplePay()
    }
    
    @IBAction func payTokenTapped(_ sender: Any) {
        if !GeideaPaymentAPI.isCredentialsAvailable() {
            GeideaPaymentAPI.setCredentials(withMerchantKey:  publicKeyTF.text ?? "", andPassword: passwordTF.text ?? "")
        }
        
        let alert = UIAlertController(title: "Token Id", message: "Please Select the card with token ", preferredStyle: .actionSheet)
        
        if let myTokens = getTokens() {
            for token in myTokens {
                if token["environment"] as! Int == environmentSelection.selectedSegmentIndex {
                    
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
        
        
        var paymentIntentIdString: String? = nil
        if let paymentIntentId = paymentIntentTF.text, !paymentIntentId.isEmpty {
            
            paymentIntentIdString = paymentIntentTF.text
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
            pay(amount: amount, cardDetails: cardDetails, tokenizationDetails: tokenizationDetails, paymentIntentId: paymentIntentIdString, customerDetails: customerDetails)
        } else {
            var initiatedByString = initiatedByButton.currentTitle
            if !cardOnFileSwitch.isOn {
                initiatedByString =
                    nil
            }
            let tokenizationDetails = GDTokenizationDetails(withCardOnFile:  cardOnFileSwitch.isOn, initiatedBy: initiatedByString, agreementId: agreementIdTF.text, agreementType: agreementTypeTF.text)
            payWithGeideaForm(amount: amount, tokenizationDetails: tokenizationDetails,  customerDetails: customerDetails,  paymentIntentId: paymentIntentIdString)
        }
        
    }
    
    @IBAction func payQRTapped(_ sender: Any) {
        if !GeideaPaymentAPI.isCredentialsAvailable() {
            GeideaPaymentAPI.setCredentials(withMerchantKey:  publicKeyTF.text ?? "", andPassword: passwordTF.text ?? "")
        }
        
        showPayQRAlert()
        
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
        
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "")
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: cardOnFileSwitch.isOn, initiatedBy: initiatedByButton.currentTitle, agreementId: agreementIdTF.text, agreementType: agreementTypeTF.text)
        let shippingAddress = GDAddress(withCountryCode: shippingCountryCodeTF.text, andCity: shippingCityTF.text, andStreet: shippingStreetTF.text, andPostCode: shippingPostalCodeTF.text)
        let billingAddress = GDAddress(withCountryCode: billingCountryCodeTF.text, andCity: billingCityTF.text, andStreet: billingStreetTF.text, andPostCode: billingPostalCodeTF.text)
        let customerDetails = GDCustomerDetails(withEmail: emailTF.text, andCallbackUrl: callbackTF.text, merchantReferenceId: merchentRefidTF.text, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: paymentOperation)
        
        var paymentIntentIdString: String? = nil
        if let paymentIntentId = paymentIntentTF.text, !paymentIntentId.isEmpty {
            paymentIntentIdString = paymentIntentId
        }
        
        GeideaPaymentAPI.payWithToken(theAmount: amount, withTokenId: tokenId, tokenizationDetails: tokenizationDetails, config: merchantConfig, showReceipt: showReceiptSwitch.isOn, andPaymentIntentId: paymentIntentIdString, andCustomerDetails: customerDetails, navController: self, completion:{ response, error in
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
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: nil, paymentIntentId: paymentIntentIdString, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: nil, paymentIntentId: paymentIntentIdString, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
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
    
    func pay(amount: GDAmount, cardDetails: GDCardDetails, tokenizationDetails: GDTokenizationDetails?, paymentIntentId
                : String?, customerDetails: GDCustomerDetails?) {
//        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
//            return
//        }
        
        var paymentMethods = paymentMethodsTF.text?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        
        if let  pmTF = paymentMethodsTF.text, pmTF.isEmpty {
            paymentMethods = nil
        }
        
        GeideaPaymentAPI.pay(theAmount: amount, withCardDetails: cardDetails, config: merchantConfig, showReceipt: showReceiptSwitch.isOn, andTokenizationDetails: tokenizationDetails, andPaymentIntentId: paymentIntentId,andCustomerDetails: customerDetails, paymentMethods: paymentMethods, navController: self, completion:{ response, error in
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
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: cardDetails, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: cardDetails, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
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
                    
                    if let tokenId = orderResponse.tokenId, let cardNumber = orderResponse.paymentMethod?.maskedCardNumber, let _ = orderResponse.paymentMethod?.expiryDate {
                        
                        self.saveTokenId(tokenId: tokenId, maskedCardNumber: cardNumber)
                    }
                }
            }
        })
    }
    
    func payWithGeideaForm(amount: GDAmount, tokenizationDetails: GDTokenizationDetails? = nil, customerDetails: GDCustomerDetails?, paymentIntentId: String? = nil) {
        
        
        var paymentMethods = paymentMethodsTF.text?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        if let  pmTF = paymentMethodsTF.text, pmTF.isEmpty {
            paymentMethods = nil
        }
        let applePayDetails = GDApplePayDetails(forMerchantIdentifier: "merchant.geidea.test.applepay", paymentMethods: paymentMethods, withCallbackUrl: callbackTF.text, andReferenceId:  merchentRefidTF.text)
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: cardOnFileSwitch.isOn, initiatedBy: initiatedByButton.currentTitle, agreementId: agreementIdTF.text, agreementType: agreementTypeTF.text)
        
        var merchantName = merchantConfig?.merchantName
        if languageSelectionControl.selectedSegmentIndex == 1 {
            merchantName = merchantConfig?.merchantNameAr
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_us")
        let expiryDate = dateFormatter.string(from: Date().adding(days: 90))
        
        let qrDetails = GDQRDetails(phoneNumber: nil)
        
        var pmBuilder:[GDPaymentSelectionMetods] = []
        for pmView in paymentMethodsViews {
            if let pm  = pmView.paymentOptions.text, !pm.isEmpty {
                let options = pmView.paymentOptions.text?.trimmingCharacters(in: .whitespaces).components(separatedBy: ",") ?? []
                let selection = GDPaymentSelectionMetods(label: pmView.label.text ?? "", paymentMethods: options)
                pmBuilder.append(selection)
            }
           
        }
        
        let paymentSelectionMethods:[GDPaymentSelectionMetods]? = pmBuilder.isEmpty ? nil : pmBuilder
        
        if !(merchantConfig?.isShahryCpBnplEnabled ??  false || merchantConfig?.isShahryCnpBnplEnabled ??  false || merchantConfig?.isSouhoolaCnpBnplEnabled ??  false) {
            GeideaPaymentAPI.payWithGeideaForm(theAmount: amount, showAddress: showAddressSwitch.isOn, showEmail: showEmailSwitch.isOn, showReceipt: showReceiptSwitch.isOn, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePayDetails: applePayDetails, config: merchantConfig, paymentIntentId: paymentIntentTF.text, qrDetails: qrDetails, cardPaymentMethods: nil, paymentSelectionMethods: paymentSelectionMethods, viewController: self, completion:{ response, error in
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
                            self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: nil, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                            
                        } else {
                            self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: nil, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
                }
            })
        } else {
            let vc = BNPLItemsViewController()
            vc.viewModel =  BNPLItemViewModel(amount: amount, showAddress: showAddressSwitch.isOn, showEmail: showEmailSwitch.isOn, showReceipt: showReceiptSwitch.isOn, customerDetails: customerDetails, tokenizationDetails: tokenizationDetails, applePayDetails: applePayDetails, config: merchantConfig, paymentIntent: paymentIntentTF.text, qrCustomerDetails: qrDetails, paymentMethods: paymentMethods, paymentSelectionMethods: paymentSelectionMethods, isNavController: false, completion:{ response, error in
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
                            self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: nil, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                            
                        } else {
                            self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: nil, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
                }
            })
            self.present(vc, animated: true)
        
        }
        
       
    }
    
    func detectCardScheme() {
        
        cardSchemeLogoIV.image = nil
        let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        cardSchemeLogoIV.image = GeideaPaymentAPI.getCardSchemeLogo(withCardNumber: cardNumber)
        
    }
    
    func displayAlert(title: String, message: String, amount: GDAmount, cardDetails: GDCardDetails?, paymentIntentId: String?, tokenizationDetails: GDTokenizationDetails?, customerDetails: GDCustomerDetails? ) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "RETRY", style: .default, handler: {_ in
                DispatchQueue.main.async { [weak self] in
                    if let safeCardDetails = cardDetails {
                        self?.pay(amount: amount, cardDetails: safeCardDetails, tokenizationDetails: tokenizationDetails, paymentIntentId: paymentIntentId, customerDetails: customerDetails)
                    } else {
                        self?.payWithGeideaForm(amount: amount, customerDetails: customerDetails, paymentIntentId: paymentIntentId)
                    }
                    
                }
            }))
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
       
        
    }
    
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
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
        var paymentMethods = paymentMethodsTF.text?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        if let  pmTF = paymentMethodsTF.text, pmTF.isEmpty {
            paymentMethods = nil
        }
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "")
        let applePayDetails = GDApplePayDetails(in: self, andButtonIn: applePayBtnView, forMerchantIdentifier: "merchant.geidea.test.applepay", paymentMethods: paymentMethods, withCallbackUrl: callbackTF.text, andReferenceId:  merchentRefidTF.text)
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
                    
                    if let orderString = GeideaPaymentAPI.getModelString(order: response) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        self.present(vc, animated: true, completion: nil)
                    }
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
        tokens.append(["environment": environmentSelection.selectedSegmentIndex, "maskedCardNumber": maskedCardNumber, "tokenId": tokenId])
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
