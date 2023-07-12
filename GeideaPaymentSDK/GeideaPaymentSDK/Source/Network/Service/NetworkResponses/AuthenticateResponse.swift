//
//  AuthenticateResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 20/10/2020.
//

import Foundation

struct AuthenticateResponseConstants {
    static let orderId = "orderId"
    static let threeDSecureId = "threeDSecureId"
    static let htmlBodyContent = "htmlBodyContent"
    static let responseCode = "responseCode"
    static let responseMessage = "responseMessage"
    static let detailedResponseMessage = "detailedResponseMessage"
    static let detailedResponseCode = "detailedResponseCode"
    static let gatewayDecision = "gatewayDecicision"
}

struct AuthenticateResponse: Codable {
    
    var orderId = "orderId"
    var threeDSecureId = "threeDSecureId"
    var htmlBodyContent = "htmlBodyContent"
    var responseCode = "responseCode"
    var responseMessage = "responseMessage"
    var detailedResponseMessage = "detailedResponseMessage"
    var detailedResponseCode = "detailedResponseCode"
    var gatewayDecision = "detailedResponseCode"
    
    init() {
    }
    
    func toDictionary() -> [String: Any]? {
        let dictionary = [AuthenticateResponseConstants.orderId: orderId,
                          AuthenticateResponseConstants.threeDSecureId: threeDSecureId,
                          AuthenticateResponseConstants.htmlBodyContent: htmlBodyContent,
                          AuthenticateResponseConstants.responseCode: responseCode,
                          AuthenticateResponseConstants.responseMessage: responseMessage,
                          AuthenticateResponseConstants.detailedResponseMessage: detailedResponseMessage,
                          AuthenticateResponseConstants.detailedResponseCode:detailedResponseCode] as [String : Any]
        
        
        return dictionary
    }
    
    func parse(json: Data) -> AuthenticateResponse? {
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(AuthenticateResponse.self, from: json) {
            return response
        }
        return nil
    }
}
