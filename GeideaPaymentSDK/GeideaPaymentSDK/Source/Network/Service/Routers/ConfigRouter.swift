//
//  ConfigRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

public enum ConfigRouter: BaseRouter {
    case getMerchantConfig(merchantKey: String)
    
    var method: GDWSHTTPMethod {
        switch self {
        case  .getMerchantConfig:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getMerchantConfig(let merchantKey):
            return "config/\(merchantKey)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getMerchantConfig:
            return nil
            
        }
        
    }
}

