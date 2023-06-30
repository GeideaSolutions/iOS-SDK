//
//  ReceiptViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.09.2021.
//

import Foundation
import UIKit

enum ReceiptFlow {
    case QR
    case CARD
    case VALU
    case SHAHRY
    case SOUHOOLA

}

class ReceiptViewModel: ViewModel {
    var config: GDConfigResponse?
    var order: GDOrderResponse?
    var error: GDErrorResponse?
    var receipt: GDReceipt?
    var completion: PayCompletionHandler
    var receiptFlow: ReceiptFlow
    
    var isEmbedded = false

    var valUTitleAppoved: String {
        return "VALU_TITLE".localized
    }
    
    var shahryTitleAppoved: String {
        return "SHAHRY_TITLE".localized
    }
    
    var souhoolaTitleAppoved: String {
        return "SOUHOOLA_TITLE".localized
    }
    
    var titleAppoved: String {
        return "RECEIPT_APPROVED".localized
    }
    var titleFailed: String {
        return "RECEIPT_FAILED".localized
    }
    var total: String {
        return "RECEIPT_TOTAL".localized
    }
    var subTitle: String {
        return "RECEIPT_REDIRECT".localized
    }
    var failureReson: String {
        return "RECEIPT_FAILURE_REASON".localized
    }
    static let cancelButtonTitle = "CANCEL_BUTTON".localized
    var dateTime: String {
        return "RECEIPT_DATE".localized
    }
    
    var operation: String {
        return "RECEIPT_OPERATION".localized
    }
    
    var geideaOrderId: String {
        return "RECEIPT_ORDER_ID".localized
    }
    
    var mReferenceId: String {
        return "RECEIPT_MREF_ID".localized
    }
    
    var mobileNo: String {
        return "RECEIPT_MOBILE".localized
    }
    
    var username: String {
        return "RECEIPT_USERNAME".localized
    }
    
    var meezaTransactionID: String {
        return "RECEIPT_MEEZA_ID".localized
    }
    
    var totalAmount: String {
        return "TOTAL_AMOUNT".localized
    }
    var TENURE: String {
        return "TENURE".localized
    }
    var FINANCED_AMOUNT: String {
        return "FINANCED_AMOUNT".localized
    }
    var INSTALLMENT_AMOUNT: String {
        return "INSTALLMENT_AMOUNT".localized
    }
    var DOWN_PAYMENT: String {
        return "DOWN_PAYMENT".localized
    }
    var TO_U_BALANCE: String {
        return "TO_U_BALANCE".localized
    }
    var CASHBACK_AMOUNT: String {
        return "CASHBACK_AMOUNT".localized
    }
    var PURCHASE_FEES: String {
        return "INSTALLMENT_PURCHASE_FEES".localized
    }
    
    var MONTHS: String {
        return "MONTHS".localized
    }
    
    var INSTALLMENT_AMOUNT_VALUE: String {
        return "INSTALLMENT_AMOUNT_VALUE".localized
    }
    var REFERENCE_NUMBER: String {
        return "REFERENCE_NUMBER".localized
    }
    
    var SHAHRY_REFERENCE_ID: String {
        return "SHAHRY_REFERENCE_ID".localized
    }
    
    var SOUHOOLA_ORDER_ID: String {
        return "SOUHOOLA_ORDER_ID".localized
    }
    
    var PURCHASEFEETITLE: String {
        return "INSTALLMENT_PURCHASE_FEES".localized
    }
    
    
    var goToAppTitle: String {
        return "RECEIPT_BACK_TO".localized
    }
    
    var cancelButton: String {
        return  "CANCEL_BUTTON".localized
    }
    
    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
    
    init(order: GDOrderResponse?, error: GDErrorResponse?, receipt: GDReceipt? = nil, receiptFlow: ReceiptFlow, config: GDConfigResponse?, isEmbedded: Bool = false, isNavController: Bool, completion: @escaping PayCompletionHandler ) {
        
        self.order = order
        self.error = error
        self.receipt = receipt
        self.receiptFlow = receiptFlow
        self.config = config
        self.completion = completion
        
        super.init(screenTitle: "", isNavController: isNavController)
       
    }
}
