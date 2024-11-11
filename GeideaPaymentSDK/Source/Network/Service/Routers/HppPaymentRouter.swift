//
//  HppPaymentRouter.swift
//  GeideaPaymentSDK
//
//  Created by Virender on 13/06/24.
//

import Foundation

enum HppPaymentRouter: BaseRouter {
    
    case session(sessionId: String)
    
    var method: GDWSHTTPMethod {
        return .POST;
    }
    
    var parameters: [String: Any]? {
        return [:];
    }
    
    var path: String {
        switch self {
        case let .session(id):
            return "hpp/checkout/?\(id)"
        }
    }
    
    func fullpath() -> String {
        return GlobalConfig.shared.environment.hccBaseUrlString + path
    }
}
