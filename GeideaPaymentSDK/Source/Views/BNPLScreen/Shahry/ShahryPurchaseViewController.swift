//
//  ShahryPurchaseViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 29.03.2022.
//

import UIKit

class ShahryPurchaseViewController: BaseViewController  {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var shahryLabel: UILabel!
    @IBOutlet weak var totalAmountValue: UILabel!
    @IBOutlet weak var totalAmountCurrency: UILabel!
    @IBOutlet weak var shahryIdValue: UILabel!
    @IBOutlet weak var orderTokenTF: UITextField!
    @IBOutlet weak var orderTokenError: UILabel!
    
    @IBOutlet weak var merchantNameValue: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var purchaseTV: UITextView!
    @IBOutlet weak var payUpFrontView: UIView!
    @IBOutlet weak var screenError: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var payUpfrontLabel: UILabel!
    @IBOutlet weak var purchaseFeeLabel: UILabel!
    @IBOutlet weak var purchaseFeeValue: UILabel!
    @IBOutlet weak var downPaymentLabel: UILabel!
    @IBOutlet weak var downPaymentValue: UILabel!
    @IBOutlet weak var totalAmountToBePaidLabel: UILabel!
    @IBOutlet weak var totalAmountToBePaidValue: UILabel!
    @IBOutlet weak var nextBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cashViewTitle: UILabel!
    @IBOutlet weak var cardSelectedTitle: UILabel!
    @IBOutlet weak var cashSelectedTitle: UILabel!
    @IBOutlet weak var cashSelectedBtn: RadialCircleView!
    @IBOutlet weak var cardSelectedBtn: RadialCircleView!
    var selectedPayment = PaymentSelectionFlow.NONE
    var sharyOrderTokenTimer: Timer? = nil
    var bnplVM: BNPLViewModel?
    
    var viewModel: ShahryPurchaseViewModel!
    
    
    var selectedImage  = UIImage(named: "pmChecked", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
    var unSelectedImage:UIImage?  = UIImage(named: "pmUnchecked", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
    
    init() {
        super.init(nibName: "ShahryPurchaseViewController", bundle: Bundle(for: ShahryConfirmViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "ShahryPurchaseViewController", bundle: Bundle(for: ShahryConfirmViewController.self))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePreferredSize()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bnpl = self.parent as? BNPLViewController {
            bnplVM = bnpl.viewModel
            localizeStrings()
            totalAmountValue.text = String(format: "%.2f", bnpl.viewModel.selectPaymentVM.amount.amount)
            totalAmountCurrency.text = bnpl.viewModel.selectPaymentVM.amount.currency
            shahryIdValue.text = bnpl.viewModel.customerId
            bnpl.stepView.backBtn.isHidden = true
            bnpl.stepView.backBtnGestureRecognizer.isEnabled = false
            
            selectedPayment = .NONE

            nextBtn.enabled(isEnabled: false, config: bnplVM?.selectPaymentVM.config)

            nextBtn.setTitle(viewModel.confirmTitle, for: .normal)
            
            var merchantName = ""
            switch GlobalConfig.shared.language {
            case .arabic:
                merchantName = bnpl.viewModel.selectPaymentVM.config?.merchantNameAr ?? ""
            default:
                merchantName = bnpl.viewModel.selectPaymentVM.config?.merchantName ?? ""
            }
            confirmLabel.text = String(format: viewModel.termsTitle, merchantName)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupViews()
        
        registerForKeyboardNotifications()
    
    }
    
    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width, height: view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
        preferredContentSize = contentView.systemLayoutSizeFitting(targetSize)
    }
    
    func setupViews() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let htmlString = "\(viewModel.openTitle) <b>\(viewModel.shahryAppTitle)</b> \(viewModel.toCompleteBodyTitle). <a href='https://shahry.app/how-to-order-online-through-partner-website'> \(viewModel.needHelpTitle) </a>?"
        let range1 = (htmlString as NSString).range(of: "<b>")
        let range2 = (htmlString as NSString).range(of: "</b>")
        let requiredRange = NSRange(location: range1.location, length: range2.location - range1.location - range1.length)
        if let htmlData = htmlString.data(using: .utf8) {
            if let attributedString = try? NSAttributedString(
                data: htmlData,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil) {
            
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .center
                let formatted = NSMutableAttributedString(attributedString: attributedString)
                formatted.addAttributes([
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                    NSAttributedString.Key.paragraphStyle: paragraph
                ], range: NSRange.init(location: 0, length: attributedString.length))
                formatted.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .bold), range: requiredRange)

                purchaseTV.attributedText = formatted
            }
        }
        
        orderTokenTF.autocorrectionType = .no
        orderTokenTF.spellCheckingType = .no
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.contentView.addGestureRecognizer(tap)
        
        let cardBtnTapped = UITapGestureRecognizer(target: self, action: #selector(self.cardBtnTappped(_:)))
        cardSelectedBtn.addGestureRecognizer(cardBtnTapped)
        
        let cashBtnTapped = UITapGestureRecognizer(target: self, action: #selector(self.cashBtnTappped(_:)))
        cashSelectedBtn.addGestureRecognizer(cashBtnTapped)
        
        if let bnpl = self.parent as? BNPLViewController {
            bnplVM = bnpl.viewModel
            
            merchantNameValue.text = GlobalConfig.shared.language == .arabic ? bnplVM?.selectPaymentVM.config?.merchantNameAr : bnplVM?.selectPaymentVM.config?.merchantName
        }
        
        handleTextFields()
        
       setBranding()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height+100, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height+20;
        
        let activeField: UITextField? = orderTokenTF
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
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: bnplVM?.selectPaymentVM.config)
        nextBtn.enabled(isEnabled: false, config: bnplVM?.selectPaymentVM.config)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        orderTokenTF.resignFirstResponder()
    }
    
    override func localizeStrings() {
        merchantNameLabel.text = viewModel.merchantNameTitle
        totalAmountLabel.text = viewModel.totalAmountTitle
        nextBtn.setTitle(viewModel.confirmTitle, for: .normal)
        orderTokenTF.placeholder = viewModel.orderToken
        shahryLabel.text = viewModel.shahryId
        payUpfrontLabel.text = viewModel.payUpFrontTitle
        totalAmountToBePaidLabel.text = viewModel.totalAmountUpfrontTitle
        purchaseFeeLabel.text = viewModel.purchaseFeeTitle
        downPaymentLabel.text = viewModel.downPaymentTitle
        cashViewTitle.text = viewModel.choosePay
        
    }
    
    func handleTextFields() {
        orderTokenTF.delegate = self
        orderTokenTF.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: viewModel.doneTitle)
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
        orderTokenTF.resignFirstResponder()
    }
    
    func setupConfirmButton() {
        if  viewModel.totalAmountCollect != nil {
            nextBtn.hideLoading()

            nextBtn.enabled(isEnabled: false, config: bnplVM?.selectPaymentVM.config)

            nextBtn.setTitle(viewModel.proceedTitle, for: .normal)
            payUpFrontView.isHidden = false
            
            
            if let bnpl = self.parent as? BNPLViewController {
                cashView.isHidden = !(bnpl.viewModel.selectPaymentVM.config?.allowCashOnDeliveryShahry ?? false)
            }
           
            confirmLabel.isHidden = true
            
            downPaymentValue.text =  String(format: "%.2f",viewModel.downPayment?.amount ?? 0) + " " + (viewModel.downPayment?.currency ?? "SAR")
            purchaseFeeValue.text = String(format: "%.2f",viewModel.fee?.amount ?? 0) + " " + (viewModel.fee?.currency ?? "SAR")
            let formattedAmount =  String(format: "%.2f",viewModel.totalAmountCollect?.amount ?? 0)
            totalAmountToBePaidValue.text =  formattedAmount + " " + (viewModel.totalAmountCollect?.currency ?? "SAR")
            
            switch GlobalConfig.shared.language {
            case .arabic:
                cashSelectedTitle.text = String(format: viewModel.cashSelectedTitle,viewModel.totalAmountCollect?.currency ?? "SAR", formattedAmount)
                cardSelectedTitle.text = String(format: viewModel.cardSelectedTitle, viewModel.totalAmountCollect?.currency ?? "SAR", formattedAmount)
            default:
                cashSelectedTitle.text = String(format: viewModel.cashSelectedTitle, formattedAmount, viewModel.totalAmountCollect?.currency ?? "SAR")
                cardSelectedTitle.text = String(format: viewModel.cardSelectedTitle, formattedAmount, viewModel.totalAmountCollect?.currency ?? "SAR" )
            }
        }
        
    }
      
    @IBAction func cancelTapped(_ sender: Any) {
        
        if let orderId = self.bnplVM?.selectPaymentVM.orderId, !orderId.isEmpty {
            logEvent("Cancelled By User \(orderId)")
            let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
            CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                self.viewModel.orderId = nil
            })
        }
        dismiss(animated: false)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let bnpl = self.parent as? BNPLViewController {
            nextBtn.showLoading()
            if let dp = viewModel.totalAmountCollect {
                
                if selectedPayment == .PAYMENT_METHODS || selectedPayment == .NONE {
                    bnpl.ShahryDownPaymentNextTapped(with: dp)
                } else if selectedPayment == .CASH {
                    
                    GeideaBNPLAPI.shahryCashOnDelivery(with: GDCashOnDelivery(orderId: bnpl.viewModel.orderId), completion: {response, error in
                        
                        ReceiptManager().receipt(with: response?.orderId ?? "", completion:{ response, error in
                            bnpl.showReceipt(receipt: response, error: error, receiptFlow: .SHAHRY)
                        })
                    
                    })
                }
                
            } else {
                
                let shahryConfirm = GDShahryConfirm(orderId: bnpl.viewModel.orderId, orderToken: orderTokenTF.text ?? "")
                bnpl.confirmPurchaseNextTapped(with: shahryConfirm)
            }
           
        }
    }
    
    @objc func cardBtnTappped(_ sender: UITapGestureRecognizer? = nil) {
        cardSelectedBtn.enabled(enabled: true, config: bnplVM?.selectPaymentVM.config)
        cashSelectedBtn.enabled()
        nextBtn.setTitle(viewModel.proceedTitle, for: .normal)
        selectedPayment = .PAYMENT_METHODS
        
        if let bnpl = self.parent as? BNPLViewController {
            bnpl.stepView.setupStepView(currentStep: 2, total: 3)
        }
        
        validateButton()
        
        
    }
    
    @objc func cashBtnTappped(_ sender: UITapGestureRecognizer? = nil) {
        cashSelectedBtn.enabled(enabled: true, config: bnplVM?.selectPaymentVM.config)
        cardSelectedBtn.enabled()
        nextBtn.setTitle(viewModel.proceedCashTitle, for: .normal)
    
        selectedPayment = .CASH
        
        if let bnpl = self.parent as? BNPLViewController {
            bnpl.stepView.setupStepView(currentStep: 2, total: 2)
        }
        
        validateButton()
        
    }
}


extension ShahryPurchaseViewController: UITextFieldDelegate {

    fileprivate func areFieldsValid() -> Bool {
        var isValid = false
        if orderTokenTF.text?.count ?? 0 > 3 {
            isValid = true
        }
        
        if let validator = viewModel.orderTokenValidator(orderToken: orderTokenTF.text ?? "") {
            orderTokenError.text = validator
            orderTokenError.isHidden = false
            isValid = false
        } else {
            orderTokenError.isHidden = true
        }
        
        if !cashView.isHidden && selectedPayment == .NONE {
           isValid = false
        }
        
        return isValid
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }

    func validateButton() {
        nextBtn.enabled(isEnabled: orderTokenTF.text?.count ?? 0 > 3 && areFieldsValid(), config: bnplVM?.selectPaymentVM.config)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        sharyOrderTokenTimer?.invalidate()
        
        sharyOrderTokenTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.shahryIdCheck),
            userInfo: ["textField": textField],
            repeats: false)
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {

           orderTokenTF.resignFirstResponder()
           return true
       }
    
    @objc func shahryIdCheck() {
        _ = areFieldsValid()
        validateButton()
    }
    
   
}


