//
//  QRpaymentFormViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 15.07.2021.
//

import Foundation
import UIKit

class QRPaymentFormViewModel: ViewModel {
    var callbackUrl: String?
    var merchantName: String?
    var amount: GDAmount
    var customerDetails: GDPICustomer?
    var expiryDate: String?
    var completion: PayCompletionHandler
    var showReceipt: Bool
    var config: GDConfigResponse?
    
    var paymentIntentId: String?
    var qrCodeMessage: String?
    
    var isEmbedded: Bool = false

    var cancelButton: String {
        return "CANCEL_BUTTON".localized
    }
    var mobileWalletTitle: String {
        return "QR_MOBILE_WALLET_TITLE".localized
    }
    var waitingTitle: String {
        return "QR_WAITING_TITLE".localized
    }
    
    var openNotifTitle: String {
        return "QR_OPEN_NOTIF_TITLE".localized
    }
    
    var refreshTitle: String {
        return "QR_REFRESH_TITLE".localized
    }
    
    var noNotifTitle: String {
        return "QR_NO_NOTIF_TITLE".localized
    }
    
    var qrScanTitle: String {
        return "QR_SCAN_TITLE".localized
    }
    
    var scanAndPayTitle: String {
        return "QR_SCAN_PAY_TITLE".localized
    }
    
    var merchantNameTitle: String {
        return "QR_MERCHANT_NAME_TITLE".localized
    }
    
    var requestToPayTitle: String {
        return "QR_REQUEST_PAY_TITLE".localized
    }
    
    var requestToPayDetails: String {
        return "QR_REQUEST_PAY_DESCRIPTION".localized
    }
    
    var requestToPayButton: String {
        return "QR_PAYMENT_BUTTON".localized
    }
    
    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }

    init(amount: GDAmount, customerDetails: GDPICustomer?, config: GDConfigResponse?,expiryDate: String?, showReceipt: Bool, merchantName: String?, orderID: String?, callbackUrl: String?, isEmbedded: Bool = false, isNavController: Bool, completion: @escaping PayCompletionHandler) {
        
        self.amount = amount
        self.customerDetails = customerDetails
        self.expiryDate = expiryDate
        self.completion = completion
        self.showReceipt = showReceipt
        self.merchantName = merchantName
        self.config = config
        self.callbackUrl = callbackUrl
        self.isEmbedded = isEmbedded
        
        super.init(screenTitle: "", isNavController: isNavController, orderId: orderID)
       
    }
    
}

extension QRPaymentFormViewModel {

    func isCustomerDetailsValid(params: GDPICustomer) -> GDErrorResponse? {
        
        if let safeEmail = params.email {
            guard safeEmail.isValidEmail else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E016.rawValue, code: GDErrorCodes.E016.description, detailedResponseMessage: GDErrorCodes.E016.detailedResponseMessage)
            }
        }
        
        return nil
    }
    
    func isAmountValid(authenticateParams: GDAmount) -> GDErrorResponse? {
        guard authenticateParams.amount > 0 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage)
        }
        
        guard authenticateParams.amount.decimalCount() <= 2 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage)
        }
        
        guard !authenticateParams.currency.isEmpty else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E006.rawValue, code: GDErrorCodes.E006.description, detailedResponseMessage: GDErrorCodes.E006.detailedResponseMessage)
        }
        
        guard  authenticateParams.currency.isOnlyLetters, authenticateParams.currency.count == 3  else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E005.rawValue, code: GDErrorCodes.E005.description, detailedResponseMessage: GDErrorCodes.E005.detailedResponseMessage)
        }
        
        return nil
    }
}



