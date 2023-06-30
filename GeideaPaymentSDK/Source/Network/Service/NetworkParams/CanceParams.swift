//
//  CanceParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 02/02/2021.
//

import Foundation

struct CancelParams: Codable {

    var orderId: String? = nil
    var reason: String? = nil
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.uppercased()
    
    init(orderId: String, reason: String) {
        self.orderId = orderId
        self.reason = reason
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
