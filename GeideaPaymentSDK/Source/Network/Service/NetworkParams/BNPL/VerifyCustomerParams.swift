//
//  VerifyCustomerParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

struct VerifyCustomerParams: Codable {

    var customerIdentifier: String? = nil
    var customerPin: String? = nil
    var language = GlobalConfig.shared.language.name.uppercased()

    init(customerIdentifer: String?, pin: String?  = nil) {
        self.customerIdentifier = customerIdentifer
        self.customerPin = pin
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
