//
//  GenerateOTPParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

import Foundation

struct GenerateOTPParams: Codable {

    var customerIdentifier = ""
    var bnplOrderId = ""

    init(customerIdentifer: String, BNPLOrderID: String) {
        self.customerIdentifier = customerIdentifer
        self.bnplOrderId = BNPLOrderID
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

