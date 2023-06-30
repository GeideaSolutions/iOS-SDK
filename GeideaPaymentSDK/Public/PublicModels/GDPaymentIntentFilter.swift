//
//  GDPaymentIntentFilter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12.07.2021.
//

import Foundation

@objcMembers public class GDPaymentIntentFilter: NSObject, Codable {
   public var fromDate: String?
   public var toDate: String?
   public var take: Int = 50
    
    @objc public init(from fromDate: String? = nil, to toDate: String? = nil, take: Int = 20) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.take = take
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
