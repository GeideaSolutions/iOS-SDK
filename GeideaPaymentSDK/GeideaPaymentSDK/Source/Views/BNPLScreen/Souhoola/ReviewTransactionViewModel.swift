//
//  ReviewTransactionViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.05.2022.
//

import Foundation
import UIKit


class ReviewTransactionViewModel: ViewModel {

    var reviewDetails: GDSouhoolaReviewResponse
    var installmentPlan: GDInstallmentPlan?
    
    init(reviewDetails: GDSouhoolaReviewResponse, installmentPlan: GDInstallmentPlan?, currency: String?) {
        self.reviewDetails = reviewDetails
        self.installmentPlan = installmentPlan
        super.init(screenTitle: "", isNavController: false, orderId: nil)
    }
    
    var totalAmountTitle: String {
        return  "TOTAL_AMOUNT".localized
    }
    
    var financedAmountTitle: String {
        return  "FINANCED_AMOUNT".localized
    }
    
    var doneTitle: String {
        return  "DONE_BUTTON".localized
    }
    
    var cancelTitle: String {
        return  "CANCEL_BUTTON".localized
    }
    
    var nextTitle: String{
        return "NEXT_BUTTON".localized
    }
    
    var installmentPlansTitle: String {
        return "INSTALLMENT_INSTALLMENT_PLANS".localized
    }
    
    var payUpFrontTitle: String {
        return "INSTALLMENT_PAY_UPFRONT".localized
    }
    
    var purchaseFeeTitle: String {
        return "INSTALLMENT_PURCHASE_FEES".localized
    }
    
    var totalAmountUpfrontTitle: String {
        return "INSTALLMENT_TOTAL_AMOUNT_UPFRONT".localized
    }
    
    var downPaymentTitle: String {
        return "DOWN_PAYMENT".localized
    }
    
    var toUBalanceTitle: String {
        return "TO_U_BALANCE".localized
    }
    
    var cashbackTitle: String {
        return "CASHBACK_AMOUNT".localized
    }
    
    var monthsTitle: String {
        return "MONTHS".localized
    }
    
    var monthTitle: String {
        return "MONTH".localized
    }
    
    var INSTALLMENT_AMOUNT: String {
        return "INSTALLMENT_AMOUNT".localized
    }
    
    var INSTALLMENT_AMOUNT_VALUE: String {
        return "INSTALLMENT_AMOUNT_VALUE".localized
    }
    
    var merchantNameTitle: String {
        return "QR_MERCHANT_NAME_TITLE".localized
    }
    
    var tenureTitle: String {
        return "TENURE".localized
    }
    
    var cashSelectedTitle: String {
        return "CASH_PAYMWENT_OPTION".localized
    }
    
    var cardSelectedTitle: String {
        return "CARD_PAYMWENT_OPTION".localized
    }
    
    var choosePay: String {
        return "CHOOSE_HOW_PAY".localized
    }
    
    var proceedTitle: String {
        return  "SHAHRY_PROCEED_CASH_BTN".localized
    }
    
    var purchaseDetails: String {
        return "PURCHASE_DETAILS".localized
    }
    
    var totalItemsCart: String {
        return "TOTAL_ITEMS_CART".localized
    }
    
    var installmentDate1: String {
        return "FIRST_INSTALLMENT_DATE".localized
    }
    
}
