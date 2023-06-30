//
//  RequestToPayViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 20.07.2021.
//

import Foundation

class RequestToPayViewModel: ViewModel {
    
    var qrCodeMessage: String?
    var merchantPhoneNumber: String?
    var config: GDConfigResponse?
    var completion: RTPCompletionHandler

    static let cancelButtonTitle = "CANCEL_BUTTON".localized
    var requestAlertTitle: String {
        return "RQ_REQUEST_ALERT_TITLE".localized
    }
    
    var requestTextPlaceholder: String {
        return "QR_REQUEST_TEXT_PLACEHOLDER".localized
    }
    
    var requestButonTitle: String {
        return "QR_REQUEST_PAYMENT_BUTTON".localized
    }
    
    var cancelButton: String {
        return  "CANCEL_BUTTON".localized
    }
    
    func isPhoneNumberValidated(phoneNumber: String) -> GDErrorResponse? {
        return isPhoneNumberValid(phoneNumber: phoneNumber)
    }
    
    func isPayButonValid(phoneNumber: String) -> Bool {
        if isPhoneNumberValid(phoneNumber: phoneNumber) != nil {
            return false
        }
    
        return true
    }
    
    init(qrCodeMessage: String, config: GDConfigResponse?, orderId: String?, isNavController: Bool, completion: @escaping RTPCompletionHandler ) {
        
        self.qrCodeMessage = qrCodeMessage
        self.completion = completion
        self.config = config
        
        super.init(screenTitle: "", isNavController: isNavController, orderId: orderId)
       
    }
}

extension RequestToPayViewModel {

    func isPhoneNumberValid(phoneNumber: String?) -> GDErrorResponse? {
        
        if phoneNumber?.count == 9 {
            return nil
        } 
        if let safePhoneNumber = phoneNumber {
            guard safePhoneNumber.isValidEgiptPhone else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E022.rawValue, code: GDErrorCodes.E022.description, detailedResponseMessage: GDErrorCodes.E022.detailedResponseMessage)
            }
        } else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E023.rawValue, code: GDErrorCodes.E023.description, detailedResponseMessage: GDErrorCodes.E023.detailedResponseMessage)
        }
     
        return nil
    }
    
}
