//
//  PaymentRequestParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21.07.2021.
//

import Foundation

struct PaymentRequestParams: Codable {
    var paymentIntentId: String?
    var amount = 0.0
    var currency = ""
    var expiryDate: String?
    var type: String?
    var status: String?
    var language = GlobalConfig.shared.language.name.uppercased()
    
    
    var customer: CustomerParams = CustomerParams()
    
    init(paymentIntentDetails: GDPaymentIntentDetails) {
        self.paymentIntentId = paymentIntentDetails.paymentIntentId
        self.amount = paymentIntentDetails.amount.amount
        self.currency = paymentIntentDetails.amount.currency
        let dateFormatter = DateFormatter()
        if let expiry = paymentIntentDetails.expiryDate {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            let date = dateFormatter.string(from: expiry)
            self.expiryDate = date
        } else {
            self.expiryDate = nil
        }
        
        if let email = paymentIntentDetails.email, email.isEmpty {
            self.customer.email = nil
        } else {
            self.customer.email = paymentIntentDetails.email
        }
        
        if let name = paymentIntentDetails.name, name.isEmpty {
            self.customer.name = nil
        } else {
            self.customer.name = paymentIntentDetails.name
        }
       
        if let phone = paymentIntentDetails.phoneNumber, phone.isEmpty {
            self.customer.phone = nil
        } else {
            self.customer.phone = paymentIntentDetails.phoneNumber
        }
        
        if let status = paymentIntentDetails.status, status.isEmpty {
            self.status = nil
        } else {
            self.status = paymentIntentDetails.status
        }
        
        if let type = paymentIntentDetails.type, type.isEmpty {
            self.type = nil
        } else {
            self.type = paymentIntentDetails.type
        }
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
