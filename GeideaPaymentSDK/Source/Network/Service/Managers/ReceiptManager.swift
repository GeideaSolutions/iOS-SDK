//
//  ReceiptManager.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.03.2022.
//

import Foundation

class ReceiptManager {
    typealias ReceiptHandler = (GDReceiptResponse?, GDErrorResponse?) -> Void
    
    func receipt(with orderId: String, completion: @escaping ReceiptHandler) {
        
        let request = Request(router: ReceiptRouter.receipt(orderId: orderId))
       
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
            
            let payResponse = GDReceiptResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
}
