//
//  WebViewViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 09/10/2020.
//

import Foundation

class WebViewViewModel {
    
    var authenticateParams: AuthenticateParams? = nil
    let authenticateResponse: AuthenticateResponse
    var payTokenParams: PayTokenParams? = nil
    
    init(authenticateParams: AuthenticateParams, authenticateResponse: AuthenticateResponse) {
        self.authenticateParams = authenticateParams
        self.authenticateResponse = authenticateResponse
    }
    
    init(payTokenParams: PayTokenParams, autheticateResponse: AuthenticateResponse) {
        self.payTokenParams = payTokenParams
        self.authenticateResponse = autheticateResponse
    }
}
