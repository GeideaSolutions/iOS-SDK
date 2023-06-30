//
//  CancelManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 02/02/2021.
//

import Foundation

class CancelManager {
    typealias CancelCompletionHandler = (GDCancelResponse?, GDErrorResponse?) -> Void
    
    func cancel(with cancelParams: CancelParams, completion: @escaping CancelCompletionHandler) {
        
        let request = Request(router: PaymentRouter.cancel(cancelParams: cancelParams))
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
            
            let payResponse = GDCancelResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
}
