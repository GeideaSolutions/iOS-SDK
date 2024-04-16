//
//  PayViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 10.08.2022.
//

import Foundation

class PayViewModel: ViewModel {
 
    var config: GDConfigResponse?
    var showReceipt: Bool
    var redirectHtml: String? = nil
    var gatewayDecision: String? = nil
    var threedSecureId: String? = nil
    var authenticateResponse: AuthenticateResponse?
    var loadHiddenWebViewAction: (()->())!
    var receiptAction: ((Codable?, GDErrorResponse?)->()) = {_,_ in }
    
    init(config: GDConfigResponse?, showReceipt: Bool, screenTitle: String, isNavController: Bool) {
        self.config = config
        self.showReceipt = showReceipt
        super.init(screenTitle: screenTitle, isNavController: isNavController)
    }

}
