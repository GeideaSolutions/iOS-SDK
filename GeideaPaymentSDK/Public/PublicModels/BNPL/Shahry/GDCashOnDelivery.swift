//
//  GDCashOnDelivery.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 15.06.2022.
//

import Foundation

@objcMembers public class GDCashOnDelivery: NSObject, Codable {
   
    public var orderId: String?

    
    @objc public init(orderId: String?) {
        self.orderId  = orderId
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
