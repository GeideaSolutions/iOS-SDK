//
//  ReviewTransactionViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.05.2022.
//

import UIKit

class ReviewTransactionViewController: BaseViewController {

    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalAmountValue: UILabel!
    @IBOutlet weak var totalAmountCurrency: UILabel!
    
    @IBOutlet weak var financedAmountLabel: UILabel!
    @IBOutlet weak var financedAmountValue: UILabel!
    
    @IBOutlet weak var tenureLable: UILabel!
    @IBOutlet weak var tenureValue: UILabel!
    @IBOutlet weak var tenureMonthsLabel: UILabel!
    
    @IBOutlet weak var installmentAmountLabel: UILabel!
    @IBOutlet weak var installmentAmountValue: UILabel!
    
    @IBOutlet weak var installmentDateLabel: UILabel!
    @IBOutlet weak var installmentDateValue: UILabel!
    
    @IBOutlet weak var payUpFrontLabel: UILabel!
    
    @IBOutlet weak var purchaseFeeLabel: UILabel!
    @IBOutlet weak var purchaseFeeValue: UILabel!
    
    @IBOutlet weak var downPaymentLabel: UILabel!
    @IBOutlet weak var downPaymentValue: UILabel!
    
    @IBOutlet weak var totalAmountToBePaidLabel: UILabel!
    @IBOutlet weak var totalAmountToBePaidValue: UILabel!
    
    @IBOutlet weak var installmentPlansTitle: UILabel!
 
    @IBOutlet weak var purchaseDetailsTitle: UILabel!
    @IBOutlet weak var merchantNameTitle: UILabel!
    @IBOutlet weak var merchantNameValue: UILabel!
    @IBOutlet weak var totalItemCartLabel: UILabel!
    @IBOutlet weak var totalItemValue: UILabel!
    
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cashTitle: UILabel!
    
    @IBOutlet weak var cardSelectedLabel: UILabel!
    @IBOutlet weak var cardSelectedView: RadialCircleView!
    
    @IBOutlet weak var cashSelectedView: RadialCircleView!
    
    @IBOutlet weak var cashSelectedLabel: UILabel!
    
    @IBOutlet weak var proceedBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    var bnplVM: BNPLViewModel!
    var viewModel: ReviewTransactionViewModel!
    
    var selectedPayment = PaymentSelectionFlow.NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bnpl = self.parent as? BNPLViewController {
            bnplVM = bnpl.viewModel
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }
    
    override func localizeStrings() {
        totalAmountLabel.text = viewModel.totalAmountTitle
        financedAmountLabel.text = viewModel.financedAmountTitle
        installmentAmountLabel.text = viewModel.INSTALLMENT_AMOUNT
        payUpFrontLabel.text = viewModel.payUpFrontTitle
        downPaymentLabel.text = viewModel.downPaymentTitle
        totalAmountToBePaidLabel.text = viewModel.totalAmountUpfrontTitle
        merchantNameTitle.text = viewModel.merchantNameTitle
        purchaseFeeLabel.text = viewModel.purchaseFeeTitle
        purchaseDetailsTitle.text = viewModel.purchaseDetails
        installmentPlansTitle.text = viewModel.installmentPlansTitle
        payUpFrontLabel.text = viewModel.payUpFrontTitle
        downPaymentLabel.text = viewModel.downPaymentTitle
        totalAmountToBePaidLabel.text = viewModel.totalAmountUpfrontTitle
        totalItemCartLabel.text = viewModel.totalItemsCart
        installmentDateLabel.text = viewModel.installmentDate1
        
        tenureLable.text = viewModel.tenureTitle
        installmentPlansTitle.text = viewModel.installmentPlansTitle
        if viewModel.reviewDetails.totalInvoicePrice == 0 {
            proceedBtn.setTitle(viewModel.proceedTitle, for: .normal)
        } else {
            proceedBtn.setTitle(viewModel.proceedTitle, for: .normal)
        }
      
        cancelBtn.setTitle(viewModel.cancelTitle, for: .normal)
        
    }

    func setupViews() {
        localizeStrings()
        setBranding()
       
        
        totalAmountValue.text = String(format: "%.2f", viewModel.reviewDetails.totalInvoicePrice ?? 0) + " " + (bnplVM.selectPaymentVM.amount.currency)
        
        financedAmountValue.text = String(format: "%.2f", viewModel.reviewDetails.loanAmount ?? 0) + " " + (bnplVM.selectPaymentVM.amount.currency )
    
        let installmentAmount = String(format: "%.2f", viewModel.reviewDetails.installments?.first?.kstAmt ?? 0)
        installmentAmountValue.text =  String(format: viewModel.INSTALLMENT_AMOUNT_VALUE, installmentAmount, bnplVM.selectPaymentVM.amount.currency)
        
        tenureValue.text = String(viewModel.reviewDetails.installments?.count ?? 0)
        
        let firstDate = viewModel.reviewDetails.installments?.first?.kstDate ?? ""
       
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:firstDate) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let dateString = formatter.string(from: date)
        
        installmentDateValue.text = dateString
        
        let purchaseFee = viewModel.reviewDetails.mainAdministrativeFees ?? 0
        purchaseFeeValue.text = String(format: "%.2f", purchaseFee) + " " + (bnplVM.selectPaymentVM.amount.currency)
        
        let downPayment = viewModel.reviewDetails.downPayment ?? 0
        downPaymentValue.text = String(format: "%.2f", downPayment) + " " + (bnplVM.selectPaymentVM.amount.currency )
        
        totalAmountToBePaidValue.text =  String(format: "%.2f", downPayment + purchaseFee) + " \(bnplVM.selectPaymentVM.amount.currency)"
        
        if let bnpl = self.parent as? BNPLViewController {
            
            let allowCashOnDelivery = (bnpl.viewModel.selectPaymentVM.config?.allowCashOnDeliverySouhoola ?? false)
            let amountToPay = (downPayment + purchaseFee)
            cashView.isHidden =  !allowCashOnDelivery || amountToPay == 0
            if cashView.isHidden {
                proceedBtn.enabled(isEnabled: true, config: bnplVM.selectPaymentVM.config)
            } else {
                proceedBtn.enabled(isEnabled: false, config: bnplVM.selectPaymentVM.config)
            }
            
            cashTitle.text = viewModel.choosePay
            cardSelectedLabel.text =  String(format: viewModel.cardSelectedTitle, String(format: "%.2f", downPayment + purchaseFee), bnplVM.selectPaymentVM.amount.currency)
            cashSelectedLabel.text = String(format: viewModel.cashSelectedTitle,String(format: "%.2f", downPayment + purchaseFee), bnplVM.selectPaymentVM.amount.currency)
                
            
            let cardBtnTapped = UITapGestureRecognizer(target: self, action: #selector(self.cardBtnTappped(_:)))
            cardSelectedView.addGestureRecognizer(cardBtnTapped)
            
            let cashBtnTapped = UITapGestureRecognizer(target: self, action: #selector(self.cashBtnTappped(_:)))
            cashSelectedView.addGestureRecognizer(cashBtnTapped)
        }
        
        merchantNameValue.text = viewModel.reviewDetails.merchantName
        totalItemValue.text = String(format: "%.0f", viewModel.reviewDetails.cartCount ?? 0)
       
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: bnplVM.selectPaymentVM.config)
        proceedBtn.enabled(isEnabled: true, config: bnplVM.selectPaymentVM.config)
        cardSelectedView.enabled()
        cashSelectedView.enabled()

    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        
        if let bnpl = self.parent as? BNPLViewController {
            bnpl.errorSnackView.isHidden = true
            proceedBtn.showLoading()
            let bnplDetails = GDSouhoolaBNPLDetails(souhoolaTransactionId: viewModel.reviewDetails.souhoolaTransactionId, totalInvoicePrice: viewModel.reviewDetails.totalInvoicePrice ?? 0, downPayment: viewModel.reviewDetails.downPayment ?? 0, loanAmount: viewModel.reviewDetails.loanAmount ?? 0, netAdminFees: viewModel.reviewDetails.netAdministrativeFees ?? 0, mainAdminFees:  viewModel.reviewDetails.mainAdministrativeFees ?? 0,  tenure: viewModel.reviewDetails.installments?.count ?? 0, annualRate: viewModel.reviewDetails.annualRate , firstInstallmentDate: viewModel.reviewDetails.firstInstallmentDate, lastInstallmentDate: viewModel.reviewDetails.lastInstallmentDate, installmentAmount: viewModel.reviewDetails.installmentAmount)
            let details = GDSouhoolaInstallmentPlanSelected(customerIdentifier: bnplVM.customerId, customerPIN: bnplVM.pin, totalAmount: viewModel.reviewDetails.totalInvoicePrice ?? 0, currency: bnplVM.selectPaymentVM.amount.currency, merchantReferenceId: bnplVM.selectPaymentVM.customerDetails?.merchantReferenceId, callbackUrl: bnplVM.selectPaymentVM.customerDetails?.callbackUrl, billingAddress: bnplVM.selectPaymentVM.customerDetails?.billingAddress, shippingAddress: bnplVM.selectPaymentVM.customerDetails?.shippingAddress, customerEmail: bnplVM.selectPaymentVM.customerDetails?.customerEmail, restrictPaymentMethods: bnplVM.selectPaymentVM.paymentMethods != nil, paymentMethods: bnplVM.selectPaymentVM.paymentMethods, items: bnplVM.selectPaymentVM.bnplItems, bnplDetails: bnplDetails, cashOnDelivery: selectedPayment == .CASH, orderId: bnplVM.selectPaymentVM.orderId)
            bnpl.souhoolaReviewNextTapped(with: details)
        }
    }

    @objc func cardBtnTappped(_ sender: UITapGestureRecognizer? = nil) {
        
        cardSelectedView.enabled(enabled: true, config: bnplVM.selectPaymentVM.config)
        cashSelectedView.enabled()
        selectedPayment = .PAYMENT_METHODS
        
        proceedBtn.setTitle(viewModel.proceedTitle, for: .normal)
      
        proceedBtn.enabled(isEnabled: true, config: bnplVM.selectPaymentVM.config)
    }
    
    @objc func cashBtnTappped(_ sender: UITapGestureRecognizer? = nil) {
        cashSelectedView.enabled(enabled: true, config: bnplVM.selectPaymentVM.config)
        cardSelectedView.enabled()
        selectedPayment = .CASH
        
        proceedBtn.setTitle(viewModel.proceedTitle, for: .normal)
        proceedBtn.enabled(isEnabled: true, config: bnplVM.selectPaymentVM.config)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let cancelDetails  = GDSouhoolaCancelDetails(customerIdentifier: bnplVM.customerId, customerPin: bnplVM.pin, souhoolaTransactionId: viewModel.reviewDetails.souhoolaTransactionId)
        bnplVM.souhoolaCancel(with: cancelDetails, completion:{ response, error in
            
            if let err = error {
                print(err.detailedResponseMessage)
            } else {
                self.dismiss(animated: true)
            }
        })
        
    }
    
    init() {
        super.init(nibName: "ReviewTransactionViewController", bundle: Bundle(for: ReviewTransactionViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "ReviewTransactionViewController", bundle: Bundle(for: ReviewTransactionViewController.self))
    }

}
