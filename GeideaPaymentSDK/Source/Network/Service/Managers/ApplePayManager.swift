//
//  ApplePayManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 24/11/2020.
//

import Foundation
import PassKit

class ApplePayManager {
    typealias PayCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
    
    func pay(with payment: PKPayment, callBackUrl: String?, merchantRefId: String?, completion: @escaping PayCompletionHandler) {
        
        let request = Request(router: PaymentRouter.applePay(applePayParams: fromPayParams(from: payment, callbackUrl: callBackUrl, marchentRefId: merchantRefId)))
       
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
            
            let payResponse = GDApplePayResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            GeideaPaymentAPI.getOrder(with: response.orderId, completion: { orderResponse, error in

                completion(orderResponse, error)
            })
            
        }
    }
    
    private func fromPayParams(from payment: PKPayment, callbackUrl: String?, marchentRefId: String? ) -> ApplePayParams {
    
        let payParams = ApplePayParams(payment: payment, merchantReferenceId: marchentRefId, callbackUrl: callbackUrl)
        
        return payParams
    }
}
