//
//  AuthenticateManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation
import CommonCrypto

class AuthenticateManager {
    typealias AuthenticateCompletionHandler = (AuthenticateResponse?, GDErrorResponse?) -> Void
    typealias InitiateAuthenticateCompletionHandler = (GDInitiateAuthenticateResponse?, GDErrorResponse?) -> Void
    typealias SessionCreationCompletionHandler = (SessionResponse?, SessionRequest, GDErrorResponse?) -> Void
    
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
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.SESSION_ERROR))
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
    
    func authenticatePayer(with authenticateParams: AuthenticateParams, sessionId: String?, completion: @escaping AuthenticateCompletionHandler) {
        var params = authenticateParams
        params.update(sessionId: sessionId)
        let request = Request(router: PaymentRouterV6.authenticatePayer(authenticateParams: params))
        
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
    
    static func createSession(with authenticateParams: InitiateAuthenticateParams, completion: @escaping SessionCreationCompletionHandler) {
        let timeStamp = getCurrentTimestamp();
        
        let signature = generateSignature(publicKey: authenticateParams.merchantKey!, orderAmount: authenticateParams.amount, orderCurrency: authenticateParams.currency, merchantRefId: authenticateParams.merchantReferenceId, apiPass: authenticateParams.merchantPass!, timestamp: timeStamp)
        
        let requestModel = SessionRequest(amount: authenticateParams.amount, currency: authenticateParams.currency, timestamp: timeStamp, merchantReferenceID: authenticateParams.merchantReferenceId ?? "", signature: signature);
        
        let request = Request(router: SessionRouterV2.session(sessionParams: requestModel))
        
        request.sendAsync { response, error in
            guard let res = response else {
                if error != nil {
                    completion(nil, requestModel, error)
                }
                return
            }
            guard let data  = res.data else {
                completion( nil, requestModel, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            let sessionResponse = decodeJSONString(data, as: SessionResponse.self)
            guard let response = sessionResponse else {
                completion( nil, requestModel, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, requestModel, nil)
        }
    }
    
    func initiate(with authenticateParams: InitiateAuthenticateParams, completion: @escaping InitiateAuthenticateCompletionHandler) {
        let request = Request(router: PaymentRouterV6.intiate(authenticateParams: authenticateParams))
        
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
extension AuthenticateManager {
    
    static func getCurrentTimestamp() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "M/d/yyyy h:mm:ss a"
        dateFormat.locale = Locale.current
        return dateFormat.string(from: Date())
    }
    
    static func generateSignature(publicKey: String,
                                  orderAmount: Double,
                                  orderCurrency: String,
                                  merchantRefId: String?,
                                  apiPass: String,
                                  timestamp: String) -> String {
        let amountStr = String(format: "%.2f", orderAmount)
        let data = "\(publicKey)\(amountStr)\(orderCurrency)\(merchantRefId ?? "")\(timestamp)"
        let keyData = apiPass.data(using: .utf8)!
        let inputData = data.data(using: .utf8)!
        
        var result = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        keyData.withUnsafeBytes { keyBytes in
            inputData.withUnsafeBytes { dataBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes.baseAddress, keyData.count, dataBytes.baseAddress, inputData.count, &result)
            }
        }
        
        let signatureData = Data(result)
        return signatureData.base64EncodedString()
    }
}
