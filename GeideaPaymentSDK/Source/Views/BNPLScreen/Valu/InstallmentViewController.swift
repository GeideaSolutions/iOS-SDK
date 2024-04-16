//
//  InstallmentViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.02.2022.
//

import UIKit

enum PaymentSelectionFlow {
    case CASH
    case PAYMENT_METHODS
    case NONE
}

class InstallmentViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feeLabel: UILabel!
    
    @IBOutlet weak var totalCurrencyLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var downPaymentView: UIView!
    @IBOutlet weak var installmentView: UIView!
    
    @IBOutlet weak var financedLabel: UILabel!
    @IBOutlet weak var totalAmountValue: UILabel!
    @IBOutlet weak var financedValue: UILabel!
    @IBOutlet weak var financedViewValu: UIView!
    @IBOutlet weak var financedCurrencyLabel: UILabel!
    
    @IBOutlet weak var downPaymentTitle: UILabel!
    @IBOutlet weak var downPaymentTF: UITextField!
    @IBOutlet weak var downPaymentErrorLabel: UILabel!
    
    @IBOutlet weak var ToULabel: UILabel!
    @IBOutlet weak var toUTF: UITextField!
    @IBOutlet weak var toUErrorLabel: UILabel!
    
    @IBOutlet weak var cashBackLabel: UILabel!
    @IBOutlet weak var cashBackTF: UITextField!
    @IBOutlet weak var cashbackErrorLabel: UILabel!
    
    
    @IBOutlet weak var installmentVC: UICollectionView!
    @IBOutlet weak var installmentPlanLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var nextBtn: RoundedButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var payUpFrontLabel: UILabel!
    @IBOutlet weak var logoIV: UIImageView!
    
    @IBOutlet weak var purchaseFeeLabel: UILabel!
    
    @IBOutlet weak var purchaseFeeValue: UILabel!
    
    @IBOutlet weak var downPaymentLabel: UILabel!
    @IBOutlet weak var downPaymentValue: UILabel!
    
    @IBOutlet weak var totalAmountPaid: UILabel!
    @IBOutlet weak var totalAmountPaidValue: UILabel!
    @IBOutlet weak var downPaymentSV: UIStackView!
    @IBOutlet weak var toUPaymentSV: UIStackView!
    @IBOutlet weak var cashbackSV: UIStackView!
    
    @IBOutlet weak var payUpFrontView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cashLabel: UILabel!
    
    @IBOutlet weak var cardSelectedLabel: UILabel!

    
    
    @IBOutlet weak var cardSelectedBtn: RadialCircleView!
    @IBOutlet weak var cashSelectedBtn: RadialCircleView!
    @IBOutlet weak var cashSelectedLabel: UILabel!
    
    // MARK: - Souhoola
    
    @IBOutlet weak var souhollaDPSV: UIStackView!
    @IBOutlet weak var souhoolaDPLabel: UILabel!
    @IBOutlet weak var souhoolaDPTF: UITextField!
    @IBOutlet weak var souhoolaDPError: UILabel!
    @IBOutlet weak var souhoolaRangeLabel: UILabel!
    @IBOutlet weak var souHoolaFinancedLabel: UILabel!
    @IBOutlet weak var souhoolaFinancedView: UIView!
    @IBOutlet weak var souhoolaFinancedValue: UILabel!
    @IBOutlet weak var souhoolaFinancedCurrency: UILabel!
    @IBOutlet weak var souhoolaAproxLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    var amountTimer: Timer? = nil
    var selectedPayment = PaymentSelectionFlow.NONE
    
    var viewModel: InstallmentViewModel!
    var bnplVM: BNPLViewModel!
    

    
    var souhoolaMin = 0.0
    var souhoolaMax = 0.0
    
    private var inputs: [UITextField]!
    
    private var selectedIndexPath: IndexPath?
    
    init() {
        super.init(nibName: "InstallmentViewController", bundle: Bundle(for: InstallmentViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "InstallmentViewController", bundle: Bundle(for: InstallmentViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bnpl = self.parent as? BNPLViewController {
            bnplVM = bnpl.viewModel
        }
        
        registerForKeyboardNotifications()
        
        
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
        let info = notification.userInfo!
        let rect: CGRect = info[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height+100, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height+20;
        
        if inputs != nil {
            let activeField: UITextField? = inputs.first { $0.isFirstResponder }
            if let activeField = activeField {
                if !aRect.contains(activeField.frame.origin) {
                    let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                    scrollView.setContentOffset(scrollPoint, animated: true)
                }
            }
        }
        
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
//    func registerForKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(sender:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(sender:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
//    }
//
//    @objc func onKeyboardAppear(sender: NSNotification) {
//         self.view.frame.origin.y = -150 // Move view 150 points upward
//    }
//
//    @objc func onKeyboardDisappear(sender: `NSNotification`) {
//         self.view.frame.origin.y = 0 // Move view to original position
//    }
    override func viewWillAppear(_ animated: Bool) {
        bnplVM.downPayment = nil
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = installmentVC.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        
        self.view.layoutIfNeeded()
        calculatePreferredSize()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        errorLabel.isHidden = true
    }
    
    override func localizeStrings() {
        
        nextBtn.setTitle(viewModel.nextTitle, for: .normal)
        cancelBtn.setTitle(viewModel.cancelTitle, for: .normal)
        totalAmountLabel.text = viewModel.totalAmountTitle
        financedLabel.text = viewModel.financedAmountTitle
        souHoolaFinancedLabel.text = viewModel.financedAmountTitle
        downPaymentLabel.text = viewModel.downPaymentTitle
        cashBackLabel.text = viewModel.cashbackTitle
        ToULabel.text = viewModel.toUBalanceTitle
        souhoolaDPLabel.text = viewModel.downPaymentTitle
        payUpFrontLabel.text = viewModel.payUpFrontTitle
        purchaseFeeLabel.text = viewModel.payUpFrontTitle
        downPaymentTitle.text = viewModel.downPaymentTitle
        totalAmountPaid.text = viewModel.totalAmountUpfrontTitle
        installmentPlanLabel.text = viewModel.installmentPlansTitle
        cashLabel.text = viewModel.choosePay
        souhoolaAproxLabel.text = viewModel.souhoulaAproxLabel
    }
    
    
    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width, height: view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
        preferredContentSize = contentView.systemLayoutSizeFitting(targetSize)
    }
    
    func setupViews() {
        localizeStrings()
        setBranding()
        self.checkButton()
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.setContentOffset(.zero, animated: false)
        
        setUpCollectionView()
        if let safeAmount = viewModel.amount?.amount {
            totalAmountValue.text = String(format: "%.2f", safeAmount)
            financedValue.text = String(format: "%.2f", safeAmount)
            souhoolaFinancedValue.text = String(format: "%.2f", safeAmount)
            totalCurrencyLabel.text = viewModel.amount?.currency
            financedCurrencyLabel.text = viewModel.amount?.currency
            souhoolaFinancedCurrency.text = viewModel.amount?.currency
            
        }
        souhoolaRangeLabel.isHidden = true
        checkInputs()
        setupViewsProvider()
        errorLabel.isHidden = true
        
        modifyFinancedAmount()
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: bnplVM.selectPaymentVM.config)
        nextBtn.enabled(isEnabled: true, config: bnplVM.selectPaymentVM.config)
    }
    
    func setupViewsProvider() {
        switch bnplVM.provider {
        case .ValU:
            downPaymentSV.isHidden = false
            toUPaymentSV.isHidden = false
            cashbackSV.isHidden = false
            logoIV.image = UIImage(named: "valU_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            souhollaDPSV.isHidden = true
            souhoolaFinancedView.isHidden = true
            payUpFrontView.isHidden = true
            cashView.isHidden = !(bnplVM.selectPaymentVM.config?.allowCashOnDeliveryValu ?? false) || viewModel.installmentSelected == nil
            if cashView.isHidden {
                selectedPayment = .PAYMENT_METHODS
            }
            souhoolaAproxLabel.isHidden = true
            
            let cardBtnTapped = UITapGestureRecognizer(target: self, action: #selector(self.cardBtnTappped(_:)))
            cardSelectedBtn.addGestureRecognizer(cardBtnTapped)
            
            let cashBtnTapped = UITapGestureRecognizer(target: self, action: #selector(self.cashBtnTappped(_:)))
            cashSelectedBtn.addGestureRecognizer(cashBtnTapped)
        case .Souhoola:
            toUPaymentSV.isHidden = true
            cashbackSV.isHidden = true
            downPaymentSV.isHidden = true
            souhollaDPSV.isHidden = false
            souhoolaFinancedView.isHidden = false
            financedViewValu.isHidden = true
            souhoolaAproxLabel.isHidden = false
            switch GlobalConfig.shared.language {
            case .arabic:
                logoIV.image = UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            default:
                logoIV.image = UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            }
            cashView.isHidden = true
            payUpFrontView.isHidden = true
            souhollaDPSV.isHidden = false
        case .SHAHRY, .NONE:
            break
        }
    }
    
    
    func checkInputs() {
        
        switch bnplVM.provider {
        case .ValU:
            inputs = [downPaymentTF, toUTF, cashBackTF]
        default:
            inputs = [downPaymentTF, toUTF, cashBackTF, souhoolaDPTF]
        }
        handleTextFields()
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
    
    private func unfocusFields() {
        
        inputs.forEach {
            $0.endEditing(true)
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
    
    @objc func getInstallmentPlans() {
        
//        viewModel.installmentSelected = nil
        
        switch bnplVM.provider {
        case .ValU:
            let details = GDInstallmentPlanDetails(customerIdentifier: viewModel.customerIdentifier, totalAmount: viewModel.amount?.amount ?? 0.00, currency: viewModel.amount?.currency, downPayment: viewModel.downPaymentAmount, giftCardAmount: bnplVM.toUAmount?.amount ?? 0.00, campaignAmount: bnplVM.cashBackAmount?.amount ?? 0.00, adminFees: bnplVM.adminFees)
            
            GeideaBNPLAPI.VALUGetInstallmentPlan(with: details, completion: { [self] response, error in
                if let err = error {
                    
                    if err.detailedResponseCode == "001" || err.detailedResponseCode == "005" || err.detailedResponseCode == "0013" {
                        self.showReceipt(receipt: nil, error: err)
                        return
                    }
                    self.errorLabel.isHidden = false
                    self.installmentView.isHidden = true
                    
                    
                    if err.isError && !err.errors.isEmpty {
                        let filterErrors = err.errors.flatMap { $0.value }
                        var displayError = ""
                        for oneError in filterErrors {
                            displayError +=  oneError + "\n"
                        }
                        self.errorLabel.text = displayError
                    } else {
                        self.errorLabel.text = err.detailedResponseMessage
                    }
                    
                } else if let plans = response?.installmentPlans {
                    self.errorLabel.isHidden = true
                    self.installmentView.isHidden = false
                    self.viewModel.installmentPlans = [InstallmantPlanCellViewModel]()
                    for plan in plans {
                        self.viewModel.installmentPlans.append(InstallmantPlanCellViewModel(plan))
                    }
                    self.installmentVC.reloadData()
                }
                
                if bnplVM.provider == .ValU {
                    let doubleAmount =  Double(self.financedValue.text ?? "") ?? 0
                    if doubleAmount < 0 {
                        errorLabel.isHidden = false
                        errorLabel.text = GDErrorCodes.E036.detailedResponseMessage
                        self.installmentView.isHidden = true
                        
                        self.checkButton()
                    }
                }
                
            })
        case .Souhoola:
            bnplVM.getSouhoolaInstallmentPlans( completion: { [self] response, error in
                if let err = error {
                    if err.responseCode == "720" && (err.detailedResponseCode == "022" || err.detailedResponseCode == "015" || err.detailedResponseCode == "023" ) {
                        self.errorLabel.isHidden = false
                        self.installmentView.isHidden = true
                    
                        if err.isError && !err.errors.isEmpty {
                            let filterErrors = err.errors.flatMap { $0.value }
                            var displayError = ""
                            for oneError in filterErrors {
                                displayError +=  oneError + "\n"
                            }
                            self.errorLabel.text = displayError
                        } else {
                            self.errorLabel.text = err.detailedResponseMessage
                        }
                    } else {
                        self.showReceipt(receipt: nil, error: error)
                    }
                    
                } else {
                    if let plans = response?.installmentPlans {
//                        var installmentPlans = [InstallmantPlanCellViewModel]()
                        self.viewModel.installmentPlans = [InstallmantPlanCellViewModel]()
                        for plan in plans {
                            if  let selected = viewModel.installmentSelected, plan.tenorMonth == selected.tenorMonth {
                                                        let iPViewModel = InstallmantPlanCellViewModel(plan)
                                                            iPViewModel.selected = true
                                                        self.viewModel.installmentPlans.append(iPViewModel)
                                                    } else {
                                                        self.viewModel.installmentPlans.append(InstallmantPlanCellViewModel(plan))
                                                    }
                        }
                        
//                        self.viewModel.installmentPlans = installmentPlans
                        self.installmentVC.reloadData()
                    }
                }
            })
            
        case .SHAHRY, .NONE: break

        }
        
    }
    
    func showReceipt(receipt: GDReceiptResponse?, error: GDErrorResponse?) {
        let vc = PaymentFactory.makeReceiptViewController()
        
        vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse:
                                                            nil, withError: error, withReceipt: receipt?.receipt, receiptFlow: .VALU, config: bnplVM.selectPaymentVM.config, isEmbedded: true,  completion: { response, error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.bnplVM.selectPaymentVM.completion(nil, error)
                self.dismiss(animated: true, completion: nil)
            }
        })
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func validateSouhoolaDP() -> Bool {
        var valid = true
        if let validator = viewModel.isAmountNumeric(amount: souhoolaDPTF.text ?? "0") {
            souhoolaDPError.text = validator.detailedResponseMessage
            souhoolaDPError.isHidden = false
            valid = false
        } else {
            
            if let validator = viewModel.isAmountValid(amount: Double(souhoolaDPTF.text ?? "0") ?? 0){
                souhoolaDPError.text = validator.detailedResponseMessage
                souhoolaDPError.isHidden = false
                valid = false
            } else if Double(souhoolaDPTF.text ?? "0") ?? 0 < souhoolaMin ||  Double(souhoolaDPTF.text ?? "0") ?? 0  > souhoolaMax {
                souhoolaRangeLabel.textColor = UIColor.formLabelErrorColor
                souhoolaDPError.text = String(format: viewModel.souhoulaFinancedError, String(bnplVM.souhoolaVerifyResponse?.minLoanAmount ?? 0), bnplVM.selectPaymentVM.amount.currency)
                  souhoolaDPError.isHidden = false
                valid = false
                let doubleFinanced = Double(souhoolaDPTF.text ?? "0") ?? 0
                let financedAmount = Double(viewModel.amount?.amount ?? 0) - doubleFinanced
                souhoolaFinancedValue.text = String(format: "%.2f", financedAmount)
            } else {
                souhoolaRangeLabel.textColor = UIColor.form506Color
                self.souhoolaDPError.isHidden = true
            }
            
            self.checkButton()
        }
        return valid
    }
    
    @objc func modifyFinancedAmount() {
//        viewModel.installmentSelected = nil
        errorLabel.isHidden = true
        var valid = true
        if let validator = viewModel.isAmountNumeric(amount: downPaymentTF.text ?? "0") {
            downPaymentErrorLabel.text = validator.detailedResponseMessage
            downPaymentErrorLabel.isHidden = false
            valid = false
//        } else if bnplVM.provider == .Souhoola, let validator = viewModel.isSouhoolaDownPaymentValid(amount: souhoolaDPTF.text ?? "0", min: souhoolaMin, max: souhoolaMax) {
//            souhoolaDPError.text = validator.detailedResponseMessage
//            souhoolaDPError.isHidden = false
//            valid = false
        } else {
            if let validator = viewModel.isAmountValid(amount: Double(downPaymentTF.text ?? "0") ?? 0)  {
                downPaymentErrorLabel.text = validator.detailedResponseMessage
                downPaymentErrorLabel.isHidden = false
                valid = false
            } else {
                self.downPaymentErrorLabel.isHidden = true
            }
        }
        
        
        if let validator = viewModel.isAmountNumeric(amount: toUTF.text ?? "0") {
            toUErrorLabel.text = validator.detailedResponseMessage
            toUErrorLabel.isHidden = false
            valid = false
        } else {
            if let validator = viewModel.isAmountValid(amount: Double(toUTF.text ?? "0") ?? 0)  {
                toUErrorLabel.text = validator.detailedResponseMessage
                toUErrorLabel.isHidden = false
                valid = false
            } else {
                self.toUErrorLabel.isHidden = true
            }
        }
        
        if let validator = viewModel.isAmountNumeric(amount: cashBackTF.text ?? "0") {
            cashbackErrorLabel.text = validator.detailedResponseMessage
            cashbackErrorLabel.isHidden = false
            valid = false
        } else {
            if let validator = viewModel.isAmountValid(amount: Double(cashBackTF.text ?? "0") ?? 0){
                cashbackErrorLabel.text = validator.detailedResponseMessage
                cashbackErrorLabel.isHidden = false
                valid = false
            } else {
                self.cashbackErrorLabel.isHidden = true
            }
        }
        
        valid = validateSouhoolaDP()
        
        self.checkButton()
        
        
        if valid {
            if  let safeAmount = totalAmountValue.text, let doubleAmount = Double(safeAmount), let safeDownPayment = downPaymentTF.text, let safeToUTF = toUTF.text, let safeCashbackTF = cashBackTF.text,  let safeSouhoolaDP = souhoolaDPTF.text {
                
                
                let doubleDow = bnplVM.provider == .ValU ?  Double(String(format: "%.2f", Double(safeDownPayment) ?? 0.00)) ?? 0.00 : Double(String(format: "%.2f", Double(safeSouhoolaDP) ?? 0.00)) ?? 0.00
                
                bnplVM.downPayment = GDAmount(amount: doubleDow, currency: viewModel.amount?.currency ?? "EGP")
                
                let doubleCashback = Double(String(format: "%.2f", Double(safeCashbackTF) ?? 0.00 )) ?? 0.00
                bnplVM.cashBackAmount = GDAmount(amount: doubleCashback, currency: viewModel.amount?.currency ?? "EGP")
                
                let doubleToU = Double(String(format: "%.2f", Double(safeToUTF) ?? 0.00 )) ?? 0.00
                bnplVM.toUAmount = GDAmount(amount: doubleToU , currency: viewModel.amount?.currency ?? "EGP")
                
                let financedAmount = doubleAmount - (doubleDow + doubleCashback + doubleToU)
                financedValue.text = String(format: "%.2f", financedAmount)
        
                souhoolaFinancedValue.text = String(format: "%.2f", financedAmount)
                
                viewModel.downPaymentAmount = doubleDow
                bnplVM.downPayment?.amount = viewModel.downPaymentAmount
                
                getInstallmentPlans()
                
            }
            
        }
        
    }
    
    
    func isButtonValid() -> Bool {
        if errorLabel.isHidden && downPaymentErrorLabel.isHidden && toUErrorLabel.isHidden && cashbackErrorLabel.isHidden && souhoolaDPError.isHidden  && viewModel.installmentSelected != nil  && cashView.isHidden {

            return true
        } else {
            if selectedPayment == .NONE || viewModel.installmentSelected == nil {
                return false
            } else {
                return true
            }
        }
        
       
    }
    
    private func setUpCollectionView() {
        
        installmentVC.register(UINib(nibName: "InstallmentsCollectionViewCell", bundle: Bundle(for: InstallmentsCollectionViewCell.self)), forCellWithReuseIdentifier: "installmentCell")
        installmentVC.delegate = self
        installmentVC.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        installmentVC
            .setCollectionViewLayout(layout, animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if let bnpl = self.parent as? BNPLViewController {
            nextBtn.showLoading()
            bnpl.installmentNextTapped()
        }
    }
    
    
    @objc func cardBtnTappped(_ sender: UITapGestureRecognizer? = nil) {
        cardSelectedBtn.enabled(enabled: true, config: bnplVM.selectPaymentVM.config)
        cashSelectedBtn.enabled()
        selectedPayment = .PAYMENT_METHODS
        
        checkButton()
    }
    
    @objc func cashBtnTappped(_ sender: UITapGestureRecognizer? = nil) {
        cashSelectedBtn.enabled(enabled: true, config: bnplVM.selectPaymentVM.config)
        cardSelectedBtn.enabled()
        selectedPayment = .CASH
        
        checkButton()
    }
    
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        if let orderId = bnplVM?.selectPaymentVM.orderId, !orderId.isEmpty {
            logEvent("Cancelled By User \(orderId)")
            let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
            CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                self.viewModel.orderId = nil
            })
        }

        self.dismiss(animated: true, completion: nil)
    }
}

extension InstallmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.installmentPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "installmentCell", for: indexPath) as! InstallmentsCollectionViewCell
        if let installmentPlan =  itemForIndexPath(indexPath) {
            cell.monthLabel.text = viewModel.monthTitle
            cell.monthsLabel.text = viewModel.monthsTitle
            
            cell.setSelected(isSelected: installmentPlan.selected)
            cell.monthsValue.text = String(installmentPlan.item.tenorMonth)
            
            cell.priceValue.text =  String(format: "%.2f", installmentPlan.item.installmentAmount)
            purchaseFeeValue.text =   String(format: "%.2f", viewModel.installmentSelected?.adminFees ?? 0.0) + " \(viewModel.amount?.currency ?? " EGP")"
            bnplVM.adminFees = viewModel.installmentSelected?.adminFees ?? 0.0.rounded(toPlaces: 2)
            
            if bnplVM.adminFees <= 0 &&  viewModel.downPaymentAmount <= 0{
                cashView.isHidden = true
            }
            
            downPaymentValue.text =  String(format: "%.2f", viewModel.downPaymentAmount) + " \(viewModel.amount?.currency ?? "EGP")"
            totalAmountPaidValue.text =  String(format: "%.2f", viewModel.downPaymentAmount + bnplVM.adminFees) + " \(viewModel.amount?.currency ?? "EGP")"
            cashSelectedLabel.text = String(format: viewModel.cashSelectedTitle, String(format: "%.2f", viewModel.downPaymentAmount + bnplVM.adminFees), viewModel.amount?.currency ?? "EGP")
            cardSelectedLabel.text = String(format: viewModel.cardSelectedTitle, String(format: "%.2f", viewModel.downPaymentAmount + bnplVM.adminFees), viewModel.amount?.currency ?? "EGP")
            switch bnplVM.provider {
            case .Souhoola:
                cashView.isHidden = true
            case .ValU:
                if bnplVM.selectPaymentVM.config?.allowCashOnDeliveryValu ?? false &&  (viewModel.downPaymentAmount > 0 || bnplVM.adminFees > 0) {
                    cashView.isHidden = false
                } else {
                    cashView.isHidden = true
                }
            default: break
            }
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cashSelectedBtn.enabled()
        cardSelectedBtn.enabled()
        self.viewModel.installmentPlans.map{ $0.selected = false }
        if let installmentPlan =  itemForIndexPath(indexPath) {
            installmentPlan.selected = true
            viewModel.installmentSelected = installmentPlan.item
            
            switch bnplVM.provider {
            case .ValU:
                payUpFrontView.isHidden = false
                
                bnplVM.adminFees = viewModel.installmentSelected?.adminFees ?? 0.0
                purchaseFeeValue.text = String(format: "%.2f", bnplVM.adminFees) + " \(viewModel.amount?.currency ?? " EGP")"
                if bnplVM.adminFees > 0 || viewModel.downPaymentAmount > 0 {
                    cashView.isHidden = false
                    selectedPayment = .NONE
                } else {
                    selectedPayment = .PAYMENT_METHODS
                }
            case .Souhoola:
                let minMax = viewModel.getMinMax(limit: bnplVM.souhoolaVerifyResponse?.availableLimit ?? 0, minDownPayment: installmentPlan.item.minDownPayment ?? 0, souhoolaMinimumAmount: bnplVM.selectPaymentVM.config?.souhoolaMinimumAmount ?? 0)
                souhoolaMin = minMax.0
                souhoolaMax = minMax.1
                
                souhoolaRangeLabel.text = getRangeLabel()
                souhoolaRangeLabel.isHidden = false
                souhoolaRangeLabel.textColor = UIColor.form506Color
                
                errorLabel.isHidden = true
                
                if  let safeSouhoolaDP = souhoolaDPTF.text {
                let doubleDow = Double(String(format: "%.2f", Double(safeSouhoolaDP) ?? 0.00)) ?? 0.00
                    bnplVM.downPayment = GDAmount(amount: doubleDow, currency: viewModel.amount?.currency ?? "EGP")
                }
                
                validateSouhoolaDP()
            case .SHAHRY, .NONE: break
            }
            
            
            checkButton()
        }
        
        installmentVC.reloadData()
    }
    
    func getRangeLabel() -> String {
        let minString =  String(format: "%.0f", souhoolaMin) + " \(viewModel.amount?.currency ?? " EGP")"
        let maxString =  String(format: "%.0f", souhoolaMax) + " \(viewModel.amount?.currency ?? " EGP")"
        
        return String(format: viewModel.souhoulaRangeLabel, minString, maxString)
    }
    
    func checkButton() {
        nextBtn.enabled(isEnabled: isButtonValid(), config: bnplVM.selectPaymentVM.config)
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> InstallmantPlanCellViewModel? {
        return viewModel.installmentPlans[indexPath.row]
    }
    
}

extension InstallmentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 0.0, bottom: 1.0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let cellSquareSize: CGFloat = screenWidth / 3.8
        
        return CGSize(width: cellSquareSize , height: 50)
    }
}

extension InstallmentViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        modifyFinancedAmount()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        amountTimer?.invalidate()
        
        amountTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.modifyFinancedAmount),
            userInfo: ["textField": textField],
            repeats: false)
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unfocusFields()
        return true
    }
}
