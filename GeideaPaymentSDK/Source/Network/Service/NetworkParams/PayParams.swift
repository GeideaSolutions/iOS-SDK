//
//  PayParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation

struct PayParams: Codable {

    var threeDSecureId = ""
    var amount = 0.0
    var orderId = ""
    var currency = ""
    var paymentMethod = PaymentMethodParams()
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.lowercased()
    
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
