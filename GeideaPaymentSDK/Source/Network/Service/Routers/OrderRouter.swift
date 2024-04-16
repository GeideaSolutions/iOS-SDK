//
//  OrderRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 01/03/2021.
//

import Foundation

enum OrderRouter: BaseRouter {
    
    case order(orderParams: GDOrdersFilter?)
    case orderId(orderId: String)

   
    var method: GDWSHTTPMethod {
        switch self {
        case  .order, .orderId:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .order:
            return "direct/order"
        case .orderId(let orderId):
            return "direct/order/\(orderId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .orderId:
            return nil
        case .order(let orderParams):
            return orderParams?.toJson()
        }
        
    }
}

