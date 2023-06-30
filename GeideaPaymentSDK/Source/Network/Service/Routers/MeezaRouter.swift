//
//  MeezaRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21.07.2021.
//

import Foundation

enum MeezaRouter: BaseRouter {
  
    case requestToPay(params: RequestToPayParams)
    var method: GDWSHTTPMethod {
        switch self {
        case .requestToPay:
            return .POST
        }
    }
   
    var path: String {
        switch self {
        case .requestToPay:
            return "transaction/requestToPay"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .requestToPay(let params):
            return params.toJson()
        }
    }
    
    func fullpath() -> String {
         return APIHost.MEEZA.rawValue+BaseVersion.V1.rawValue + path
    }

}

