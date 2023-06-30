//
//  ReceiptViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.09.2021.
//

import UIKit

struct ReceiptCellViewModel {
    var label = ""
    var value = ""
}


class ReceiptViewController: BaseViewController {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var receiptIcon: UIImageView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerTop: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: DynamicTableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var goToAppBtn: UIButton!
    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var checkMarkIcon: UIImageView!
    
    var viewModel: ReceiptViewModel!
    var cells = Array<ReceiptCellViewModel>()
    var bnpleDetailsCells = Array<ReceiptCellViewModel>()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localizeStrings()
    }
    
    func setBranding() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerImage.addBottomRoundedEdgeIV(desiredCurve: 1.5)
        }
       
        if let headerColor = viewModel.config?.branding?.headerColor {
            headerImage.backgroundColor = UIColor(hex: headerColor)
        }
        
        if let logo = viewModel.config?.branding?.logoPublicUrl {
            logoIV.loadFrom(URLAddress: logo)
        }
        
        if let buttonColor = viewModel.config?.branding?.accentColor {
            goToAppBtn.setTitleColor(UIColor(hex: buttonColor), for: .normal)
            let tintedImage = receiptIcon?.image?.withRenderingMode(.alwaysTemplate)
            receiptIcon.image = tintedImage
            receiptIcon.tintColor = UIColor(hex: buttonColor)
        } else {
            receiptIcon.tintColor = UIColor.buttonBlue
        }
        
        
        
      
    }
    
    
    
    func setupViews() {
        setBranding()
        setupCells()
        
        tableView.register(ReceiptTableViewCell.self)
        tableView.register(UINib(nibName: "SeparatorTableViewCell", bundle: Bundle(identifier: "net.geidea.GeideaPaymentSDK")), forHeaderFooterViewReuseIdentifier: "SeparatorTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        
        if viewModel.receiptFlow == .VALU  {
            tableView.tableFooterView = BNPLFooter()
        }
        
        if viewModel.receiptFlow == .SHAHRY || viewModel.receiptFlow == .SHAHRY {
            let footer  = BNPLFooter()
            footer.callLabel.isHidden = true
            footer.logoImg.image =  UIImage(named: "shahry_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            tableView.tableFooterView = footer
        } else if viewModel.receiptFlow == .SOUHOOLA || viewModel.receiptFlow == .SOUHOOLA {
            let footer  = BNPLFooter()
            footer.callLabel.isHidden = true
            switch GlobalConfig.shared.language {
                case .arabic:
                    footer.logoImg.image = UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
                default:
                    footer.logoImg.image = UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            }
            tableView.tableFooterView = footer
        }
        if viewModel.receiptFlow == .VALU || viewModel.receiptFlow == .SHAHRY || viewModel.receiptFlow == .SOUHOOLA {
            totalView.isHidden = true
        } else {
            totalView.isHidden = false
        }
        
        if viewModel.error != nil {

            receiptIcon.image = UIImage(named: "failureIcon", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            totalView.isHidden = true
            checkMarkIcon.isHidden = true
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { [self] timer in
            self.returnReceipt()
        }
        
    }
    
    func returnReceipt() {
        
        self.dismiss(animated: false, completion: nil)
        if let order = viewModel.order {
            self.viewModel.completion(order, viewModel.error)
        } else if let receipt = viewModel.receipt , let orderId = receipt.orderId {
            GeideaPaymentAPI.getOrder(with: orderId, completion:{ order, error in
                self.viewModel.completion(order, self.viewModel.error)
            })
            
        } else {
            self.viewModel.completion(nil, viewModel.error)
        }
       
    }
    
    func setupCells() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-YYYY HH:mm:ss"
        dateFormatterGet.locale =  Locale(identifier: "en_us")
        let dateTime = dateFormatterGet.string(from: dateFormatterGet.date(from: viewModel.order?.transactions?.last?.updatedDate ?? "") ?? Date())
        let orderId = viewModel.order?.orderId ?? ""
        let merchantRefId = viewModel.order?.merchantReferenceId ?? ""
        
        
        if  let err = viewModel.error {
            totalView.isHidden = true
            var errorReason = ""
            let errorOrderId = viewModel.error?.orderId ?? ""
            if !err.errors.isEmpty {
                errorReason = "\(err.title)"
            } else {
                if err.detailedResponseMessage.isEmpty {
                    errorReason = err.responseMessage
                } else {
                    errorReason = err.detailedResponseMessage
                }
                
            }
            cells.append(ReceiptCellViewModel(label: viewModel.dateTime, value: dateTime))
            if !errorOrderId.isEmpty {
                cells.append(ReceiptCellViewModel(label: viewModel.geideaOrderId, value: err.orderId))
            }
            if !merchantRefId.isEmpty {
                cells.append(ReceiptCellViewModel(label: viewModel.mReferenceId, value: viewModel.order?.merchantReferenceId ?? ""))
            }
            cells.append(ReceiptCellViewModel(label: viewModel.failureReson, value: errorReason))
            
        } else {
            switch viewModel.receiptFlow {
            case .CARD:
                cells.append(ReceiptCellViewModel(label: viewModel.dateTime, value: dateTime))
                cells.append(ReceiptCellViewModel(label: viewModel.operation, value: viewModel.order?.transactions?.last?.type ?? ""))
                cells.append(ReceiptCellViewModel(label: viewModel.geideaOrderId, value: orderId))
                if !merchantRefId.isEmpty {
                    cells.append(ReceiptCellViewModel(label: viewModel.mReferenceId, value: viewModel.order?.merchantReferenceId ?? ""))
                }
            case .QR:
                cells.append(ReceiptCellViewModel(label: viewModel.dateTime, value: dateTime))
                cells.append(ReceiptCellViewModel(label: viewModel.operation, value: viewModel.order?.transactions?.last?.meezaDetails?.type ?? ""))
                cells.append(ReceiptCellViewModel(label: viewModel.mobileNo, value: viewModel.order?.transactions?.last?.meezaDetails?.receiverId ?? ""))
                cells.append(ReceiptCellViewModel(label: viewModel.username, value:  GlobalConfig.shared.language == .arabic ? viewModel.config?.merchantNameAr ?? "":  viewModel.config?.merchantName ?? ""))
                cells.append(ReceiptCellViewModel(label: viewModel.geideaOrderId, value: orderId))
                if !merchantRefId.isEmpty {
                    cells.append(ReceiptCellViewModel(label: viewModel.mReferenceId, value: viewModel.order?.merchantReferenceId ?? ""))
                }
                cells.append(ReceiptCellViewModel(label: viewModel.meezaTransactionID, value: String(viewModel.order?.transactions?.last?.meezaDetails?.meezaTransactionId?.suffix(7) ?? "")))
            case .VALU:
                cells.append(ReceiptCellViewModel(label: viewModel.dateTime, value: dateTime))
                cells.append(ReceiptCellViewModel(label: viewModel.operation, value: viewModel.receipt?.paymentOperation ?? "-"))
                cells.append(ReceiptCellViewModel(label: viewModel.geideaOrderId, value: viewModel.receipt?.orderId ?? "-"))
                
                let total = String(format: "%.2f", viewModel.receipt?.amount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.totalAmount, value:  total))
                
                let financed = String(format: "%.2f", viewModel.receipt?.bnplDetails?.financedAmount ?? 0.0) + " " + (viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.FINANCED_AMOUNT, value: financed ))
                
                let installmentAmount = String(format: "%.2f", viewModel.receipt?.bnplDetails?.installmentAmount ?? 0)
                let installment = String(format: viewModel.INSTALLMENT_AMOUNT_VALUE, installmentAmount, viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.INSTALLMENT_AMOUNT, value: installment))

                let tenure = String(viewModel.receipt?.bnplDetails?.tenure ?? 0) + " " + viewModel.MONTHS
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.TENURE, value:tenure))
                
                var downP = ""
                if viewModel.receipt?.bnplDetails?.downPayment ?? 0 > 0{
                    downP = String(format: "%.2f", viewModel.receipt?.bnplDetails?.downPayment ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    downP = "-"
                }
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.DOWN_PAYMENT, value: downP))
                
                var toU = ""
                if viewModel.receipt?.bnplDetails?.giftCardAmount ?? 0 > 0{
                    toU = String(format: "%.2f", viewModel.receipt?.bnplDetails?.giftCardAmount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    toU = "-"
                }
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.TO_U_BALANCE, value: toU))
                
                var cashback = ""
                if viewModel.receipt?.bnplDetails?.campaignAmount ?? 0 > 0{
                    cashback = String(format: "%.2f", viewModel.receipt?.bnplDetails?.campaignAmount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    cashback = "-"
                }
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.CASHBACK_AMOUNT, value: cashback))
                
                var fee = ""
                if viewModel.receipt?.bnplDetails?.adminFees ?? 0 > 0{
                    fee = String(format: "%.2f", viewModel.receipt?.bnplDetails?.adminFees ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    fee = "-"
                }
                
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.PURCHASE_FEES, value: fee))
                if !merchantRefId.isEmpty {
                    bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.mReferenceId, value: viewModel.receipt?.merchant?.referenceId ?? ""))
                }
            case .SHAHRY:
                
                let bnplDetails = viewModel.receipt?.bnplDetails
                
                cells.append(ReceiptCellViewModel(label: viewModel.dateTime, value: dateTime))
                cells.append(ReceiptCellViewModel(label: viewModel.operation, value: viewModel.receipt?.paymentOperation ?? "-"))
                cells.append(ReceiptCellViewModel(label: viewModel.geideaOrderId, value: viewModel.receipt?.orderId ?? "-"))
        
                let total = String(format: "%.2f", viewModel.receipt?.amount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.totalAmount, value:  total))
                
             
                let financed = String(format: "%.2f", bnplDetails?.financedAmount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.FINANCED_AMOUNT, value: financed ))
                
                let installmentAmount = String(format: "%.2f", bnplDetails?.installmentAmount ?? 0)
                let installment = String(format: viewModel.INSTALLMENT_AMOUNT_VALUE, installmentAmount, viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.INSTALLMENT_AMOUNT, value: installment))

                let tenure = String(bnplDetails?.tenure ?? 0) + " " + viewModel.MONTHS
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.TENURE, value:tenure))
                
                var downP = ""
                if bnplDetails?.downPayment ?? 0 > 0{
                    downP = String(format: "%.2f", bnplDetails?.downPayment ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    downP = "-"
                }
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.DOWN_PAYMENT, value: downP))
            
                var fee = ""
                if bnplDetails?.adminFees ?? 0 > 0{
                    let totalFee = bnplDetails?.adminFees ?? 0
                    fee = String(format: "%.2f",totalFee) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    fee = "-"
                }
                
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.PURCHASE_FEES, value: fee))
             
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.SHAHRY_REFERENCE_ID, value: bnplDetails?.providerTransactionId ?? "-"))
            
            case .SOUHOOLA:
                
                let bnplDetails = viewModel.receipt?.bnplDetails
                
                cells.append(ReceiptCellViewModel(label: viewModel.dateTime, value: dateTime))
                cells.append(ReceiptCellViewModel(label: viewModel.operation, value: viewModel.receipt?.paymentOperation ?? "-"))
                cells.append(ReceiptCellViewModel(label: viewModel.geideaOrderId, value: viewModel.receipt?.orderId ?? "-"))
        
                let total = String(format: "%.2f", viewModel.receipt?.amount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.totalAmount, value:  total))
                
             
                let financed = String(format: "%.2f", bnplDetails?.financedAmount ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.FINANCED_AMOUNT, value: financed ))
                
                let installmentAmount = String(format: "%.2f", bnplDetails?.installmentAmount ?? 0)
                let installment = String(format: viewModel.INSTALLMENT_AMOUNT_VALUE, installmentAmount, viewModel.receipt?.currency ?? "SAR")
                cells.append(ReceiptCellViewModel(label: viewModel.INSTALLMENT_AMOUNT, value: installment))

                let tenure = String(bnplDetails?.tenure ?? 0) + " " + viewModel.MONTHS
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.TENURE, value:tenure))
                
                var downP = ""
                if bnplDetails?.downPayment ?? 0 > 0{
                    downP = String(format: "%.2f", bnplDetails?.downPayment ?? 0) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    downP = "-"
                }
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.DOWN_PAYMENT, value: downP))
            
                var fee = ""
                if bnplDetails?.adminFees ?? 0 > 0{
                    let totalFee = bnplDetails?.adminFees ?? 0
                    fee = String(format: "%.2f",totalFee) + " " + (viewModel.receipt?.currency ?? "SAR")
                } else {
                    fee = "-"
                }
                
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.PURCHASE_FEES, value: fee))
             
                bnpleDetailsCells.append(ReceiptCellViewModel(label: viewModel.SOUHOOLA_ORDER_ID, value: bnplDetails?.providerTransactionId ?? "-"))
               
            }
        }
        
        tableView.invalidateIntrinsicContentSize()
        var tvHeight = cells.count * 45
        if viewModel.receiptFlow == .VALU  ||  viewModel.receiptFlow == .SHAHRY || viewModel.receiptFlow == .SOUHOOLA {
           
            tvHeight += 130
        }
        
//        tableView.
        
//        tableViewHeight.constant = CGFloat(tvHeight)
//        if viewModel.error != nil {
//            contentViewHeight.constant = tableViewHeight.constant + 350
//        } else {
//            if viewModel.receiptFlow == .VALU || viewModel.receiptFlow == .SHAHRY || viewModel.receiptFlow == .SOUHOOLA {
//                contentViewHeight.constant = tableViewHeight.constant + 350
//            } else {
//                contentViewHeight.constant = tableViewHeight.constant + 300
//            }
//
//        }
        
//        contentViewHeight.constant = tableViewHeight.constant + 350
        
        
        if let amount = viewModel.order?.totalCapturedAmount {
            amountLabel.text =  String(amount).formattedAmountString(forAmount: amount)
        }
        
        currencyLabel.text = viewModel.order?.currency
    }
    
    init() {
        super.init(nibName: "ReceiptViewController", bundle: Bundle(for:  ReceiptViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Call the roundCorners() func right there.
        self.contentView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft], radius: 30)
        updateHeaderViewHeight(for: tableView.tableFooterView)
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
    }
    
    override func localizeStrings() {
        goToAppBtn.setTitle(viewModel.goToAppTitle, for: .normal)
        var successTitle = ""
        switch viewModel.receiptFlow {
        case.VALU:
            successTitle = viewModel.valUTitleAppoved
        case.SHAHRY:
            successTitle = viewModel.shahryTitleAppoved
        case.SOUHOOLA:
            successTitle = viewModel.souhoolaTitleAppoved
        default:
            successTitle = viewModel.titleAppoved
        }
       
        titleLabel.text = (viewModel.order != nil || viewModel.receipt != nil) ? successTitle : viewModel.titleFailed
        totalLabel.text = viewModel.total
        subtitleLabel.text = viewModel.subTitle

    }

    @IBAction func goToAppTapped(_ sender: Any) {
        self.timer?.invalidate()
        
        returnReceipt()
    }
    
}

extension ReceiptViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return bnpleDetailsCells.count
        } else {
          return cells.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.receiptFlow == .VALU || viewModel.receiptFlow == .SHAHRY || viewModel.receiptFlow == .SOUHOOLA{
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReceiptTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let receiptViewCell =  itemForIndexPath(indexPath)
        cell.label.text = receiptViewCell.label
        cell.value.text = receiptViewCell.value
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func itemForIndexPath(_ indexPath: IndexPath) -> ReceiptCellViewModel {
        if indexPath.section == 0 {
            return  cells[indexPath.row]
        } else {
            return  bnpleDetailsCells[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SeparatorTableViewCell")
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 0
        
    }
    
}

