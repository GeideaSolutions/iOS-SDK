//
//  ProductRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 28.09.2021.
//

import Foundation

enum ProductRouter: BaseRouter {
    
    case getMerchantConfig(params: GDSDKMerchantConfig?)
   
    var method: GDWSHTTPMethod {
        switch self {
        case .getMerchantConfig:
            return .GET
        }
    }
   
    var path: String {
        switch self {
        case .getMerchantConfig:
            return "merchantConfiguration"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getMerchantConfig(let params):
           
            return params?.params?.toDictionary()
        }
    }
     
    var authToken: String? {
        switch self {
        case .getMerchantConfig(let params):
            return params?.token
        }
    }
    
    
    var countryHeader: String? {
        switch self {
        case .getMerchantConfig(let params):
            return params?.countryHeader
        }
    }
    
    func fullpath() -> String {
        return APIHost.PRODUCT.rawValue+BaseVersion.V1.rawValue + path
    }
   
    

}

