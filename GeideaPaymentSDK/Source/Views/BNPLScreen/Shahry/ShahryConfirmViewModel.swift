//
//  ShahryConfirmViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.04.2022.
//

import Foundation
import UIKit


class ShahryConfirmViewModel: ViewModel {
    
    let customerIdInvalid = "CUSTOMER_ID_INVALID".localized
    
    var phoneTitle: String {
        return "PHONE_NUMBER_LABEL".localized
    }
    
    var totalAmountTitle: String {
        return  "TOTAL_AMOUNT".localized
    }
    
    var shahryId: String {
        return "SHAHRY_ID".localized
    }
    
    var whereToFind: String {
        return "SHAHRY_WHERE_TO_FIND".localized
    }
    
    var learnMore: String {
        return "SHAHRY_LEARN_MORE".localized
    }
    
    var doneTitle: String {
        return  "DONE_BUTTON".localized
    }
    
    var nextTitle: String {
        return  "NEXT_BUTTON".localized
    }
    
    var cancelTitle: String {
        return  "CANCEL_BUTTON".localized
    }
    
    var merchantNameTitle: String {
        return "QR_MERCHANT_NAME_TITLE".localized
    }

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
    
    func customerIdValidator(customerId: String) -> String? {
        if let error = isCustomerIdValid(customerId: customerId){
            return error
        }
        return nil
    }
    
    func isCustomerIdValid(customerId: String) -> String? {
        
        
        if customerId.count > 255  {
            return customerIdInvalid
        }
        
        if !customerId.isAlphanumeric && !customerId.isEmpty  {
            return customerIdInvalid
        }
        
        return nil
    }
    
}
