//
//  PhoneNumberViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 15.02.2022.
//


import Foundation
import UIKit

class PhoneNumberViewModel: ViewModel {
    
    let customerIdInvalid = "CUSTOMER_ID_INVALID".localized
    let pinIdInvalid = "PIN_INVALID".localized
    
    var valUScreenTitle: String {
        return "INSTALLMENT_STEP_PHONE_TITLE".localized
    }
    
    var souhoolaScreenTitle: String {
        return "INSTALLMENT_STEP_CONFIRM_SOUHOOLA_TITLE".localized
    }
    
    var phoneTitle: String {
        return "PHONE_NUMBER_LABEL".localized
    }
    
    var registerTitle: String {
        return "REGISTER_HERE_TITLE".localized
    }
    
    var accountTitle: String {
        return "ACCOUNT_TITLE".localized
    }
    
    var pinTitle: String {
        return "SOUHOOLA_PIN_TITLE".localized
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

    var souhoolaAvailableLimitError : String {
        return  "SOUHOOLA_AVAILABLE_LIMIT_ERROR".localized
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
    
    func pinValidator(pin: String) -> String? {
        if let error = isPinValid(pin: pin){
            return error
        }
        return nil
    }
    
    func isPinValid(pin: String) -> String? {
        
        
        
        if pin.count > 10  {
            return pinIdInvalid
        }
        
        if !pin.isNumber && !pin.isEmpty  {
            return pinIdInvalid
        }
        
        return nil
    }
    
}
