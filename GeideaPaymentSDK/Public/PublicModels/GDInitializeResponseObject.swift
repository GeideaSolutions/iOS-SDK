//
//  GDInitializeResponseObject.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 20.09.2022.
//

import Foundation

@objc public class GDInitializeReponseObject: NSObject, Codable {
    public var gatewayDecision: String? = nil
    public var threedSecureId: String? = nil
    
    @objc public init(withGatewayDecision gatewayDecision: String, threedSecureId:String) {
        
        self.gatewayDecision = gatewayDecision
        self.threedSecureId = threedSecureId
    }
    
}
