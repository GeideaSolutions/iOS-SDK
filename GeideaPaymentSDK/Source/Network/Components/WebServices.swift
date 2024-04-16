//
//  WebServices.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

enum WebServices {
    
    static func requestWithDefaultHeader(_ baseUrl: URL, _ path: String, _ method: String) -> URLRequest?  {
            
        guard let merchantKey = GeideaPaymentAPI.shared.getCredentials()?.0, !merchantKey.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E001.rawValue, code: GDErrorCodes.E001.description, detailedResponseMessage: GDErrorCodes.E001.detailedResponseMessage))
            return nil
        }

        guard let password = GeideaPaymentAPI.shared.getCredentials()?.1, !password.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E002.rawValue, code: GDErrorCodes.E002.description, detailedResponseMessage: GDErrorCodes.E002.detailedResponseMessage))
            return nil
        }
        
        let contentType = GDWSConstants.ContentType.json
        let loginString = String(format: "%@:%@", merchantKey, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authorization = "Basic \(base64LoginString)"
        let accept = "*/*"
        let acceptEncoding = "gzip, deflate, br"
        let connection = "keep-alive"
        let language = GlobalConfig.shared.language.name.lowercased()
        
        var request = URLRequest(url: baseUrl.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue(authorization, forHTTPHeaderField: GDWSConstants.HeaderKeys.authorization)
        request.setValue(contentType, forHTTPHeaderField: GDWSConstants.HeaderKeys.contentType)
        request.setValue(accept, forHTTPHeaderField: GDWSConstants.HeaderKeys.accept)
        request.setValue(acceptEncoding, forHTTPHeaderField: GDWSConstants.HeaderKeys.acceptEncoding)
        request.setValue(connection, forHTTPHeaderField: GDWSConstants.HeaderKeys.connection)
        request.setValue(language, forHTTPHeaderField: GDWSConstants.HeaderKeys.language)
        return request
    }
    
    static func requestWithTokenHeader(_ baseUrl: URL, _ path: String, _ method: String, token: String, countryHeader: String?) -> URLRequest?  {
        
        let contentType = GDWSConstants.ContentType.json
        let authorization = token
        let accept = "*/*"
        let acceptEncoding = "gzip, deflate, br"
        let connection = "keep-alive"
        
        var request = URLRequest(url: baseUrl.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("\(authorization)", forHTTPHeaderField: GDWSConstants.HeaderKeys.authorization)
        request.setValue(contentType, forHTTPHeaderField: GDWSConstants.HeaderKeys.contentType)
        request.setValue(accept, forHTTPHeaderField: GDWSConstants.HeaderKeys.accept)
        request.setValue(acceptEncoding, forHTTPHeaderField: GDWSConstants.HeaderKeys.acceptEncoding)
        request.setValue(connection, forHTTPHeaderField: GDWSConstants.HeaderKeys.connection)
        request.setValue(countryHeader, forHTTPHeaderField: GDWSConstants.HeaderKeys.counterPartyCode)
        
        return request
    }
}
