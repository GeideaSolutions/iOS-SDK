//
//  PayTokenManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 11/12/2020.
//

import Foundation

class PayTokenManager {
    typealias PayCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
    typealias IntiateTokenCompletionHandler = (GDInitiateAuthenticateResponse?, GDErrorResponse?) -> Void
    typealias AuthenticateCompletionHandler = (AuthenticateResponse?, GDErrorResponse?) -> Void
    typealias TokenCompletionHandler = (GDGetTokenResponse?, GDErrorResponse?) -> Void
    
    func pay(with payTokenParams: PayTokenParams, completion: @escaping PayCompletionHandler) {
        
        let request = Request(router: PaymentRouter.payToken(tokenParams: payTokenParams))
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
           
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = PayResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response.order, error)
        }
    }
    
    func initiateToken(with payTokenParams: InitiateAuthenticateTokenParams, completion: @escaping IntiateTokenCompletionHandler) {
        
        let request = Request(router: PaymentRouterV3.initiateToken(initiateParams: payTokenParams))
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
           
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDInitiateAuthenticateResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func authenticateToken(with payTokenParams: AuthenticateTokenPayerParams, completion: @escaping AuthenticateCompletionHandler) {
        
        let request = Request(router: PaymentRouterV3.authenticateToken(authenticateParams: payTokenParams))
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
           
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = AuthenticateResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func getToken(with tokenId: String, completion: @escaping TokenCompletionHandler) {
        let request = Request(router: PaymentRouter.getToken(tokenId: tokenId))
        
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }

            let authResponse = GDGetTokenResponse().parse(json: data)

            guard let response = authResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, nil)
        }
    }
}
