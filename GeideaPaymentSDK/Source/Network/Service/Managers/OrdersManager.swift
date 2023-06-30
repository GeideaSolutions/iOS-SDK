//
//  OrderaManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 01/03/2021.
//

import Foundation

class OrdersManager {
    
    typealias OrdersCompletionHandler = (GDOrdersResponse?, GDErrorResponse?) -> Void
    typealias OrderCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
    
    func orders(with orderParams: GDOrdersFilter?, completion: @escaping OrdersCompletionHandler) {
        
        let request = Request(router: OrderRouter.order(orderParams: orderParams ))
        request.sendAsync { response, error in
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            
            guard let data = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let ordersResponse = GDOrdersResponse().parse(json: data)
            guard let response = ordersResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func orderById(with orderId: String, completion: @escaping OrderCompletionHandler) {
        
        let request = Request(router: OrderRouter.orderId(orderId: orderId))
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
}
