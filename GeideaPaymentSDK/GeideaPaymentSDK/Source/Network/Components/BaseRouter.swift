//
//  BaseRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

@objc public enum Environment:Int {
    case dev // to be used in debug mode, as the server should be stable in this environment
    case test // to be used if testing in UAT is required
    case preprod // used when required
    case prod // used for production
    
    
    var baseUrlString: String {
        switch self {
        case .dev:
            return "https://api-dev.gd-azure-dev.net/"
        case .test:
            return "https://api-test.gd-azure-dev.net/"
        case .preprod:
            return "https://api.gd-pprod-infra.net/"
        case .prod:
            return "https://api.merchant.geidea.net/"
        }
    }
}

enum BaseVersion: String {
    case V1 = "api/v1/"
    case V2 = "api/v2/"
    case V3 = "api/v3/"
    case V4 = "api/v4/"
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
