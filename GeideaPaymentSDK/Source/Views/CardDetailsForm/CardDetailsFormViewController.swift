//
//  CardDetailsFormViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 06/01/2021.
//

import Foundation
import PassKit
import JavaScriptCore
import WebKit

//import XCTest

public struct CountryConstants {
    static let SAUDI_ARABIA_EN = "Saudi Arabia"
    static let SAUDI_ARABIA_AR = "المملكة العربية السعودية"
    static let SAUDI_ARABIA_CODE = "SAU"
}

protocol backBtnTappedDelegate {
    func didbackBtnTapped(orderId: String?)
}

class CardDetailsFormViewController: BaseViewController {
    
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var valuLogo: UIImageView!
    @IBOutlet weak var stackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    //    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cardLogo1: UIView!
    @IBOutlet weak var cardLogo2: UIView!
    @IBOutlet weak var cardLogo3: UIView!
    @IBOutlet weak var cardLogo4: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var payTitle: UILabel!
    @IBOutlet weak var applePayBtnView: UIView!
    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var payButton: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var errorRefLabel: UILabel!
    
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var errorCardNumber: UILabel!
    
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var expiryDateTF: UITextField!
    @IBOutlet weak var errorExpiryDate: UILabel!
    
    @IBOutlet weak var cvv: UILabel!
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var errorCVV: UILabel!
    
    @IBOutlet weak var nameOnCard: UILabel!
    @IBOutlet weak var nameOnCardTF: UITextField!
    @IBOutlet weak var errorNameOnCard: UILabel!
    
    @IBOutlet weak var billingAddressLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countrySelectionBtn: RoundedButton!
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var streetTF: RoundedTextField!
    @IBOutlet weak var errorStreetTF: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTF: RoundedTextField!
    @IBOutlet weak var errorCity: UILabel!
    
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var postCodeTF: RoundedTextField!
    @IBOutlet weak var errorPostCode: UILabel!
    
    @IBOutlet weak var sameShippingBtn: UIButton!
    @IBOutlet weak var sameShippingLabel: UILabel!
    
    @IBOutlet weak var billingView: UIView!
    @IBOutlet weak var shippingView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTF: RoundedTextField!
    
    @IBOutlet weak var errorEmail: UILabel!
    
    @IBOutlet weak var shippingAddressTitle: UILabel!
    @IBOutlet weak var shippingCountrySelectionBtn: RoundedButton!
    @IBOutlet weak var shippingCountryLabel: UILabel!
    
    @IBOutlet weak var shippingStreetLabel: UILabel!
    @IBOutlet weak var shippingStreetTF: RoundedTextField!
    @IBOutlet weak var errorShippingStreet: UILabel!
    
    @IBOutlet weak var shippingCityLabel: UILabel!
    @IBOutlet weak var shippingCityTF: RoundedTextField!
    @IBOutlet weak var errorShippingCity: UILabel!
    
    
    @IBOutlet weak var shippingPostCodeLabel: UILabel!
    @IBOutlet weak var shippingPostCodeTF: RoundedTextField!
    @IBOutlet weak var errorShippingPostCode: UILabel!
    
    @IBOutlet weak var countryIcon: UIImageView!
    @IBOutlet weak var shippingCountryIcon: UIImageView!
    
    @IBOutlet weak var errorSnackView: UIView!
    @IBOutlet weak var errorCodeSnackView: UILabel!
    @IBOutlet weak var errorMessageSnackView: UILabel!
    
    @IBOutlet weak var payWithCCLabel: UILabel!
    @IBOutlet weak var cardDetailsLabel: UILabel!
    @IBOutlet weak var alternativePMView: UIView!
    
    @IBOutlet weak var alternativePMViewDefault: AlternativePMView!
    @IBOutlet weak var alternativePMAll: AlternativePMView!
    
    @IBOutlet weak var backBtnView: UIView!
    
    @IBOutlet weak var backBtnTitle: UILabel!
    
    var viewModel: CardDetailsFormViewModel!
    
    
    private var inputs: [UITextField]!
    var chooseCountryAction: (()->())?
    private var cardDetailsTimer: Timer!
    var cardChemeLogos: [UIView]!
    var nameOnCardTimer: Timer? = nil
    let networkGroup = DispatchGroup()
    var bnplVC: BNPLViewController?
    var cancelVC: CancelAlertViewController?
    var selectPMOrderId: String?
    
    var payTapped: Bool = false
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    init() {
        super.init(nibName: "CardDetailsFormViewController", bundle: Bundle(for: CardDetailsFormViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePreferredSize()
        
    }
    
    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width, height: view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
        preferredContentSize = contentView.systemLayoutSizeFitting(targetSize)
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    func dismissAction() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.viewModel.completion(nil, GDErrorResponse().withErrorCode(error: "Unable to find gateway configuration by the provided gateway key", code: "015", detailedResponseMessage: "Unable to find gateway configuration by the provided gateway key"))
            self?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func applePayAction(response: GDOrderResponse?, error: GDErrorResponse?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.completion(response, error)
            self?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func configAction(response: GDConfigResponse?, error: GDErrorResponse?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.completion(nil, error)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkInputs() {
        
        inputs = [cardNumberTF, expiryDateTF, cvvTF, nameOnCardTF]
        if viewModel.showEmail {
            inputs.append(emailTF)
        }
        if viewModel.showAddress {
            if shippingView.isHidden {
                inputs.append(contentsOf: [streetTF, cityTF, postCodeTF])
            } else {
                inputs.append(contentsOf: [streetTF, cityTF, postCodeTF,shippingStreetTF, shippingCityTF, shippingPostCodeTF])
            }
            
        }
        handleTextFields()
    }
    
    func setupViews() {
        
        if viewModel.selectPaymentVM == nil || viewModel.isEmbedded {
            backBtnView.isHidden = true
        }
        
        payButton.enabled(isEnabled: false, config: viewModel.config)
        
        cardChemeLogos = [cardLogo1, cardLogo2, cardLogo3, cardLogo4]
        
        viewModel.shouldHideShippingAddress = viewModel.isBillingAndShippingSame()
        updateSameShippingUI()
        
        checkInputs()
        localizeStrings()
        
        errorSnackView.withBorder(isVisible: true, radius: 0, width: 2)
        
        scrollView.keyboardDismissMode = .onDrag
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.contentView.addGestureRecognizer(tap)
        
        billingView.isHidden = !viewModel.showAddress
        emailView.isHidden = !viewModel.showEmail
        
        showCardScheme()
        
        countrySelectionBtn.tag = 0
        countrySelectionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        shippingCountrySelectionBtn.tag = 1
        shippingCountrySelectionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        applePayView.isHidden = !viewModel.shouldShowApplePay
        
        viewModel.setupUIWithConfig(buttonView: applePayBtnView, vc: self)
        
        viewModel.datasourceRefreshAction = dismissAction
        viewModel.applePayAction = applePayAction
        viewModel.configAction = configAction
        
        cvvTF.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        nameOnCardTF.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        cardNumberTF.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        expiryDateTF.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        if let myImage = UIImage(named: "cvvIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
            cvvTF.withImage(image: myImage)
        }
        
        errorSnackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        errorSnackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        fallbackSystemImage()
        setupEmbededView()
        startTimer()
        setBranding()
        setupActivityIndicator()
    }
    
    
    private func setupActivityIndicator() {
        
        activityIndicator.color = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: viewModel.config)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerImageView.addBottomRoundedEdgeIV(desiredCurve: 1.5)
        }
        
        if let headerColor = viewModel.config?.branding?.headerColor {
            headerImageView.backgroundColor = UIColor(hex: headerColor)
        }
        
        if let logo = viewModel.config?.branding?.logoPublicUrl {
            logoIV.loadFrom(URLAddress: logo)
        }
        
        //        if let backgroundColor = viewModel.config?.branding?.backgroundColor {
        //            contentView.backgroundColor = UIColor(hex: backgroundColor) ?? .white
        //        }
        //
        //        if let backgroundTextColor = viewModel.config?.branding?.backgroundTextColor {
        //            payTitle.textColor = UIColor(hex: backgroundTextColor)
        //
        //        }
        
    }
    
    func setupEmbededView() {
        if let bnpl = self.parent as? BNPLViewController {
            bnplVC = bnpl
            switch bnplVC?.viewModel.provider {
            case .Souhoola:
                switch GlobalConfig.shared.language {
                case .arabic:
                    valuLogo.image = UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
                default:
                    valuLogo.image = UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
                }
                
            case .SHAHRY:
                valuLogo.image = UIImage(named: "shahry_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            case .ValU:
                valuLogo.image = UIImage(named: "valU_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            case .none:
                valuLogo.isHidden = true
            case .NONE:
                valuLogo.isHidden = true
            }
        } else {
            valuLogo.isHidden = true
        }
        
        
        if viewModel.isEmbedded {
            stackTopConstraint.constant = 0
            headerView.isHidden = viewModel.isEmbedded
            errorView.isHidden = viewModel.isEmbedded
            logoIV.isHidden  = viewModel.isEmbedded
            
        } else {
            stackTopConstraint.constant = 140
        }
    }
    
    
    override func localizeStrings() {
        backBtnTitle.text = viewModel.payCardTitleString
        cancelBtn.setTitle(viewModel.cancelButtonTitle, for: .normal)
        payButton.setTitle(viewModel.payButtonTitle(), for: .normal)
        payTitle.text = viewModel.cardDetailsTitle
        cardNumber.text = viewModel.cardNumberTitle
        nameOnCard.text = viewModel.cardNameTitle
        expiryDate.text = viewModel.expiryDateTitle
        cvv.text = viewModel.cvvTitle
        cvvTF.placeholder = viewModel.cvvPlaceholder
        payWithCCLabel.text = viewModel.OrPayTitle
        emailLabel.text = viewModel.emailTitle
        countryLabel.text = viewModel.countryTitle
        cityLabel.text = viewModel.cityTitle
        streetLabel.text = viewModel.streetNameTitle
        postCodeLabel.text = viewModel.postCodeTitle
        shippingCountryLabel.text = viewModel.countryTitle
        shippingCityLabel.text = viewModel.cityTitle
        shippingStreetLabel.text = viewModel.streetNameTitle
        shippingPostCodeLabel.text = viewModel.postCodeTitle
        billingAddressLabel.text = viewModel.billingAddressTitle
        shippingAddressTitle.text = viewModel.shippingAddressTitle
        sameShippingLabel.text = viewModel.sameBillingTitle
        fillAdress()
    }
    
    func startTimer() {
        endTimer()
        if !viewModel.isEmbedded {
            viewModel.orderId = nil
        }
        
        if viewModel.formExpirationInterval > 0 {
            cardDetailsTimer = Timer.scheduledTimer(withTimeInterval: viewModel.formExpirationInterval, repeats: false) { timer in
                if !self.viewModel.isEmbedded {
                    self.errorSnackView.isHidden = true
                    self.showSnackBar(with: GDErrorResponse().withCancelCode(responseMessage: GDErrorCodes.E010.rawValue, code: GDErrorCodes.E010.description, detailedResponseCode: "015", detailedResponseMessage: GDErrorCodes.E010.detailedResponseMessage, orderId: self.viewModel.orderId ?? ""))
                    self.cancelOnTimeout()
                    self.endTimer()
                } else {
                    if let bnplVM = self.bnplVC?.viewModel {
                        if bnplVM.provider == .NONE {
                            self.viewModel.completion(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E010.rawValue, code: GDErrorCodes.E010.description, detailedResponseMessage: GDErrorCodes.E010.detailedResponseMessage))
                        }
                    } else {
                        self.viewModel.completion(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E010.rawValue, code: GDErrorCodes.E010.description, detailedResponseMessage: GDErrorCodes.E010.detailedResponseMessage))
                    }
                    
                    
                }
            }
        }
    }
    
    func endTimer() {
        guard let cardDetailsTimer = cardDetailsTimer else { return }
        cardDetailsTimer.invalidate()
        
        viewModel.hasTimeout = true
    }
    
    
    @objc func handleDismiss(gesture: UIPanGestureRecognizer) {
        
        let interactiveTransition = UIPercentDrivenInteractiveTransition()
        
        let percent = max(gesture.translation(in: view).x, 0) / view.frame.width
        
        switch gesture.state {
            
        case .began:
            break
            
        case .changed:
            interactiveTransition.update(percent)
            
        case .ended:
            let velocity = gesture.velocity(in: view).x
            
            // Continue if drag more than 50% of screen width or velocity is higher than 1000
            if percent > 0.5 || velocity > 1000 {
                interactiveTransition.finish()
                
                errorSnackView.transform = .identity
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [self]() -> Void in
                    errorSnackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { [self](finished: Bool) -> Void in
                    errorSnackView.isHidden = true
                })
            } else {
                interactiveTransition.cancel()
            }
            
        case .cancelled, .failed:
            interactiveTransition.cancel()
            
        default:break
            
        }
    }
    
    func fallbackSystemImage() {
        if #available(iOS 13, *) {
            countryIcon.image = UIImage(systemName: "chevron.down")
            shippingCountryIcon.image = UIImage(systemName: "chevron.down")
            sameShippingBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            
        } else {
            countryIcon.image = UIImage(named: "dropDownIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            shippingCountryIcon.image = UIImage(named: "dropDownIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            sameShippingBtn.setImage(UIImage(named: "selectedIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil), for: .normal)
        }
    }
    
    func fillAdress() {
        
        emailTF.text = viewModel.customerDetails?.customerEmail
        
        switch GlobalConfig.shared.language {
        case .arabic:
            countrySelectionBtn.setTitle(viewModel.getCountryFromCountryCode(countryCode: viewModel.customerDetails?.billingAddress?.countryCode ?? CountryConstants.SAUDI_ARABIA_AR), for: .normal)
        default:
            countrySelectionBtn.setTitle(viewModel.getCountryFromCountryCode(countryCode: viewModel.customerDetails?.billingAddress?.countryCode ?? CountryConstants.SAUDI_ARABIA_EN), for: .normal)
        }
        countrySelectionBtn.setTitle(viewModel.getCountryFromCountryCode(countryCode: viewModel.customerDetails?.billingAddress?.countryCode ?? CountryConstants.SAUDI_ARABIA_EN), for: .normal)
        countrySelectionBtn.metaDataString = viewModel.customerDetails?.billingAddress?.countryCode ?? CountryConstants.SAUDI_ARABIA_CODE
        cityTF.text = viewModel.customerDetails?.billingAddress?.city
        postCodeTF.text = viewModel.customerDetails?.billingAddress?.postCode
        streetTF.text = viewModel.customerDetails?.billingAddress?.street
        
        shippingCountrySelectionBtn.metaDataString = viewModel.customerDetails?.shippingAddress?.countryCode ?? CountryConstants.SAUDI_ARABIA_CODE
        shippingCountrySelectionBtn.setTitle(viewModel.getCountryFromCountryCode(countryCode: viewModel.customerDetails?.shippingAddress?.countryCode ?? CountryConstants.SAUDI_ARABIA_EN), for: .normal)
        shippingCityTF.text = viewModel.customerDetails?.shippingAddress?.city
        shippingPostCodeTF.text = viewModel.customerDetails?.shippingAddress?.postCode
        shippingStreetTF.text = viewModel.customerDetails?.shippingAddress?.street
    }
    
    func handleTextFields() {
        (0..<inputs.count).forEach { index in
            let textField = inputs[index]
            textField.delegate = self
            textField.tag = index
            var buttonText = viewModel.nextTitle
            if index == inputs.count - 1 {
                buttonText = viewModel.doneTitle
            }
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
    
    func clearFieldCursor() {
        for input in inputs {
            input.resignFirstResponder()
        }
    }
    
    
    @IBAction func backBtnTappped(_ sender: Any) {
        
        if viewModel.selectPaymentVM == nil {
            displaySimpleCanceAlert()
        } else {
            if let navController = navigationController {
                
                navController.popViewController(animated: true)
            } else{
                dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    
    @IBAction func sameShippingTapped(_ sender: Any) {
        
        viewModel.shouldHideShippingAddress = !viewModel.shouldHideShippingAddress
        updateSameShippingUI()
        checkInputs()
    }
    
    func updateSameShippingUI() {
        if viewModel.showAddress {
            shippingView.isHidden = viewModel.shouldHideShippingAddress
        }
        
        if viewModel.shouldHideShippingAddress {
            if #available(iOS 13, *) {
                sameShippingBtn.tintColor = UIColor.sameShippingColor
            } else {
                sameShippingBtn.setImage(UIImage(named: "selectedIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil), for: .normal)
            }
        } else {
            if #available(iOS 13, *) {
                sameShippingBtn.tintColor = UIColor.notSameShippingColor
            } else {
                sameShippingBtn.setImage(UIImage(named: "unselectedIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil), for: .normal)
            }
        }
        
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        let message = viewModel.cvvHintTitle
        
        displaySimpleCVVAlert(title: viewModel.cvvTitle, message: message)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        unfocusFields()
    }
    
    @objc func didChangeText(textField:UITextField) {
        let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil) ?? ""
        if textField == cardNumberTF {
            cardNumberTF.text = cardNumberTF.text?.modifyCreditCardString()
            
            self.validateCardNumber(cardNumber: cardNumber)
        } else if textField == expiryDateTF {
            expiryDateTF.text = expiryDateTF.text?.modifyDateCardString()
        } else if textField == nameOnCardTF {
            validateCardName()
        }
        self.errorSnackView.isHidden = true
        isPayButtonValid(cardNumber)
    }
    
    @IBAction func payTapped(_ sender: Any?) {
        
        if (viewModel.config?.useMpgsApiV60 ?? false) {
            
            if let orderId = viewModel.orderId, !orderId.isEmpty {
                payOrder()
            } else {
                startLoading()
                payTapped = true
                
            }
        } else {
            payOrder()
        }
        
    }
    
    func showReceipt(order: GDOrderResponse?, error: GDErrorResponse?) {
        let vc = PaymentFactory.makeReceiptViewController()
        
        vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse:
                                                            order, withError: error, receiptFlow: .CARD, config: viewModel.config, isEmbedded: viewModel.isEmbedded,  completion: { response, error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewModel.completion(order, error)
                self.dismiss(animated: true, completion: nil)
                
                
            }
            
        })
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        displaySimpleCanceAlert()
        //        displayAlert(title: viewModel.cancelPaymentTitle, message: "")
    }
    
    
    @IBAction func shippingCountryTapped(_ sender: Any) {
        showCountrySelection(with: shippingCountrySelectionBtn.tag)
    }
    
    @IBAction func billingCountryTapped(_ sender: Any) {
        showCountrySelection(with: countrySelectionBtn.tag)
    }
    
    func configureAlternativePM() {
        
        if !viewModel.isEmbedded {
            backBtnView.isHidden = true
            alternativePMView.isHidden = false
            
            
            if viewModel.getAlternativePMDefault() != .NONE {
                alternativePMViewDefault.isHidden = false
                alternativePMViewDefault.type = viewModel.getAlternativePMDefault()
                alternativePMViewDefault.configurePMView()
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAlternativeDefault(_:)))
                alternativePMViewDefault.addGestureRecognizer(tap)
            } else {
                alternativePMView.isHidden = true
                backBtnView.isHidden = false
            }
            
            if viewModel.getAlternativePMAll() == .ALL {
                alternativePMAll.isHidden = false
                alternativePMAll.type = .ALL
                alternativePMAll.configurePMView()
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAlternativeAll(_:)))
                alternativePMAll.addGestureRecognizer(tap)
            }
        } else {
            if viewModel.getAlternativePMDefault() == .QR {
                if viewModel.isEmbedded {
                    bnplVC?.stepView.backBtn.isHidden = true
                }
                backBtnView.isHidden = true
                alternativePMView.isHidden = false
                alternativePMViewDefault.isHidden = false
                alternativePMViewDefault.type = viewModel.getAlternativePMDefault()
                alternativePMViewDefault.configurePMView()
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAlternativeDefault(_:)))
                alternativePMViewDefault.addGestureRecognizer(tap)
            }
        }
        
    }
    @objc func handleTapAlternativeAll(_ sender: UITapGestureRecognizer? = nil) {
        errorSnackView.isHidden = true
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTapAlternativeDefault(_ sender: UITapGestureRecognizer? = nil) {
        
        errorSnackView.isHidden = true
        
        switch alternativePMViewDefault.type {
        case .QR:
            
            if !viewModel.isEmbedded {
                if let navController = navigationController {
                    navController.popViewController(animated: true)
                } else{
                    dismiss(animated: true, completion: nil)
                }
            } else {
                bnplVC?.didBackBtnTapped()
            }
        case .SOUHOOLA:
            if  self.viewModel.amount.amount > Double(self.viewModel.config?.souhoolaMinimumAmount ?? 0) {
                if let safeSelectPaymentVM = viewModel.selectPaymentVM {
                    let vc = PaymentFactory.makeBNPLViewController()
                    vc.viewModel = PaymentFactory.makeBNPLViewModel( bnplProvider: .Souhoola, selectPaymentVM: safeSelectPaymentVM, isNavController: true, completion: { order, error in
                        self.viewModel.completion(order, error)
                    })
                    
                    if let navController = navigationController {
                        navController.pushViewController(vc, animated: true)
                    } else {
                        present(vc, animated: false)
                    }
                }
            } else {
                errorSnackView.isHidden = false
                let minAmount = String(self.viewModel.config?.souhoolaMinimumAmount ?? 0)
                errorMessageSnackView.text  = String(format: "SOUHOOLA_INSTALLMENT_AMOUNT".localized, minAmount, self.viewModel.amount.currency )
                errorRefLabel.isHidden = true
                errorCodeSnackView.isHidden = true
            }
        case .VALU:
            
            if self.viewModel.amount.amount >=  Double(self.viewModel.config?.valUMinimumAmount ?? 0) {
                
                if let safeSelectPaymentVM = viewModel.selectPaymentVM {
                    let vc = PaymentFactory.makeBNPLViewController()
                    vc.viewModel = PaymentFactory.makeBNPLViewModel( bnplProvider: .ValU, selectPaymentVM: safeSelectPaymentVM, isNavController: true, completion: { order, error in
                        self.viewModel.completion(order, error)
                    })
                    
                    if let navController = navigationController {
                        navController.pushViewController(vc, animated: true)
                    } else {
                        present(vc, animated: false)
                    }
                }
            } else {
                errorSnackView.isHidden = false
                let minAmount = String(self.viewModel.config?.valUMinimumAmount ?? 0)
                errorMessageSnackView.text = String(format: "VALUE_INSTALLMENT_AMOUNT".localized, minAmount, self.viewModel.amount.currency)
                errorRefLabel.isHidden = true
                errorCodeSnackView.isHidden = true
            }
        case .ALL:
            break
        case .SHARY:
            if let safeSelectPaymentVM = viewModel.selectPaymentVM {
                let vc = PaymentFactory.makeBNPLViewController()
                vc.viewModel = PaymentFactory.makeBNPLViewModel( bnplProvider: .SHAHRY, selectPaymentVM: safeSelectPaymentVM,  isNavController: true, completion: { order, error in
                    self.viewModel.completion(order, error)
                })
                
                if let navController = navigationController {
                    navController.pushViewController(vc, animated: true)
                } else {
                    present(vc, animated: false)
                }
            }
        case .NONE:
            break
        }
        
    }
    
    
    
    
    func showSnackBar(with error: GDErrorResponse) {
        
        configureAlternativePM()
        
        if error.responseCode != nil || error.detailedResponseCode != nil {
            errorCodeSnackView.isHidden = false
        }
        
        errorCodeSnackView.text = error.detailedResponseCode.isEmpty ? error.responseCode : error.responseCode+"."+error.detailedResponseCode
        errorMessageSnackView.text = error.detailedResponseMessage.isEmpty ? error.responseMessage : error.detailedResponseMessage
        
        viewModel.lastError = error
        if !error.detailedResponseMessage.isEmpty {
            let errors = error.detailedResponseMessage.split(separator: "&")
            if errors.count > 1 {
                errorRefLabel.isHidden = false
                errorRefLabel.text = String(errors.last ?? "")
                errorMessageSnackView.text = String(errors.first ?? "")
            } else {
                if !error.correlationId.isEmpty {
                    errorRefLabel.isHidden = false
                    errorRefLabel.text = "Reference ID \(error.correlationId)"
                } else {
                    errorRefLabel.isHidden = true
                }
                
            }
        }
        
        
        self.scrollView.setContentOffset(.zero, animated: false)
        self.errorSnackView.isHidden = false
        
        self.errorSnackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.errorSnackView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
        clearPaymentForm()
    }
    
    func clearPaymentForm() {
        
        clearCardDetection()
        cardNumberTF.text = ""
        errorCardNumber.isHidden = true
        nameOnCardTF.text = ""
        errorNameOnCard.isHidden = true
        cvvTF.text = ""
        errorCVV.isHidden = true
        expiryDateTF.text = ""
        errorExpiryDate.isHidden = true
        
        emailTF.text = ""
        errorEmail.isHidden = true
        
        let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil) ?? ""
        isPayButtonValid(cardNumber)
        clearFieldCursor()
    }
    
    func clearCardDetection() {
        for element in  self.cardChemeLogos {
            element.withBorder(isVisible: false)
        }
        
    }
    
    func cancelOnTimeout() {
        if let orderId = self.viewModel.orderId, !orderId.isEmpty {
            logEvent("Cancelled By User \(orderId)")
            let cancelParams = CancelParams(orderId: orderId, reason: "TimedOut")
            CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                self.viewModel.orderId = nil
            })
        }
    }
    
    func displayAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: viewModel.okButtonTitle, style: .default, handler: {_ in
            DispatchQueue.main.async { [weak self] in
                if let orderId = self?.viewModel.orderId, !orderId.isEmpty {
                    logEvent("Cancelled By User \(orderId)")
                    let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
                    
                    self?.startLoading()
                    
                    CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                        
                        DispatchQueue.main.async {
                            [weak self] in
                            self?.stopLoading()
                        }
                        if self?.viewModel.showReceipt ?? false  {
                            if let err = self?.viewModel.lastError {
                                self?.showReceipt(order: nil, error: err)
                            } else {
                                self?.showReceipt(order: nil, error: error)
                            }
                            
                        } else {
                            if let err = self?.viewModel.lastError {
                                self?.viewModel.completion(nil, err)
                            } else {
                                self?.viewModel.completion(nil, error)
                            }
                            
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                    })
                } else {
                    
                    if let err = self?.viewModel.lastError {
                        self?.viewModel.completion(nil, err)
                    } else {
                        self?.viewModel.completion(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "Cancelled by user", orderId: ""))
                    }
                    self?.dismiss(animated: true, completion: nil)
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: viewModel.cancelButtonTitle, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func displaySimpleCVVAlert(title: String, message:String) {
        let vc = PaymentFactory.makeCVVAlertViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        vc.config = viewModel.config
        self.present(vc, animated: true)
        
    }
    
    func displaySimpleCanceAlert() {
        let vc = PaymentFactory.makeCancelAlertViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        vc.cancelDelegate = self
        vc.viewModel = viewModel
        vc.config = viewModel.config
        self.present(vc, animated: true)
        
    }
    
    
    private func showCountrySelection(with tag: Int) {
        let vc = PaymentFactory.makeCountrySelectionController(countries: viewModel.config?.countries ?? [], buttontag: tag)
        vc.delegate = self
        
        self.present(vc, animated: true)
    }
    
    private func unfocusFields() {
        
        inputs.forEach {
            $0.endEditing(true)
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        //        if !viewModel.isEmbedded {
        let info = notification.userInfo!
        let rect: CGRect = info[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height+100, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height+20;
        
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
    
    private func detectCardScheme(cardNumber: String) {
        
        guard let  pm = viewModel.paymentMethods == nil ? self.viewModel.config?.paymentMethods : viewModel.paymentMethods else {
            return
        }
        
        for (_, element) in pm.enumerated() {
            if let logoView = self.cardChemeLogos.first(where: {$0.accessibilityIdentifier == element}) {
                
                let validString = viewModel.detetectValidCardSchemeName(cardNumber: cardNumber)
                
                logoView.withBorder(isVisible: element == validString)
                
            } else {
                print("not found1")
            }
            
        }
    }
    
    private func showCardScheme() {
        
        guard let  pm = viewModel.paymentMethods == nil ? self.viewModel.config?.paymentMethods : viewModel.getFilteredPaymentMethods() else {
            return
        }
        
        
        for (index, element) in pm.enumerated() {
            
            
            self.cardChemeLogos[cardChemeLogos.count - (index + 1)].isHidden = false
            self.cardChemeLogos[cardChemeLogos.count - (index + 1)].accessibilityIdentifier = element
            
            let image = self.cardChemeLogos[cardChemeLogos.count - (index + 1)].subviews.filter{$0 is UIImageView }
            if let image =  image.first as? UIImageView {
                image.image =  UIImage(named: element, in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            }
        }
        
    }
    
    func startLoading() {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoading() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: - network calls
    
    func payOrder() {
        guard let cardDetails = viewModel.getCardDetails(cardNumber: cardNumberTF.text ?? "", expiryDate: expiryDateTF.text ?? "", cvv: cvvTF.text ?? "", cardName: nameOnCardTF.text ?? "".trimmingCharacters(in: .whitespaces)) else {
            return
        }
        
        if viewModel.showAddress {
            let billingAddress = viewModel.getAddress(countryCode: countrySelectionBtn.metaDataString, streetNumber: streetTF.text ?? "", city: cityTF.text ?? "", postCode: postCodeTF.text ?? "")
            if viewModel.shouldHideShippingAddress {
                viewModel.customerDetails?.shippingAddress = billingAddress
            } else {
                let shippingAddress = viewModel.getAddress(countryCode: shippingCountrySelectionBtn.metaDataString, streetNumber: shippingStreetTF.text ?? "", city: shippingCityTF.text ?? "", postCode: shippingPostCodeTF.text  ?? "")
                viewModel.customerDetails?.shippingAddress = shippingAddress
            }
            viewModel.customerDetails?.billingAddress = billingAddress
        }
        
        if viewModel.showEmail {
            if let email = emailTF.text, email.isEmpty {
                viewModel.customerDetails?.customerEmail = nil
            } else {
                viewModel.customerDetails?.customerEmail = emailTF.text
            }
        }
        
        if let orderId = self.viewModel.orderId {
            if !(viewModel.config?.useMpgsApiV60 ?? false) && !viewModel.isEmbedded {
                let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
                CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                    logEvent("Cancelled By User \(orderId)")
                })
            }
        }
        
        
        clearFieldCursor()
        
        GeideaPaymentAPI.pay(theAmount: viewModel.amount, withCardDetails: cardDetails, initializeResponse: viewModel.initializeResponse, config: viewModel.config, isHPP: true, showReceipt: false, andTokenizationDetails: viewModel.tokenizationDetails, andPaymentIntentId: viewModel.paymentIntentId, andCustomerDetails: viewModel.customerDetails, orderId: self.viewModel.orderId, paymentMethods: nil, dismissAction: { cancelResponse, error in
            
            self.activityIndicator.stopAnimating()
            if let err = error {
                if !self.viewModel.isEmbedded{
                    self.showSnackBar(with: err)
                } else {
                    self.configureAlternativePM()
                    self.viewModel.completion(nil, err)
                }
                self.viewModel.orderId = error?.orderId
                
            }
        },navController: self, completion:{ response, error in
            self.stopLoading()
            if let err = error { //, !err.responseCode.starts(with: "6") {
                self.startTimer()
                
                if err.isError && !err.errors.isEmpty {
                    if !self.viewModel.isEmbedded {
                        self.showSnackBar(with: GDErrorResponse().withErrorCode(error: "responseMessage: \(err.errors)", code: "\(err.status)"))
                    } else {
                        self.viewModel.completion(response,err)
                    }
                    
                } else {
                    if !self.viewModel.isEmbedded {
                        self.showSnackBar(with: err)
                        
                    } else {
                        self.clearPaymentForm()
                        self.clearFieldCursor()
                        self.configureAlternativePM()
                        self.viewModel.completion(response,err)
                    }
                }
                self.viewModel.orderId = err.orderId
            } else {
                
                guard let orderResponse = response else {
                    return
                }
                
                if let bnplVM = self.bnplVC?.viewModel {
                    switch bnplVM.provider {
                    case.ValU, .Souhoola:
                        self.viewModel.completion(orderResponse, nil)
                        if !self.viewModel.isEmbedded{
                            self.dismiss(animated: true, completion: nil)
                        }
                    case .SHAHRY:
                        self.viewModel.completion(orderResponse, nil)
                        if !self.viewModel.isEmbedded{
                            self.dismiss(animated: true, completion: nil)
                        }
                    case .NONE:
                        if self.viewModel.showReceipt{
                            self.showReceipt(order: orderResponse, error: nil)
                        } else {
                            self.viewModel.completion(orderResponse, nil)
                            if !self.viewModel.isEmbedded{
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    if self.viewModel.showReceipt{
                        self.showReceipt(order: orderResponse, error: nil)
                    } else {
                        self.viewModel.completion(orderResponse, nil)
                        if !self.viewModel.isEmbedded{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        })
    }
    
    func initiateAuth(with cardNumber: String) {
        if viewModel.config?.useMpgsApiV60 ?? false {
            networkGroup.enter()
            
            GeideaPaymentAPI.initiateAuthenticate(theAmount: viewModel.amount, withCardNumber: cardNumber, andTokenizationDetails: viewModel.tokenizationDetails,  andPaymentIntentId: viewModel.paymentIntentId, andCustomerDetails: viewModel.customerDetails, orderId: viewModel.orderId, paymentMethods: viewModel.getFilteredPaymentMethods(), dismissAction: nil, navController: self, completion: { response, error in
                
                self.stopLoading()
                self.networkGroup.leave()
                if let err = error { //, !err.responseCode.starts(with: "6") {
                    self.startTimer()
                    if !err.orderId.isEmpty {
                        self.viewModel.orderId = err.orderId
                    }
                    
                    if err.isError && !err.errors.isEmpty {
                        
                    } else {
                        if !self.viewModel.isEmbedded {
                            self.showSnackBar(with: err)
                            
                        } else {
                            self.viewModel.completion(nil,err)
                        }
                    }
                } else {
                    self.startTimer()
                    self.loadHiddenWebView(with: response?.redirectHtml ?? "")
                    self.viewModel.initializeResponse = response
                    self.viewModel.orderId = response?.orderId
                    self.viewModel.selectPaymentVM?.orderId = self.viewModel.orderId
                    self.errorSnackView.isHidden = true
                    
                    if let currentVC = self.presentedViewController as? CancelAlertViewController {
                        currentVC.viewModel = self.viewModel
                    }
                }
                
            })
        }
        
        networkGroup.notify(queue: .main) {
            if self.payTapped, let orderId = self.viewModel.orderId, !orderId.isEmpty {
                self.payOrder()
            }
        }
    }
    
    func loadHiddenWebView(with redirectHTML: String) {
        let configuration = WKWebViewConfiguration()
        let webV    = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), configuration: configuration)
        webV.loadHTMLString(redirectHTML, baseURL: nil)
        
        view.addSubview(webV)
    }
}

extension CardDetailsFormViewController: UITextFieldDelegate {
    
    fileprivate func isPayButtonValid(_ cardNumber: String) {
        if viewModel.isPayButonValid(cardNumber: cardNumber, expiryDate: expiryDateTF.text ?? "", cvv: cvvTF.text ?? "", cardName: nameOnCardTF.text ?? "") && areFieldsValid() {
            payButton.enabled(isEnabled: true, config: viewModel.config)
        } else {
            payButton.enabled(isEnabled: false, config: viewModel.config)
        }
    }
    
    fileprivate func areFieldsValid() -> Bool {
        if errorEmail.isHidden && errorCity.isHidden && errorStreetTF.isHidden && errorPostCode.isHidden && errorShippingStreet.isHidden && errorShippingCity.isHidden && errorShippingPostCode.isHidden {
            return true
        }
        
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil) ?? ""
        isPayButtonValid(cardNumber)
        
        if textField == cardNumberTF {
            
            detectCardScheme(cardNumber: cardNumber)
            
            guard let validator = viewModel.cardNumberValidator(cardNumber: cardNumber) else {
                errorCardNumber.isHidden = true
                return
            }
            errorCardNumber.text = validator
            errorCardNumber.isHidden = false
        }
        
        
        if textField == expiryDateTF {
            
            guard let validator = viewModel.expiryDateValidator(expiryDate: expiryDateTF.text ?? "") else {
                errorExpiryDate.isHidden = true
                return
            }
            errorExpiryDate.text = validator
            errorExpiryDate.isHidden = false
        }
        
        if textField == cvvTF {
            
            guard let validator = viewModel.cvvValidator(cvv: cvvTF.text ?? "", cardNumber: cardNumber) else {
                errorCVV.isHidden = true
                return
            }
            errorCVV.text = validator
            errorCVV.isHidden = false
            
        }
        
        if textField == nameOnCardTF {
            
            guard let validator = viewModel.cardNameValidator(cardName: nameOnCardTF.text ?? "") else {
                errorNameOnCard.isHidden = true
                return
            }
            errorNameOnCard.text = validator
            errorNameOnCard.isHidden = false
            
        }
        
        if textField == emailTF {
            
            guard let validator = viewModel.emailValidator(email: emailTF.text ?? "") else {
                errorEmail.isHidden = true
                return
            }
            errorEmail.text = validator
            errorEmail.isHidden = false
            
        }
        
        if textField == streetTF {
            
            guard let validator = viewModel.streetValidator(street: streetTF.text ?? "") else {
                errorStreetTF.isHidden = true
                return
            }
            errorStreetTF.text = validator
            errorStreetTF.isHidden = false
            
        }
        
        if textField == cityTF {
            
            guard let validator = viewModel.cityValidator(city: cityTF.text ?? "") else {
                errorCity.isHidden = true
                return
            }
            errorCity.text = validator
            errorCity.isHidden = false
            
        }
        
        if textField == postCodeTF {
            
            guard let validator = viewModel.postCodeValidator(postCode: postCodeTF.text ?? "") else {
                errorPostCode.isHidden = true
                return
            }
            errorPostCode.text = validator
            errorPostCode.isHidden = false
            
        }
        
        if textField == shippingStreetTF {
            
            guard let validator = viewModel.streetValidator(street: shippingStreetTF.text ?? "") else {
                errorShippingStreet.isHidden = true
                return
            }
            errorShippingStreet.text = validator
            errorShippingStreet.isHidden = false
            
        }
        
        if textField == shippingCityTF {
            
            guard let validator = viewModel.cityValidator(city: shippingCityTF.text ?? "") else {
                errorShippingCity.isHidden = true
                return
            }
            errorShippingCity.text = validator
            errorShippingCity.isHidden = false
            
        }
        
        if textField == shippingPostCodeTF {
            
            guard let validator = viewModel.postCodeValidator(postCode: shippingPostCodeTF.text ?? "") else {
                errorShippingPostCode.isHidden = true
                return
            }
            errorShippingPostCode.text = validator
            errorShippingPostCode.isHidden = false
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == cardNumberTF ) {
            let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil) ?? ""
            detectCardScheme(cardNumber: cardNumber)
            return newLength <= 19
        }
        if textField == expiryDateTF {
            guard expiryDateTF.text != nil else {
                return newLength <= 5
            }
            
            return newLength <= 5
        }
        if textField == cvvTF {
            return newLength <= 4
        }
        
        if textField == nameOnCardTF {
            
            return true
        }
        
        
        
        return true
    }
    
    @objc func nameOnCardCheck() {
        
        validateCardName()
        let cardNumber = cardNumberTF.text?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil) ?? ""
        isPayButtonValid(cardNumber)
        
    }
    func validateCardName() {
        
        guard let validator = viewModel.cardNameValidator(cardName: nameOnCardTF.text ?? "") else {
            errorNameOnCard.isHidden = true
            return
        }
        errorNameOnCard.text = validator
        errorNameOnCard.isHidden = false
    }
    
    func validateCardNumber(cardNumber: String) {
        guard let validator = viewModel.cardNumberValidator(cardNumber: cardNumber) else {
            errorCardNumber.isHidden = true
            detectCardScheme(cardNumber: cardNumber)
            initiateAuth(with: cardNumber)
            return
        }
        errorCardNumber.text =  validator
        errorCardNumber.isHidden = false
        detectCardScheme(cardNumber: cardNumber)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unfocusFields()
        return true
    }
}

typealias CountrySelectiondDelegate = CardDetailsFormViewController
extension CountrySelectiondDelegate:  SelectionViewControllerDelegate {
    func didSelectCountryItem(item: Any, buttonTag: Int) {
        let country = item as! ConfigCountriesResponse
        if countrySelectionBtn.tag == buttonTag {
            
            switch GlobalConfig.shared.language {
            case .arabic:
                countrySelectionBtn.setTitle(country.nameAr, for: .normal)
            default:
                countrySelectionBtn.setTitle(country.nameEn, for: .normal)
            }
            
            countrySelectionBtn.metaDataString = country.key3 ?? ""
        } else {
            switch GlobalConfig.shared.language {
            case .arabic:
                shippingCountrySelectionBtn.setTitle(country.nameAr, for: .normal)
            default:
                shippingCountrySelectionBtn.setTitle(country.nameEn, for: .normal)
            }
            shippingCountrySelectionBtn.metaDataString = country.key3 ?? ""
        }
    }
    
}

typealias CancelTappedDelegate = CardDetailsFormViewController
extension CancelTappedDelegate:  CancelTapDelegate {
    
    func didOkBtnTapped(error: GDErrorResponse?) {
        
        DispatchQueue.main.async { [weak self] in
            if let orderId = self?.viewModel.orderId, !orderId.isEmpty {
                logEvent("Cancelled By User \(orderId)")
                
                if self?.viewModel.showReceipt ?? false  {
                    if let err = self?.viewModel.lastError {
                        self?.showReceipt(order: nil, error: err)
                    } else {
                        self?.showReceipt(order: nil, error: error)
                    }
                    
                } else {
                    if let err = self?.viewModel.lastError {
                        self?.viewModel.completion(nil, err)
                    } else {
                        self?.viewModel.completion(nil, error)
                    }
                    
                    self?.dismiss(animated: false, completion: {})
                }
            } else {
                
                if let err = self?.viewModel.lastError {
                    self?.viewModel.completion(nil, err)
                } else {
                    self?.viewModel.completion(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "Cancelled by user", orderId: ""))
                }
                self?.dismiss(animated: false, completion: nil)
            }
            
        }
    }
}

