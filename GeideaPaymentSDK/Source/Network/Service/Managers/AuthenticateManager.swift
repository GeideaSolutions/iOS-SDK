//
//  AuthenticateManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation

class AuthenticateManager {
    typealias AuthenticateCompletionHandler = (AuthenticateResponse?, GDErrorResponse?) -> Void
    typealias InitiateAuthenticateCompletionHandler = (GDInitiateAuthenticateResponse?, GDErrorResponse?) -> Void
    
    func authenticate(with authenticateParams: AuthenticateParams, completion: @escaping AuthenticateCompletionHandler) {
        let request = Request(router: PaymentRouter.authenticate(authenticateParams: authenticateParams))
        
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
            
            let authResponse = AuthenticateResponse().parse(json: data)
            guard let response = authResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, nil)
        }
    }
    
    func authenticatePayer(with authenticateParams: AuthenticateParams, completion: @escaping AuthenticateCompletionHandler) {
        let request = Request(router: PaymentRouterV4.authenticatePayer(authenticateParams: authenticateParams))
        
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
            let authResponse = AuthenticateResponse().parse(json: data)
            guard let response = authResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, nil)
        }
    }
    
    func initiate(with authenticateParams: InitiateAuthenticateParams, completion: @escaping InitiateAuthenticateCompletionHandler) {
        let request = Request(router: PaymentRouterV4.intiate(authenticateParams: authenticateParams))
        
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

            let authResponse = GDInitiateAuthenticateResponse().parse(json: data)

            guard let response = authResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, nil)
        }
    }
}
