//
//  GDShahryConfirm.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 14.04.2022.
//

import Foundation

@objcMembers public class GDShahryConfirm: NSObject, Codable {
    public var orderId: String?
    public var orderToken: String?
    
    @objc public init(orderId: String?, orderToken: String?) {
        self.orderId  = orderId
        self.orderToken = orderToken
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
