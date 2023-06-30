//
//  ShahryPurchaseViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.04.2022.
//

import Foundation


class ShahryPurchaseViewModel: ViewModel {
    
    let orderTokenInvalid = "SHAHRY_INVALID_ORDER_TOKEN".localized
    
    var termsTitle: String {
        return "SHAHRY_CONFIRM_TERMS".localized
    }
    
    var totalAmountTitle: String {
        return  "TOTAL_AMOUNT".localized
    }
    
    var shahryId: String {
        return "SHAHRY_ID".localized
    }
    
    var downPaymentTitle: String {
        return "DOWN_PAYMENT".localized
    }
    
    var orderToken: String {
        return "SHAHRY_ORDER_TOKEN".localized
    }
    
    
    var confirmTitle: String {
        return  "SHAHRY_CONFIRM_BTN".localized
    }
    
    var proceedTitle: String {
        return  "SHAHRY_PROCEED_BTN".localized
    }
    
    var proceedCashTitle: String {
        return  "SHAHRY_PROCEED_CASH_BTN".localized
    }
    
    var doneTitle: String {
        return  "DONE_BUTTON".localized
    }
    
    var openTitle: String {
        return  "SHAHRY_OPEN_TITLE".localized
    }
    
    var shahryAppTitle: String {
        return  "SHAHRY_APP_TITLE".localized
    }
    
    var needHelpTitle: String {
        return  "SHAHRY_NEED_HELP".localized
    }
    
    var toCompleteBodyTitle: String {
        return  "SHAHRY_TO_COMPLETE".localized
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
    
    var merchantNameTitle: String {
        return "QR_MERCHANT_NAME_TITLE".localized
    }
    
    var choosePay: String {
        return "CHOOSE_HOW_PAY".localized
    }
    
    var cashSelectedTitle: String {
        return "CASH_PAYMWENT_OPTION".localized
    }
    
    var cardSelectedTitle: String {
        return "CARD_PAYMWENT_OPTION".localized
    }
    
    var totalAmountCollect: GDAmount?
    var fee: GDAmount?
    var downPayment: GDAmount?
    

    
    func orderTokenValidator(orderToken: String) -> String? {
        if let error = isOrderTokenValid(orderToken: orderToken){
            return error
        }
        return nil
    }
    
    func isOrderTokenValid(orderToken: String) -> String? {


        if orderToken.count > 255  {
            return orderTokenInvalid
        }

        if !orderToken.isAlphanumeric && !orderToken.isEmpty  {
            return orderTokenInvalid
        }

        return nil
    }
    
}
