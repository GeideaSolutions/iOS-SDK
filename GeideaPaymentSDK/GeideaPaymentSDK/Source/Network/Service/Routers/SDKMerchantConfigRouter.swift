//
//  SDKMerchantConfigRouter.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.10.2021.
//

import Foundation

public enum SDKMerchantConfigRouter: BaseRouter {
    
    case getMerchantConfig(params: GDProductMConfig)
    
    var method: GDWSHTTPMethod {
        switch self {
        case  .getMerchantConfig:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getMerchantConfig(let merchantKey):
            return " merchantConfiguration/\(merchantKey)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getMerchantConfig(let params):
            return params.toJson()

        }
        
    }
}

