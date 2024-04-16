//
//  ConfirmPhoneViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 02.02.2022.
//

import UIKit
import Contacts

class BNPLViewController: BaseViewController, BackBtnTapDelegate {
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var errorSnackView: UIView!
    @IBOutlet weak var errorSnackCode: UILabel!
    @IBOutlet weak var errorSnackMessage: UILabel!
    @IBOutlet weak var failureIcon: UIImageView!
    @IBOutlet weak var errorRefLabel: UILabel!
    
    @IBOutlet weak var xBtn: UIButton!
    @IBOutlet weak var stepView: StepView!
    @IBOutlet weak var containerView: UIView!
    
//    var isEmbeddedBack = false
    
    private lazy var phoneNumberVC: PhoneNumberViewController = {
        
        let vc = PhoneNumberViewController()
        vc.viewModel = PaymentFactory.makePhoneNumberViewModel()
        return vc
    }()
    
    private lazy var installmentVC: InstallmentViewController = {
        
        let vc = InstallmentViewController()
        vc.viewModel = InstallmentViewModel(custumerIdentifer: viewModel.customerId, amount: viewModel.selectPaymentVM.amount)
        return vc
    }()
    
    private lazy var cardDetailsVC: CardDetailsFormViewController = {
        
        let vc = CardDetailsFormViewController()
        return vc
    }()
    
    private lazy var qrPaymentVC: QRPaymentFormViewController = {
        
        let vc = QRPaymentFormViewController()
        return vc
    }()
    
    private lazy var confirmShahryVC: ShahryConfirmViewController = {
        
        let vc = ShahryConfirmViewController()
        vc.viewModel = ShahryConfirmViewModel(screenTitle: "", isNavController: false)
        return vc
    }()
    
    private lazy var purchaseShahryVC: ShahryPurchaseViewController = {
        
        let vc = ShahryPurchaseViewController()
        vc.viewModel = ShahryPurchaseViewModel(screenTitle: "", isNavController: false)
        return vc
    }()
    
    private lazy var paymentVC: SelectPaymentMethodViewController = {
        
        let vc = PaymentFactory.makePaymentSelectionFormViewController()
        var pm = viewModel.selectPaymentVM.paymentMethods
        
        vc.viewModel = PaymentFactory.makePaymentSelectionFormViewModel(amount: viewModel.selectPaymentVM.amount, showAdress: viewModel.selectPaymentVM.showAddress, showEmail: viewModel.selectPaymentVM.showEmail, showReceipt: viewModel.selectPaymentVM.showReceipt, tokenizationDetails: viewModel.selectPaymentVM.tokenizationDetails, customerDetails:  viewModel.selectPaymentVM.customerDetails, applePay:  viewModel.selectPaymentVM.applePay, config: viewModel.selectPaymentVM.config, paymentIntentId: viewModel.selectPaymentVM.paymentIntentId, qrCustomerDetails: viewModel.selectPaymentVM.qrCustomerDetails,qrExpiryDate: viewModel.selectPaymentVM.qrExpiryDate, shahryItems: viewModel.selectPaymentVM.bnplItems, paymentMethods: pm, paymentSelectionMethods: viewModel.selectPaymentVM.paymentSelectionMethods, isNavController: false, embedded: true, showValu: false, completion: viewModel.selectPaymentVM.completion, nextAction: { [self] action, navController  in
            
            self.errorSnackView.isHidden = true
            self.stepView.isHidden = false
            switch action {
            case .Card:
                self.payWithGeideaForm()
            case .QR:
                self.payQRWithGeideaForm()
            case .ValU:
                self.payWithBNPL(provider: .ValU)
            case .Shahry:
                if let bnplItemsValid = viewModel.areBNPLItemsValid(authenticateParams: viewModel.selectPaymentVM.amount, bnplItems: viewModel.selectPaymentVM.bnplItems) {
                    self.viewModel.selectPaymentVM.completion(nil, bnplItemsValid)
                    vc.dismiss(animated: false, completion: nil)
                } else {
                    payWithShahry()
                }
                
            case .Souhoola:
                if let bnplItemsValid = viewModel.areBNPLItemsValid(authenticateParams:  viewModel.selectPaymentVM.amount, bnplItems: viewModel.selectPaymentVM.bnplItems) {
                    
                    self.viewModel.selectPaymentVM.completion(nil, bnplItemsValid)
                    vc.dismiss(animated: false, completion: nil)
                    return
                }
                if  viewModel.selectPaymentVM.amount.amount >= Double(viewModel.selectPaymentVM.config?.souhoolaMinimumAmount ?? 0) {
                    vc.dismiss(animated: false, completion: nil)
                    self.payWithBNPL(provider: .Souhoola)
                } else {
                    stepView.isHidden = true
                    errorSnackView.isHidden = false
                    let minAmount = String(viewModel.selectPaymentVM.config?.souhoolaMinimumAmount ?? 0)
                    errorSnackMessage.text = String(format: "SOUHOOLA_INSTALLMENT_AMOUNT".localized, minAmount, viewModel.selectPaymentVM.amount.currency)
                    
                }
            case .BNPLGroup:
                break
            case .none:
                break
            }
            
            
        })
        
        return vc
    }()
    
    private lazy var oTPVC: OTPViewController = {
        
        let vc = OTPViewController()
        vc.viewModel = OTPViewModel(screenTitle: "", isNavController: false)
        return vc
    }()
    
    private lazy var reviewTransactionVC: ReviewTransactionViewController = {
        
        let vc = ReviewTransactionViewController()
        return vc
    }()
    
    var viewModel: BNPLViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        containerViewHeight.constant = container.preferredContentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBranding()
    }
    
    override func localizeStrings() {
        switch viewModel.currentFlow {
        case .BNPL_CONFIRM_PHONE:
            if viewModel.provider == .Souhoola {
                stepView.titleLabel.text = viewModel.confirmPinTitle
            } else {
                stepView.titleLabel.text = viewModel.phoneTitle
            }
        case .INSTALLMENT:
            stepView.titleLabel.text = viewModel.installmentTitle
        case .PAYMENT:
            stepView.titleLabel.text = viewModel.paymentTitle
        case .OTP:
            stepView.titleLabel.text = viewModel.otpTitle
        case .CARD_DETAILS:
            stepView.titleLabel.text = viewModel.paymentTitle
        case .QR:
            stepView.titleLabel.text = viewModel.paymentTitle
        case .SHAHRY_CONFIRM:
            stepView.titleLabel.text = viewModel.confirmTitle
        case .PURCHASE_SHAHRY:
            stepView.titleLabel.text = viewModel.purchaseTitle
        case .REVIEW_TRANSACTION:
            stepView.titleLabel.text = viewModel.reviewTitle
        }
    }
    
    func checkBackBtn(isVisible: Bool) {
        stepView.backBtn.isHidden = !isVisible
        stepView.backBtnGestureRecognizer.isEnabled = isVisible
    }
    
    
    func setupViews() {
        switch viewModel.currentFlow {
        case .BNPL_CONFIRM_PHONE:
            self.phoneNumberVC = PhoneNumberViewController()
            self.phoneNumberVC.viewModel = PaymentFactory.makePhoneNumberViewModel()
            activeViewController = phoneNumberVC
            self.stepView.setupStepView(currentStep: 1, total: 2)
            if viewModel.provider == .Souhoola {
                self.stepView.setupStepView(currentStep: 1, total:4)
            }
        case .SHAHRY_CONFIRM:
            activeViewController = confirmShahryVC
            self.stepView.setupStepView(currentStep: 1, total: 2)
        default:
            break
        }
        
        errorSnackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        stepView.delegate = self
        localizeStrings()
    }
    
    func setBranding() {
    
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerImageView.addBottomRoundedEdgeIV(desiredCurve: 1.5)
        }
       
        if let headerColor = viewModel.selectPaymentVM.config?.branding?.headerColor {
            headerImageView.backgroundColor = UIColor(hex: headerColor)
        }
        
        if let logo = viewModel.selectPaymentVM.config?.branding?.logoPublicUrl {
            
            
            logoIV.loadFrom(URLAddress: logo)
        }
        
        if let accentColor = viewModel.selectPaymentVM.config?.branding?.accentColor {
            stepView.stepView.trackColor = UIColor(hex: accentColor) ?? UIColor.buttonBlue
            stepView.stepView.refresh()
        }
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
    
    func showSnackBar(with error: GDErrorResponse) {
        
        if !error.detailedResponseCode.isEmpty || !error.responseCode.isEmpty {
            errorSnackCode.isHidden = false
        }
        
        errorSnackCode.text = error.detailedResponseCode.isEmpty ? error.responseCode : error.responseCode+"."+error.detailedResponseCode
        errorSnackMessage.text = error.detailedResponseMessage.isEmpty ? error.responseMessage : error.detailedResponseMessage
        
        if !error.detailedResponseMessage.isEmpty {
            let errors = error.detailedResponseMessage.split(separator: "&")
            if errors.count > 1 {
                errorRefLabel.isHidden = false
                errorRefLabel.text = String(errors.last ?? "")
                errorSnackMessage.text = String(errors.first ?? "")
            } else {
                if !error.correlationId.isEmpty {
                    errorRefLabel.isHidden = false
                    errorRefLabel.text = "Reference ID \(error.correlationId)"
                } else {
                    errorRefLabel.isHidden = true
                }
            }
        }
        self.errorSnackView.isHidden = false
        
        self.errorSnackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.errorSnackView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
    }
    
    func phoneNumberNextTapped(with customerIdentifier: String, pin: String?) {
        
        
        var customerId = customerIdentifier
        if !customerId.starts(with: "0"){
            customerId = "0"+customerIdentifier
        }
        self.phoneNumberVC.pinError.isHidden = true
        self.viewModel.customerId = customerId
        self.viewModel.pin = pin
        
        if viewModel.provider == .Souhoola {
            viewModel.souhoolaVerifyCustomer(with: self.viewModel.customerId ?? "", pin: self.viewModel.pin ?? "", completion: { response, error in
                self.phoneNumberVC.nextBtn.hideLoading()
                if let err = error {
                    
                    if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015") {
                        self.phoneNumberVC.pinError.isHidden = false
                        self.phoneNumberVC.pinError.text = err.detailedResponseMessage
                    } else {
                        self.showReceipt(receipt: nil, error: error, receiptFlow: .SOUHOOLA)
                    }
                    
                    
                } else {
                    
                    if response?.availableLimit ?? 0 > Double(self.viewModel.selectPaymentVM.config?.souhoolaMinimumAmount ?? 0) {
                        self.viewModel.getSouhoolaInstallmentPlans( completion: { [self] response, error in
                            if let err = error {
                                self.showSnackBar(with: err)
                            } else {
                                self.viewModel.goToNextScren()
                                if let plans = response?.installmentPlans {
                                    var installmentPlans = [InstallmantPlanCellViewModel]()
                                    for plan in plans {
                                        installmentPlans.append(InstallmantPlanCellViewModel(plan))
                                    }
                                    self.installmentVC.viewModel.installmentSelected = nil
                                    self.installmentVC.viewModel.installmentPlans = installmentPlans
                                    self.activeViewController = self.installmentVC
                                    self.stepView.setupStepView(currentStep: 2, total: 4)
                                    self.viewModel.currentFlow = .INSTALLMENT
                                    self.viewModel.provider = .Souhoola
                                    localizeStrings()
                                    
                                }
                            }
                        })
                    } else {
                        self.phoneNumberVC.pinError.isHidden = false
                        self.phoneNumberVC.pinError.text = self.phoneNumberVC.viewModel.souhoolaAvailableLimitError
                    }
                    
                }
                
            })
        } else {
            viewModel.verifyPhoneNumber(with: self.viewModel.customerId ?? "", completion: { response, error in
                self.phoneNumberVC.nextBtn.hideLoading()
                if let err = error {
                    self.phoneNumberVC.phoneNumberErrorLabel.isHidden = false
                    self.phoneNumberVC.phoneNumberErrorLabel.text = err.detailedResponseMessage
                } else {
                    
                    self.viewModel.getInstallmentPlans(with: self.viewModel.customerId ?? "", completion: { [self] response, error in
                        if let err = error {
                            self.showSnackBar(with: err)
                        } else {
                            self.viewModel.goToNextScren()
                            if let plans = response?.installmentPlans {
                                var installmentPlans = [InstallmantPlanCellViewModel]()
                                for plan in plans {
                                    installmentPlans.append(InstallmantPlanCellViewModel(plan))
                                }
                                self.installmentVC.viewModel.installmentSelected = nil
                                self.installmentVC.viewModel.installmentPlans = installmentPlans
                                
                            }
                            self.viewModel.bnplOrderID = response?.bnplOrderId
                            self.activeViewController = self.installmentVC
                            self.stepView.setupStepView(currentStep: 2, total: 3)
                            self.viewModel.currentFlow = .INSTALLMENT
                            self.viewModel.provider = .ValU
                            localizeStrings()
                            
                        }
                    })
                }
            })
        }
        
    }
    
    func installmentNextTapped() {
        
        checkBackBtn(isVisible: false)
//        isEmbeddedBack = false
        
        var paymentMethods = viewModel.selectPaymentVM.paymentMethods?.filter { $0 != "valu".lowercased()  }
        paymentMethods = paymentMethods?.filter { $0 != "shahry".lowercased()  }
        paymentMethods = paymentMethods?.filter { $0 != "souhoola".lowercased()  }
        
        let restrictPaymentMethods = paymentMethods != nil
        installmentVC.nextBtn.showLoading()
        viewModel.tenure = installmentVC.viewModel.installmentSelected?.tenorMonth ?? 0
        
        
        if viewModel.provider == .Souhoola {
            let details = GDSouhoolaReviewTransaction(customerIdentifier: viewModel.customerId ?? "", customerPin: viewModel.pin ?? "", totalAmount: viewModel.selectPaymentVM.amount.amount , currency: viewModel.selectPaymentVM.amount.currency , tenure: viewModel.tenure , downPayment: viewModel.downPayment?.amount ?? 0, minimumDownPaymentTenure: installmentVC.viewModel.installmentSelected?.minDownPayment ?? 0, promoCode: installmentVC.viewModel.installmentSelected?.promoCode ?? "", approvedLimit: viewModel.souhoolaVerifyResponse?.approvedLimit ?? 0, outstanding: viewModel.souhoolaVerifyResponse?.outstanding ?? 0, availableLimit: viewModel.souhoolaVerifyResponse?.availableLimit ?? 0, minLoanAmount: viewModel.souhoolaVerifyResponse?.minLoanAmount ?? 0, items: viewModel.selectPaymentVM.bnplItems)
            checkBackBtn(isVisible: true)
            viewModel.souhoolaReviewTransaction(with:  details, completion: { [self] response, error in
                self.installmentVC.nextBtn.hideLoading()
                if let err = error {
                    if err.isError && !err.errors.isEmpty {
                        let filterErrors = err.errors.flatMap { $0.value }
                        var displayError = ""
                        for oneError in filterErrors {
                            displayError +=  oneError + "\n"
                        }
                        self.installmentVC.downPaymentErrorLabel.text  = displayError
                    } else {
                        if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015") {
                            self.installmentVC.downPaymentSV.isHidden = true
                            self.installmentVC.errorLabel.isHidden = false
                            self.installmentVC.errorLabel.text = err.detailedResponseMessage
                        } else {
                            self.showReceipt(receipt: nil, error: error, receiptFlow: .SOUHOOLA)
                        }
                    }
                } else {
                    if let res = response {
                        self.viewModel.currentFlow = .REVIEW_TRANSACTION
                        self.stepView.setupStepView(currentStep: 3, total: 4)
                        let vc = reviewTransactionVC
                        if vc.viewModel != nil {
                            vc.viewModel.reviewDetails = res
                            vc.viewModel.installmentPlan = installmentVC.viewModel.installmentSelected
                        } else {
                            vc.viewModel = ReviewTransactionViewModel(reviewDetails: res, installmentPlan: installmentVC.viewModel.installmentSelected, currency: viewModel.selectPaymentVM.amount.currency)
                        }
                        
                        self.activeViewController = vc
                        localizeStrings()
                    }
                }
            })
        } else {
            checkBackBtn(isVisible: false)
            let details = GDVALUInstallmentPlanSelectedDetails(customerIdentifier: viewModel.customerId, totalAmount: installmentVC.viewModel.amount?.amount ?? 0.00, currency: installmentVC.viewModel.amount?.currency, adminFees: viewModel.adminFees, downPayment: viewModel.downPayment?.amount ?? 0.00, giftCardAmount: viewModel.toUAmount?.amount ?? 0.00, campaignAmount: viewModel.cashBackAmount?.amount ?? 0.00, tenure: viewModel.tenure, merchantReferenceId: viewModel.selectPaymentVM.customerDetails?.merchantReferenceId, callbackUrl: viewModel.selectPaymentVM.customerDetails?.callbackUrl, billingAddress: viewModel.selectPaymentVM.customerDetails?.billingAddress, shippingAddress: viewModel.selectPaymentVM.customerDetails?.shippingAddress, customerEmail: viewModel.selectPaymentVM.customerDetails?.customerEmail, orderId: viewModel.orderId, bnplOrderId: viewModel.bnplOrderID, cashOnDelivery: installmentVC.selectedPayment == .CASH, restrictPaymentMethods: restrictPaymentMethods, paymentMethods: paymentMethods)
            viewModel.installmentPlanSelected(with:  details, completion: { [self] response, error in
                self.installmentVC.nextBtn.hideLoading()
                if let err = error {
                    if err.isError && !err.errors.isEmpty {
                        let filterErrors = err.errors.flatMap { $0.value }
                        var displayError = ""
                        for oneError in filterErrors {
                            displayError +=  oneError + "\n"
                        }
                        self.installmentVC.errorLabel.isHidden = false
                        self.installmentVC.errorLabel.text  = displayError
                        self.installmentVC.scrollView.setContentOffset(.zero, animated: true)
                    }  else {
                        self.installmentVC.errorLabel.isHidden = false
                        self.installmentVC.errorLabel.text = err.detailedResponseMessage
                        self.installmentVC.scrollView.setContentOffset(.zero, animated: true)
                    }
                  
                } else {
                    self.viewModel.orderId = response?.orderId
                    
                    let payAmount =  String(format: "%.2f", self.installmentVC.viewModel.downPaymentAmount + self.viewModel.adminFees)
                    let doubleAmount = Double(payAmount) ?? 0.0
                    if  doubleAmount > 0 && installmentVC.selectedPayment == .PAYMENT_METHODS  {
                        self.stepView.setupStepView(currentStep: 3, total: 4)
                        self.paymentVC.viewModel.amount = GDAmount(amount:doubleAmount, currency: self.installmentVC.viewModel.amount?.currency ?? "EGP")
                        self.paymentVC.viewModel.orderId = viewModel.orderId
                        
                        self.paymentVC.viewModel.showShahry = false
                        self.paymentVC.viewModel.showValu = false
                        self.paymentVC.viewModel.showSouhoola = false
                        self.viewModel.currentFlow = .PAYMENT
                        let vc = PaymentFactory.makePaymentSelectionFormViewController()
                        vc.viewModel = self.paymentVC.viewModel
                        self.activeViewController = vc
                        localizeStrings()
                    } else {
                        self.errorSnackView.isHidden = true
                        OTPNextTapped(step: 3, total: 3)
                    }
                    
                }
            })
        }
    }
    
    func paymentNextTapped() {
        self.viewModel.currentFlow = .OTP
        localizeStrings()
    }
    
    func confirmNextTapped(with customerIdentifier: String) {
        let sharyDetails = GDShahrySelectPlanInstallment(customerIdentifier: customerIdentifier, totalAmount: viewModel.selectPaymentVM.amount.amount, currency: viewModel.selectPaymentVM.amount.currency, merchantReferenceId: viewModel.selectPaymentVM.customerDetails?.merchantReferenceId, callbackUrl: viewModel.selectPaymentVM.customerDetails?.callbackUrl, billingAddress: viewModel.selectPaymentVM.customerDetails?.billingAddress, shippingAddress: viewModel.selectPaymentVM.customerDetails?.shippingAddress, customerEmail: viewModel.selectPaymentVM.customerDetails?.customerEmail, restrictPaymentMethods: false, paymentMethods: viewModel.selectPaymentVM.paymentMethods, items: viewModel.selectPaymentVM.bnplItems, orderId: viewModel.selectPaymentVM.orderId)
        viewModel.customerId = customerIdentifier
        viewModel.installmentPlanSelected(with: sharyDetails, completion: { response,
            error in
            
            self.confirmShahryVC.nextBtn.hideLoading()
            if let err = error {
                
                if err.isError && !err.errors.isEmpty{
                    
                } else {
                    if err.responseCode == "720" {
                        if err.detailedResponseCode == "001" || err.detailedResponseCode == "009" || err.detailedResponseCode == "011" {
                            self.showReceipt(receipt: nil, error: err, receiptFlow: .SHAHRY)
                        } else {
                            self.confirmShahryVC.confirmErrorLabel.isHidden = false
                            self.confirmShahryVC.confirmErrorLabel.text = err.detailedResponseMessage
                        }
                    } else {
                        self.showReceipt(receipt: nil, error: err, receiptFlow: .SHAHRY)
                    }
                }
                
                
            } else {
                self.viewModel.orderId = response?.orderId
                self.activeViewController = self.purchaseShahryVC
                self.viewModel.currentFlow = .PURCHASE_SHAHRY
                self.stepView.setupStepView(currentStep: 2, total: 2)
                self.localizeStrings()
                
            }
        })
        
    }
    
    func confirmPurchaseNextTapped(with confirmDetails: GDShahryConfirm) {
        
        viewModel.confirm(with: confirmDetails, completion: { [self] response,
            error in
            
            self.purchaseShahryVC.nextBtn.hideLoading()
            if let err = error {
                
                if err.isError && !err.errors.isEmpty{
                    
                } else {
                    if err.responseCode == "720" {
                        if err.detailedResponseCode == "001" || err.detailedResponseCode == "009" || err.detailedResponseCode == "011" {
                            self.showReceipt(receipt: nil, error: err, receiptFlow: .SHAHRY)
                        } else {
                            self.purchaseShahryVC.orderTokenError.isHidden = false
                            self.purchaseShahryVC.orderTokenError.text = err.detailedResponseMessage
                        }
                    } else {
                        
                        self.showReceipt(receipt: nil, error: err, receiptFlow: .SHAHRY)
                    }
                }
                
                
            } else {
                let bnplDetails = response?.transactions?.last?.bnplDetails
                
                let fee = bnplDetails?.adminFees ?? 0 + (bnplDetails?.otherFees ?? 0)
                let amountToCollect = fee + (bnplDetails?.downPayment ?? 0)
                self.viewModel.orderId = response?.orderId
                
                
                if amountToCollect > 0 {
                    self.stepView.setupStepView(currentStep: 2, total: 3)
                    self.purchaseShahryVC.viewModel.totalAmountCollect = GDAmount(amount:amountToCollect, currency: bnplDetails?.currency ?? "EGP")
                    self.purchaseShahryVC.viewModel.downPayment = GDAmount(amount:bnplDetails?.downPayment ?? 0, currency: bnplDetails?.currency ?? "EGP")
                    self.purchaseShahryVC.viewModel.fee = GDAmount(amount:fee, currency: bnplDetails?.currency ?? "EGP")
                    self.purchaseShahryVC.setupConfirmButton()
                    
                    
                } else {
                    ReceiptManager().receipt(with: response?.orderId ?? "", completion:{ response, error in
                        self.showReceipt(receipt: response, error: error, receiptFlow: .SHAHRY)
                    })
                }
                
            }
        })
        
        self.activeViewController = self.purchaseShahryVC
    }
    
    func ShahryDownPaymentNextTapped(with payAmount: GDAmount) {
        self.paymentVC.viewModel.amount = payAmount
        self.paymentVC.viewModel.orderId = self.viewModel.orderId
        self.viewModel.currentFlow = .PAYMENT
        self.paymentVC.viewModel.showShahry = false
        self.paymentVC.viewModel.showValu = false
        self.paymentVC.viewModel.showSouhoola = false
        self.viewModel.currentFlow = .PAYMENT
        let vc = PaymentFactory.makePaymentSelectionFormViewController()
        let vm = self.paymentVC.viewModel
        vm?.orderId = viewModel.orderId
        vc.viewModel = vm
        self.activeViewController = vc
        self.stepView.setupStepView(currentStep: 3, total: 3)
        self.localizeStrings()
    }
    
    
    
    func payWithGeideaForm() {
        checkBackBtn(isVisible: true)
        let vc = PaymentFactory.makeCardDetailsFormViewController()
        vc.modalPresentationStyle = .fullScreen
        
        let total = paymentVC.viewModel.amount.amount
        vc.viewModel = PaymentFactory.makeCardDetailsFormViewModel(amount: GDAmount(amount: total, currency: viewModel.selectPaymentVM.amount.currency), showAdress: viewModel.selectPaymentVM.showAddress, showEmail: viewModel.selectPaymentVM.showEmail, showReceipt: viewModel.selectPaymentVM.showReceipt, tokenizationDetails: viewModel.selectPaymentVM.tokenizationDetails, customerDetails: viewModel.selectPaymentVM.customerDetails, applePay: viewModel.selectPaymentVM.applePay, config: viewModel.selectPaymentVM.config, paymentIntentId: viewModel.selectPaymentVM.paymentIntentId,paymentMethods: viewModel.selectPaymentVM.paymentMethods, isEmbedded: true,  isNavController: false, completion: { orderResponse, error   in
            if let err = error {
                if err.isError && !err.errors.isEmpty {
                    
                    self.showSnackBar(with: GDErrorResponse().withErrorCode(error: "responseMessage: \(err.errors)", code: "\(err.status)"))
                } else {
                    self.showSnackBar(with: err)
                }
//                self.viewModel.orderId = err.orderId
            } else {
                self.errorSnackView.isHidden = true
                
                switch self.viewModel.provider {
                case .ValU:
                    self.OTPNextTapped(step: 4, total: 4)
                case .Souhoola:
                    self.OTPNextTapped(step: 5, total: 5)
                case .SHAHRY:
                    self.viewModel.orderId =  self.viewModel.orderId
                    ReceiptManager().receipt(with: self.viewModel.orderId ?? "", completion:{ response, error in
                        self.showReceipt(receipt: response, error: error, receiptFlow: .SHAHRY)
                    })
                case .NONE:
                    ReceiptManager().receipt(with: orderResponse?.orderId ?? "", completion:{ response, error in
                        self.showReceipt(receipt: response, error: error, receiptFlow: .CARD)
                    })
                }
                
            }
            
        })
        stepView.isHidden = viewModel.provider == .NONE //isEmbeddedBack
        vc.viewModel.orderId = viewModel.orderId
        vc.viewModel.selectPaymentVM = viewModel.selectPaymentVM
//        if viewModel.currentFlow == .INSTALLMENT {
//            cardDetailsVC.isEmbeddedBack = true
//        }
        self.activeViewController = vc
        self.viewModel.currentFlow = .CARD_DETAILS
        
    }
    
    func payWithBNPL(provider: BNPLProvider) {
        self.viewModel.provider = provider
        if self.viewModel.selectPaymentVM.amount.amount >  Double(self.viewModel.selectPaymentVM.config?.valUMinimumAmount ?? 0) {
            
            self.activeViewController = phoneNumberVC
            self.viewModel.currentFlow = .BNPL_CONFIRM_PHONE
            if viewModel.provider == .Souhoola {
                self.stepView.setupStepView(currentStep: 1, total: 4)
            } else {
                self.stepView.setupStepView(currentStep: 1, total: 3)
            }
            localizeStrings()
        } else {
            errorSnackView.isHidden = false
            errorSnackCode.isHidden = true
            let minAmount = String(self.viewModel.selectPaymentVM.config?.valUMinimumAmount ?? 0 )
            errorSnackMessage.text = String(format: viewModel.valuLimitTitle, minAmount, self.viewModel.selectPaymentVM.amount.currency )
            
        }
        
    }
    
    func payWithShahry() {
        self.stepView.setupStepView(currentStep: 1, total: 2)
        self.activeViewController = confirmShahryVC
        self.viewModel.currentFlow = .SHAHRY_CONFIRM
        localizeStrings()
    }
    
    func payQRWithGeideaForm() {
        self.errorSnackView.isHidden = true
        checkBackBtn(isVisible: true)
        let vc = PaymentFactory.makeQRPaymentFormViewController()
        vc.modalPresentationStyle = .fullScreen
        checkBackBtn(isVisible: false)
        let total = paymentVC.viewModel.amount.amount
        vc.viewModel = PaymentFactory.makeQRPaymentFormViewModel(amount: GDAmount(amount: total, currency: viewModel.selectPaymentVM.amount.currency), customerDetails: viewModel.selectPaymentVM.qrCustomerDetails, config: viewModel.selectPaymentVM.config, expiryDate: viewModel.selectPaymentVM.qrExpiryDate, orderId: self.viewModel.selectPaymentVM.orderId, callbackUrl: self.viewModel.selectPaymentVM.customerDetails?.callbackUrl, showReceipt: viewModel.selectPaymentVM.showReceipt, isEmbedded: true, isNavController: false, completion:  { orderResponse, error  in
            
            if self.viewModel.provider == .ValU {
                if let err = error {
                    self.failureIcon.isHidden = true
                    self.showSnackBar(with: err)
                } else {
                    self.OTPNextTapped(step: 4, total: 4)
                }
                
            } else {
                if let err = error, err.responseCode == "0" {
                    self.failureIcon.isHidden = true
                    self.showSnackBar(with: err)
                } else {
                    self.errorSnackView.isHidden = true
                    
                    if self.viewModel.provider == .ValU  {
                        self.OTPNextTapped(step: 4, total: 4)
                    } else if self.viewModel.provider == .Souhoola  {
                        self.OTPNextTapped(step: 5, total: 5)
                    } else {
                        
                        if self.viewModel.provider == .NONE {
                            let vc = PaymentFactory.makeReceiptViewController()
                            
                            vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse: orderResponse, withError: nil, receiptFlow: .QR, config: self.viewModel.selectPaymentVM.config, completion: { response, error in
                                
//                            PaymentFactory.makeReceiptViewModel(withOrderResponse:
//                                                                                orderResponse?.orderId, withError: error, receiptFlow: .QR, merchantName: viewModel.selectPaymentVM.config?.name, isEmbedded: viewModel.isEmbedded,  completion: { response, error in
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.viewModel.selectPaymentVM.completion(response, error)
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }
                                
                            })
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            self.viewModel.orderId =  self.viewModel.orderId
                            ReceiptManager().receipt(with: self.viewModel.orderId ?? "", completion:{ response, error in
                                self.showReceipt(receipt: response, error: error, receiptFlow: .SHAHRY)
                            })
                        }
                       
                    }
                }
            }
        })
        stepView.isHidden = viewModel.provider == .NONE
        vc.viewModel.orderId = viewModel.orderId
        qrPaymentVC = vc
        self.activeViewController = qrPaymentVC
        self.viewModel.currentFlow = .QR
        
    }
    
    func OTPNextTapped(step: Int, total: Int) {
        
        switch(viewModel.provider) {
        case .Souhoola:
            
            self.viewModel.goToNextScren()
            self.activeViewController = self.oTPVC
            self.viewModel.currentFlow = .OTP
            self.stepView.setupStepView(currentStep: Double(step), total: Double(total))
            self.localizeStrings()
            
            
        case .ValU:
            self.viewModel.goToNextScren()
            self.activeViewController = self.oTPVC
            self.viewModel.currentFlow = .OTP
            self.stepView.setupStepView(currentStep: Double(step), total: Double(total))
            self.localizeStrings()
            
        default: break
        }
        
    }
    
    func souhoolaReviewNextTapped(with details: GDSouhoolaInstallmentPlanSelected) {
        
        checkBackBtn(isVisible: true)
        viewModel.souhoolaPlanSelected(with: details, completion: { [self] response, error in
            self.reviewTransactionVC.proceedBtn.hideLoading()
            if let err = error {
                
                if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015") {
                    self.showSnackBar(with: err)
                } else {
                    self.showReceipt(receipt: nil, error: error, receiptFlow: .SOUHOOLA)
                }
            } else {
                if let res = response {
                    viewModel.orderId = res.orderId
                    viewModel.bnplOrderID = res.souhoolaTransactionId
                    if res.nextStep == "proceedWithDownPayment" {
                        if reviewTransactionVC.selectedPayment == .PAYMENT_METHODS || reviewTransactionVC.selectedPayment == .NONE {
                            self.stepView.setupStepView(currentStep: 4, total: 5)
                            let downPayment = reviewTransactionVC.viewModel.reviewDetails.downPayment ?? 0.0
                            let fee = reviewTransactionVC.viewModel.reviewDetails.mainAdministrativeFees ?? 0.0
                            let payAmount =  downPayment + fee
                            self.paymentVC.viewModel.amount = GDAmount(amount:payAmount, currency: self.installmentVC.viewModel.amount?.currency ?? "EGP")
                            self.paymentVC.viewModel.orderId = viewModel.orderId
                            self.paymentVC.viewModel.showShahry = false
                            self.paymentVC.viewModel.showValu = false
                            self.paymentVC.viewModel.showSouhoola = false
                            self.viewModel.currentFlow = .PAYMENT
                            let vc = PaymentFactory.makePaymentSelectionFormViewController()
                            vc.viewModel = self.paymentVC.viewModel
                            self.activeViewController = vc
                            localizeStrings()
                        } else {
                            OTPNextTapped(step: 4, total: 4)
                        }
                        
                    } else {
                        OTPNextTapped(step: 4, total: 4)
                    }
                }
            }
        })
        
    }
    
    @IBAction func xBtnTapped(_ sender: Any) {
        
        if viewModel.provider == .Souhoola {
            if  let souhoolaId = reviewTransactionVC.viewModel.reviewDetails.souhoolaTransactionId {
                let souhoolaCancelDetails = GDSouhoolaCancelDetails(customerIdentifier: viewModel.customerId, customerPin: viewModel.pin, souhoolaTransactionId: souhoolaId)
                viewModel.souhoolaCancel(with: souhoolaCancelDetails, completion: {
                    response, error in
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func didBackBtnTapped() {
        errorSnackView.isHidden = true
    
    
        switch viewModel.currentFlow {
        case .BNPL_CONFIRM_PHONE:
            
            if let navController = navigationController {
                navController.popViewController(animated: true)
            } else{
                dismiss(animated: true, completion: nil)
            }
            
        case .INSTALLMENT:
            checkBackBtn(isVisible: true)
            activeViewController = phoneNumberVC
            viewModel.pin = nil
            viewModel.customerId = nil
            phoneNumberVC.phoneNumberTF.text = ""
            phoneNumberVC.pinTF.text = ""
            if viewModel.provider == .ValU {
                stepView.setupStepView(currentStep: 1, total: 3)
            } else {
                stepView.setupStepView(currentStep: 1, total: 4)
            }
            
        case .PAYMENT:
            checkBackBtn(isVisible: true)
            activeViewController = installmentVC
            stepView.setupStepView(currentStep: 2, total: 3)
        case .OTP:
            activeViewController = installmentVC
            stepView.setupStepView(currentStep: 2, total: 3)
        case .CARD_DETAILS:
            checkBackBtn(isVisible: false)
            activeViewController = paymentVC
            stepView.setupStepView(currentStep: 3, total: 4)
        case .QR:
            checkBackBtn(isVisible: false)
            activeViewController = paymentVC
            stepView.setupStepView(currentStep: 3, total: 4)
        case .SHAHRY_CONFIRM:
            if let navController = navigationController {
                navController.popViewController(animated: true)
            } else{
                dismiss(animated: true, completion: nil)
            }
        case .PURCHASE_SHAHRY:
            checkBackBtn(isVisible: true)
            activeViewController = confirmShahryVC
            stepView.setupStepView(currentStep: 1, total: 2)
        case .REVIEW_TRANSACTION:
            activeViewController = installmentVC
            cancelSouhoola()
            stepView.setupStepView(currentStep: 2, total: 4)
        }
        viewModel.goToPreviousScren()
        localizeStrings()
    }
    
    func cancelSouhoola() {
        if  let souhoolaId = reviewTransactionVC.viewModel.reviewDetails.souhoolaTransactionId {
            let souhoolaCancelDetails = GDSouhoolaCancelDetails(customerIdentifier: viewModel.customerId, customerPin: viewModel.pin, souhoolaTransactionId: souhoolaId)
            viewModel.souhoolaCancel(with: souhoolaCancelDetails, completion: {
                response, error in
            })
        }
    }
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
            
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMove(toParentViewController: self)
            
        }
    }
    
    func showReceipt(receipt: GDReceiptResponse?, error: GDErrorResponse?, receiptFlow: ReceiptFlow) {
        
        
        let vc = PaymentFactory.makeReceiptViewController()
        var merchantName = ""
        switch GlobalConfig.shared.language {
        case .arabic:
            merchantName = receipt?.receipt?.merchant?.nameAr ?? ""
        default:
            merchantName = receipt?.receipt?.merchant?.name ?? ""
        }
        
        vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse:
                                                            nil, withError: error, withReceipt: receipt?.receipt, receiptFlow: receiptFlow, config: viewModel.selectPaymentVM.config, isEmbedded: true,  completion: { response, error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewModel.selectPaymentVM.completion(response, error)
                self.dismiss(animated: true, completion: nil)
                
            }
            
        })
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
