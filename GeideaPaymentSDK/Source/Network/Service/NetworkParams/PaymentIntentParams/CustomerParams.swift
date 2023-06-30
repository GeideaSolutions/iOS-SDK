//
//  CustomerParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 17/02/2021.
//

import Foundation

struct CustomerParams: Codable {
    
    var email: String?
    var phone: String? 
    var name: String?
    
    init() {}
    
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
