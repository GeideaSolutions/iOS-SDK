//
//  BaseRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

@objc public enum Environment:Int {
    case egy_production
    case eg_preproduction
    
    case uae_production
    case uae_preproduction
    
    
    case ksa_production
    case ksa_preproduction
    
    
    
    var baseUrlString: String {
        switch self {
        case .egy_production:
            return "https://api.merchant.geidea.net/"
        case .eg_preproduction:
            return "https://api.gd-pprod-infra.net"
        case .uae_production:
            return "https://api.merchant.geidea.ae/"
        case .uae_preproduction:
            return "https://api.staging.geidea.ae"
        case .ksa_production:
            return "https://api.ksamerchant.geidea.net/"
        case .ksa_preproduction:
            return "https://api.gd-pprod-infra.net"
        }
    }
    
    public var name: String {
        switch self {
        case .egy_production:
            return "EGY-PROD"
        case .eg_preproduction:
            return "EGY-PREPROD"
        case .uae_production:
            return "UAE-PROD"
        case .uae_preproduction:
            return "UAE-PREPROD"
        case .ksa_production:
            return "KSA PROD"
        case .ksa_preproduction:
            return "KSA-PREPROD"
        }
    }
    
    public static let allCases: [Environment] =
    [
        .eg_preproduction,
        .egy_production,
        .ksa_preproduction,
        .ksa_production,
        .uae_preproduction,
        .uae_production,]
    
    var hccBaseUrlString: String {
        switch self {
        case .egy_production:
            return "https://www.merchant.geidea.net/"
        case .eg_preproduction:
            return "https://www.gd-pprod-infra.net/"
        case .uae_production:
            return "https://payments.geidea.ae/"
        case .uae_preproduction:
            return "https://www.staging.geidea.ae/"
        case .ksa_production:
            return "https://www.ksamerchant.geidea.net/"
        case .ksa_preproduction:
            return "https://www.gd-pprod-infra.net/"
        }
    }
    
}

enum BaseVersion: String {
    case V1 = "api/v1/"
    case V2 = "api/v2/"
    case V3 = "api/v3/"
    case V4 = "api/v4/"
    case V6 = "api/v6/"
}

enum SimpleBaseVersion: String {
    case V1 = "v1/"
    case V2 = "v2/"
    case V3 = "v3/"
}

enum APIHost: String {
    case PGW = "pgw/"
    case EINVOICE = "eInvoice/"
    case PAYMENTINTENT = "payment-intent/"
    case MEEZA = "meeza/"
    case PRODUCT = "product/"
    case VALU_CNP = "valu/cnp/"
    case SHAHRY_CNP = "shahry/cnp/"
    case SHAHRY_CP = "shahry/cp/"
    case SOUHOOLA_CNP = "souhoola/cnp/"
    case BNPL = "bnpl/"
    case RECEIPT = "receipt/"
}



protocol BaseRouter {
    var method: GDWSHTTPMethod { get }
    var path: String { get }
    var authToken: String? { get }
    var countryHeader: String? { get }
    var parameters: [String: Any]? { get }
    func asURLRequest() throws -> URLRequest?
    func fullpath() -> String
}

extension BaseRouter {
    
    public func asURLRequest() throws -> URLRequest? {
        guard let baseUrl = GlobalConfig.shared.environment.baseUrlString.asURL else {
            logWarn("Could not build the URL")
            throw NSError(domain: "MyDomain", code: 0)
        }
        
        guard var urlComponents = URLComponents(string: GlobalConfig.shared.environment.baseUrlString ) else {
            throw NSError(domain: "MyDomain", code: 0)
        }
        
        urlComponents.path =  "/\(fullpath())"
        
        
        var request: URLRequest?
        if  authToken != nil {
            request = WebServices.requestWithTokenHeader(baseUrl, fullpath(), method.rawValue, token: authToken!, countryHeader: countryHeader)
        } else {
            request = WebServices.requestWithDefaultHeader(baseUrl, fullpath(), method.rawValue)
        }
        if let params = self.parameters, !params.isEmpty {
            if method != .GET {
                let body = params.filter { $0.value != nil }.mapValues { $0 }
                request?.httpBody = JSON(from: body).toData()
            } else {
                var queryItems = [URLQueryItem]()
                for (key, value) in params {
                    
                    if value is Array<String> {
                        for item in value as! Array<String> {
                            queryItems.append(URLQueryItem(name: key, value: "\(item)"))
                        }
                    } else {
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                }
                
                urlComponents.queryItems = queryItems
                request?.url? = urlComponents.url!
                
            }
        }
        
        return request ?? nil
    }
    
    func fullpath() -> String {
        return APIHost.PGW.rawValue+BaseVersion.V1.rawValue + path
    }
    
    var authToken: String? {
        get { return nil }
    }
    
    var countryHeader: String? {
        get { return "GEIDEA_SAUDI" }
    }
    
}
