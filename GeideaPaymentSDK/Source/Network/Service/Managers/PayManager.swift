//
//  PayManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 19/10/2020.
//

import Foundation

class PayManager {
    typealias PayCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
    
    func pay(with authParams: AuthenticateParams, threeDSecureId: String?, orderId:String?, completion: @escaping PayCompletionHandler) {
        
        let request = Request(router: PaymentRouter.pay(payParams: fromPayParams(from: authParams, threeDSecure: threeDSecureId, orderId: orderId)))
       
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
    
    
    private func fromPayParams(from authenticateParams: AuthenticateParams, threeDSecure threeDSecureID:String?, orderId: String?) -> PayParams {
        var payParams = PayParams()
        payParams.orderId = orderId ?? ""
        payParams.threeDSecureId = threeDSecureID ?? ""
        payParams.paymentMethod = authenticateParams.paymentMethod
        payParams.currency = authenticateParams.currency
        payParams.amount = authenticateParams.amount
        payParams.sessionId = authenticateParams.sessionId
        return payParams
    }
}
