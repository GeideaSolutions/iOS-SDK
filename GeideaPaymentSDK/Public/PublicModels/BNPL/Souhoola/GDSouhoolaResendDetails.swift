//
//  GDSouhoolaResendDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 23.06.2022.
//

import Foundation

@objcMembers public class GDSouhoolaResendOTPDetails: NSObject, Codable {
    
    public var customerIdentifier: String?
    public var customerPin: String?
    var language = GlobalConfig.shared.language.name.uppercased()
    
    @objc public init(customerIdentifier: String?,customerPin: String?) {
        self.customerIdentifier = customerIdentifier
        self.customerPin = customerPin
  
    }
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            let dict = try JSONSerialization.jsonObject(with: json, options: []) as! [String : Any]
            return dict
        } catch {
            return [:]
        }
      
    }
}
