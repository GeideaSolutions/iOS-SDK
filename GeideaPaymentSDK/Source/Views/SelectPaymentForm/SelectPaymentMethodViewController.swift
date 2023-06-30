//
//  SelectPaymentMethodViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 09.08.2021.
//

import UIKit

class SelectPaymentMethodViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var selectPaymentStackView: UIStackView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var headerImageView: UIView!
    @IBOutlet weak var errorSnackMessage: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var applePayView: UIView!
    
    @IBOutlet weak var errorSnackCode: UILabel!
    @IBOutlet weak var selectPaymentMethodTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orSelecttitle: UILabel!
    
    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var nextBtn: RoundedButton!
    
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    var bnplVC: BNPLViewController?
    var viewModel: SelectPaymentMethodViewModel!
    
    var selectedPM: PaymentTypeStatus? = nil {
        didSet {
            if selectedPM == nil {
                for pmView in self.paymentMethodsViews {
                    
                    pmView.selected = false
                }
            } else {
                self.errorView.isHidden = true
                checkNextBtn()
            }
        }
    }
    
    var paymentMethodsViews: [PaymentMethodsView] = []
    var providers = [PaymentTypeStatus]()
    var paymentMethodMap: [PaymentMethodsMap] = []
    
    init() {
        super.init(nibName: "SelectPaymentMethodViewController", bundle: Bundle(for: SelectPaymentMethodViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let  paymentMethodsObject = viewModel.paymentSelectionMethods {
            var pmProviders: [String] = []
            for pmsMethod  in paymentMethodsObject {
                
                var pmMap = PaymentMethodsMap()
                pmMap.pm = pmsMethod.paymentMethods
                let pmSet = Set(pmsMethod.paymentMethods)
                
                if  pmSet.isSubset(of: viewModel.getAvailableCardPaymentMethods()) {
                    if pmSet.count == 1 {
                        pmMap.cardSchemes?.append(pmSet.first ?? "")
                        pmMap.paymentItem = PaymentItem(paymentType: .Card, label: pmsMethod.label)
                    } else {
                        pmMap.cardSchemes?.append(contentsOf: Array(pmSet))
                        pmMap.paymentItem = PaymentItem(paymentType: .Card, label: pmsMethod.label)
                    }
                } else if pmsMethod.paymentMethods.first?.lowercased() == "meezaDigital".lowercased() {
                    pmMap.paymentItem = PaymentItem(paymentType: .QR, label: pmsMethod.label)
                } else if viewModel.getAvailableBNPLPaymentMethods().contains(pmsMethod.paymentMethods.first?.lowercased() ?? "") {
                    let pm = pmsMethod.paymentMethods.first?.lowercased() ?? ""
                    if !pmProviders.contains(pm) {
                        switch pm {
                        case "valu":
                            if  viewModel.showValu {
                                pmProviders.append(pm)
                                pmMap.paymentItem = PaymentItem(paymentType: .ValU, label: pmsMethod.label)
                            }
                           
                        case "souhoola":
                            if  viewModel.showSouhoola {
                                pmProviders.append(pm)
                                pmMap.paymentItem = PaymentItem(paymentType: .Souhoola, label: pmsMethod.label)
                            }
                           
                        case "shahry":
                            if  viewModel.showShahry {
                                pmProviders.append(pm)
                                pmMap.paymentItem = PaymentItem(paymentType: .Shahry, label: pmsMethod.label)
                            }
                           
                            
                        default:
                            return
                        }
                    }
                }
                
                paymentMethodMap.append(pmMap)
            }
            
            for map in paymentMethodMap {
                if let safePi = map.paymentItem {
                    
                    
                    if safePi.paymentType == .ValU || safePi.paymentType == .Souhoola ||   safePi.paymentType == .Shahry {
                        addPaymentMethod(type: safePi, cardSchemes: map.cardSchemes, pm: map.pm)
                    }
                    
                }
            }
            
            var bnplCreated = false
            for map in paymentMethodMap {
                if let safePi = map.paymentItem {
                    
                    if viewModel.isPaymentItemBNPL(item: safePi)  && !bnplCreated{
                        addPaymentMethod(type: PaymentItem(paymentType: .BNPLGroup, label: nil), cardSchemes: map.cardSchemes, pm: nil)
                        bnplCreated = true
                    } else if !viewModel.isPaymentItemBNPL(item: safePi) {
                        addPaymentMethod(type: safePi, cardSchemes: map.cardSchemes, pm:map.pm)
                    }
                    
                }
            }
            
        } else {
            
            if  viewModel.shouldShowPayCard {
                addPaymentMethod(type: PaymentItem(paymentType: .Card, label: nil))
            }
            
            if  viewModel.shouldShowPayQR  {// viewModel.qrCustomerDetails != nil && viewModel.shouldShowPayQR {
                addPaymentMethod(type: PaymentItem(paymentType: .QR, label: nil))
            }
            
            if  viewModel.shouldShowBNPLValu && viewModel.showValu {
                addPaymentMethod(type: PaymentItem(paymentType: .ValU, label: nil))
            }
            
            if  viewModel.shouldShowBNPLShahry && viewModel.showShahry {
                
                addPaymentMethod(type: PaymentItem(paymentType: .Shahry, label: nil))
            }
            
            if  viewModel.shouldShowBNPLSouhoola && viewModel.showSouhoola {
                addPaymentMethod(type: PaymentItem(paymentType: .Souhoola, label: nil))
            }
            
            if  (viewModel.shouldShowBNPLValu && viewModel.showValu) || (viewModel.shouldShowBNPLShahry && viewModel.showShahry) || (viewModel.shouldShowBNPLSouhoola && viewModel.showSouhoola) {
                
                addPaymentMethod(type: PaymentItem(paymentType: .BNPLGroup, label: nil) )
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.applePayAction = applePayAction
        
        setupViews()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViews() {
        
        selectedPM = nil
        
        showApplePay(isHidden: !viewModel.shouldShowApplePay)
        viewModel.setupUIWithConfig(buttonView: applePayView, vc: self)
        
        localizeStrings()
        
        setBranding()
        showEmbedded()
        
    }
    
    func checkNextBtn() {
        nextBtn.enabled(isEnabled: viewModel.nextBtnEnabled(selectedPM: selectedPM), config: viewModel.config)
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: viewModel.config)
        
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerImageView.addBottomRoundedEdge(desiredCurve: 1.5)
        }
        
        if let headerColor = viewModel.config?.branding?.headerColor {
            headerImageView.backgroundColor = UIColor(hex: headerColor )
        }
        
        if let logo = viewModel.config?.branding?.logoPublicUrl {
            logoIV.loadFrom(URLAddress: logo)
        }
        
        checkNextBtn()
        
        
    }
    
    
    func addPaymentMethod(type: PaymentItem, cardSchemes: [String]? = nil, pm: [String]? = nil) {
        var paymentTypeview = PaymentMethodsView()
        var images: [UIImage] = []
        var isProvider = false
        switch type.paymentType {
        case .Card:
            
            var schemes = viewModel.config?.paymentMethods
            if  let pmSchemes = cardSchemes, !pmSchemes.isEmpty {
                schemes = pmSchemes
            }
            
            if let safeScheme = schemes {
                for scheme in safeScheme {
                    if let image =  UIImage(named: scheme, in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
                        images.append(image)
                    }
                }
            }
            paymentTypeview = SelectPaymentMethodView()
        case .QR:
            if let image =  UIImage(named: "meeza_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
                images.append(image)
            }
            paymentTypeview = SelectMeezaDigitalView()
            if  let meezaView =  paymentTypeview as? SelectMeezaDigitalView {
                meezaView.onPhoneNumberEntered = { [self] phoneNumber in
                    if !phoneNumber.isEmpty {
                        self.viewModel.qrCustomerDetails?.phoneNumber = phoneNumber
                        self.viewModel.qrCustomerDetails?.phoneCountryCode = "+20"
                    }
                    self.viewModel.meeezaPhoneNumber = phoneNumber
                    
                    checkNextBtn()
                }
            }
            
        case .BNPLGroup:
            for provider in self.providers {
                if let providerLogo = provider.logos?.first {
                    images.append(providerLogo)
                }
            }
            paymentTypeview = SelectGroupedView()
        case .Souhoola:
            isProvider = true
            switch GlobalConfig.shared.language {
            case .arabic:
                if let image =  UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
                    images.append(image)
                }
                
            case .english:
                if let image =  UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
                    images.append(image)
                }
            }
        case .Shahry:
            isProvider = true
            if let image =  UIImage(named: "shahry_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
                images.append(image)
            }
        case .ValU:
            if let image =  UIImage(named: "valU_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil){
                images.append(image)
            }
            isProvider = true
        }
        
        let paymentStatus = PaymentTypeStatus(type, config: viewModel.config, logos: images, pm: pm, groupedItems: providers, onSelected: { paymentType in
            
            if paymentType?.item.paymentType == .ValU ||  paymentType?.item.paymentType == .Shahry || paymentType?.item.paymentType == .Souhoola{
                let error = self.viewModel.isBNPLValid(type: paymentType?.item.paymentType)
                
                if let err = error {
                    
                    if !self.viewModel.embedded {
                        self.showSnackBar(with: err)
                    } else {
                        if !err.responseDescription.isEmpty {
                            err.responseMessage = err.responseDescription
                            err.detailedResponseMessage = err.responseDescription
                        }
                        self.viewModel.completion(nil, err)
                    }

                    
                } else {
                    self.selectedPM = paymentType
                    for pmView in self.paymentMethodsViews {
                        if (pmView.paymentMethod != paymentType) && pmView.paymentMethod?.item.paymentType != .BNPLGroup {
                            pmView.selected = false
                            self.viewModel.meeezaPhoneNumber = ""
                        }
                        
                    }
                }
            } else {
                self.selectedPM = paymentType
                
                for pmView in self.paymentMethodsViews {
                    
                    if pmView.paymentMethod != paymentType  {
                        pmView.selected = false
                        self.viewModel.meeezaPhoneNumber = ""
                    }
                }
            }
            
        })
        
        if isProvider {
            providers.append(paymentStatus)
        } else  {
            paymentTypeview.paymentMethod = paymentStatus
            paymentMethodsViews.append(paymentTypeview)
            selectPaymentStackView.addArrangedSubview(paymentTypeview)
        }
        
        
    }
    
    func showEmbedded() {
        if let bnpl = self.parent as? BNPLViewController {
            bnplVC = bnpl
        }
        if viewModel.embedded {
            headerView.isHidden = viewModel.embedded
            errorView.isHidden = viewModel.embedded
            headerViewHeight.constant = 0
        } else {
            headerViewHeight.constant = 150
        }
        
    }
    
    func applePayAction(response: GDOrderResponse?, error: GDErrorResponse?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.viewModel.showReceipt {
                self.showReceipt(order: response, error: nil)
            } else {
                self.viewModel.completion(response, nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func showReceipt(order: GDOrderResponse?, error: GDErrorResponse?) {
        let vc = PaymentFactory.makeReceiptViewController()
        
        vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse:
                                                            order, withError: error, receiptFlow: .CARD, config: viewModel.config, completion: { response, error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  [weak self] in
                self?.viewModel.completion(order, error)
                self?.dismiss(animated: true, completion: nil)
            }
            
        })
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func localizeStrings() {
        selectPaymentMethodTitle.text = viewModel.selectTitle
        orSelecttitle.text = viewModel.orTitle
        
        nextBtn.setTitle(viewModel.nextButton, for: .normal)
        cancelBtn.setTitle(viewModel.cancelButton, for: .normal)
    }
    
    func showApplePay(isHidden: Bool) {
        applePayView.isHidden = isHidden
        orSelecttitle.isHidden = isHidden  || (paymentMethodsViews.isEmpty && !viewModel.shouldShowPayQR)
        nextBtn.isHidden = paymentMethodsViews.isEmpty && !viewModel.shouldShowPayQR
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        guard let pm = selectedPM?.item else {
            return
        }
        if pm.paymentType == .QR {
            nextBtn.showLoading()
            getQRImage()
        } else {
            viewModel.nextAction(pm.paymentType, self.navigationController ?? self)
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        displaySimpleCancelAlert()
        
    }
    
    func displaySimpleCancelAlert() {
        let vc = PaymentFactory.makeCancelAlertViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        vc.cancelDelegate = self
        vc.viewModel = viewModel
        vc.config = viewModel.config
        self.present(vc, animated: true)
        
    }
    
    func requestToPay(with message: String) {
        
        
        if !viewModel.meeezaPhoneNumber.isEmpty {
            if !viewModel.meeezaPhoneNumber.starts(with: "0") {
                viewModel.meeezaPhoneNumber = "0\(viewModel.meeezaPhoneNumber)"
            }
            GeideaPaymentAPI.requestToPay(withQRCodeMessage: message, phoneNumber: viewModel.meeezaPhoneNumber, completion: { response, error  in
                
                if let err = error {
                    
                    if !self.viewModel.embedded {
                        self.showSnackBar(with: err)
                    } else {
                        self.nextBtn.hideLoading()
                        self.selectedPM = nil
                        self.viewModel.meeezaPhoneNumber = ""
                        self.checkNextBtn()
                        self.bnplVC?.showSnackBar(with: err)
                    }
                    return
                } else {
                    guard let pm = self.selectedPM?.item else {
                        self.nextBtn.hideLoading()
                        return
                    }
                    self.nextBtn.hideLoading()
                    self.viewModel.nextAction(pm.paymentType, self.navigationController ?? self)
                }
            })
        }
        
    }
    
    func getQRImage() {
        
        let qrDetails = GDQRDetails(phoneNumber: viewModel.qrCustomerDetails?.phoneNumber, email: viewModel.qrCustomerDetails?.email, name: viewModel.qrCustomerDetails?.name, expiryDate: viewModel.qrExpiryDate)
        GeideaPaymentAPI.getQRImage(with: viewModel.amount,qrDetails: qrDetails, merchantName: viewModel.config?.merchantName ?? "", orderId: viewModel.orderId, callbackUrl: viewModel.customerDetails?.callbackUrl, completion:  { response, error  in
            if let err =  error {
                if !self.viewModel.embedded {
                    self.showSnackBar(with: err)
                } else {
                    self.nextBtn.hideLoading()
                    self.selectedPM = nil
                    self.viewModel.meeezaPhoneNumber = ""
                    self.checkNextBtn()
                    self.bnplVC?.showSnackBar(with: err)
                }
                
            } else {
                self.viewModel.qrCustomerDetails?.qrCode = response?.image
                self.viewModel.qrCustomerDetails?.paymentIntentId = response?.paymentIntentId
                self.requestToPay(  with: response?.message ?? "")
            }
        })
    }
    
    func showSnackBar(with error: GDErrorResponse) {
        nextBtn.hideLoading()
        self.selectedPM = nil
        self.viewModel.meeezaPhoneNumber = ""
        checkNextBtn()
        
        if error.isError && !error.errors.isEmpty {
            let filterErrors = error.errors.flatMap { $0.value }
            var displayError = ""
            for oneError in filterErrors {
                displayError +=  oneError + "\n"
            }
            errorSnackMessage.text = displayError
            errorSnackCode.isHidden = true
        } else {
            if !error.responseCode.isEmpty || error.detailedResponseCode != nil {
                errorSnackCode.isHidden = false
            } else {
                errorSnackCode.isHidden = true
            }
            
            errorSnackCode.text = error.detailedResponseCode.isEmpty ? error.responseCode : error.responseCode+"."+error.detailedResponseCode
            errorSnackMessage.text = error.detailedResponseMessage.isEmpty ? error.responseMessage : error.detailedResponseMessage
            
            if !error.detailedResponseMessage.isEmpty {
                let errors = error.detailedResponseMessage.split(separator: "&")
                if errors.count > 1 {
                    refLabel.isHidden = false
                    refLabel.text = String(errors.last ?? "")
                    errorSnackMessage.text = String(errors.first ?? "")
                } else {
                    if !error.correlationId.isEmpty {
                        refLabel.isHidden = false
                        refLabel.text = "Reference ID \(error.correlationId)"
                    } else {
                        refLabel.isHidden = true
                    }
                    
                }
            }
        }
        
        self.errorView.isHidden = false
        
        self.errorView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.errorView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
    }
    
}




typealias SelectCancelTappedDelegate = SelectPaymentMethodViewController
extension SelectCancelTappedDelegate:  CancelTapDelegate {
    
    func didOkBtnTapped(error: GDErrorResponse?) {
        
        DispatchQueue.main.async { [weak self] in
            if let orderId = self?.viewModel.orderId, !orderId.isEmpty {
                logEvent("Cancelled By User \(orderId)")
                
                if self?.viewModel.showReceipt ?? false  {
                    self?.showReceipt(order: nil, error: error)
                    
                } else {
                    self?.viewModel.completion(nil, error)
                    
                    if let navController = self?.navigationController {
                        
                        navController.popViewController(animated: true)
                        self?.dismiss(animated: true, completion: nil)
                    } else{
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                self?.viewModel.completion(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "Cancelled by user", orderId: ""))
                self?.dismiss(animated: false, completion: nil)
            }
            
        }
    }
    
    
}
