//
//  ReceiptRouter.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 14.03.2022.
//

import Foundation

enum ReceiptRouter: BaseRouter {
    
    case receipt(orderId: String)
    
    var method: GDWSHTTPMethod {
        switch self {
        case  .receipt:
            return .GET
        }
    }
    
    var path: String {
        switch self {

        case .receipt(let orderId):
            return "receipt/\(orderId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .receipt :
            return nil
        }
        
    }
    func fullpath() -> String {
        return APIHost.RECEIPT.rawValue+"api/direct/"+SimpleBaseVersion.V1.rawValue + path
    }
}
