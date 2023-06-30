//
//  CVVViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.07.2022.
//

import Foundation
typealias CVVCompletionHandler = (String?) -> Void
class CVVViewModel: ViewModel {
    
    var config: GDConfigResponse?
    var tokenResponse: GDGetTokenResponse?
    var cvv: String?
    var completion: CVVCompletionHandler
    init(tokenResponse: GDGetTokenResponse, config: GDConfigResponse?, isNavController: Bool, completion: @escaping CVVCompletionHandler) {
        self.tokenResponse = tokenResponse
        self.config = config
        self.completion = completion
        super.init(screenTitle: "", isNavController: isNavController)
    }
    
    
    
    var cvvHintTitle: String {
        return "CVV_HINT".localized
    }
    
    var cvvTitle: String {
        return "CVV_TITLE".localized
    }
    
    var cvvScreenTitle: String {
        return "CVV_SCREEN_TITLE".localized
    }
    
    var cvvEnter: String {
        return "CVV_ENTER".localized
    }
    
    var nextTitle: String {
        return  "NEXT_BUTTON".localized
    }
    
    var expiresTitle: String {
        return "CVV_CARD_EXPIRE".localized
    }
    
    var cardTitle: String {
        return "MASKED_CARD".localized
    }
    
    
    let cvvInvalid = "CVV_INVALID".localized
    let cvvEmpty = "CVV_EMPTY".localized
    
    
    func cvvValidator(cvv: String) -> String?  {
        if let error = isCvvValid(cvv: cvv) {
            return error
        }
        return nil
    }
    
    func isCvvValid(cvv: String) -> String? {
        
            if cvv.isEmpty {
                return cvvEmpty
            }
            
            if cvv.count != 3 {
                return cvvInvalid
            }
        
        
        return nil
    }
    
    func isPayButonValid(cvv: String) -> Bool {
        
        if isCvvValid(cvv: cvv) != nil {
            return false
        }
        
        
        return true
    }
 
}

