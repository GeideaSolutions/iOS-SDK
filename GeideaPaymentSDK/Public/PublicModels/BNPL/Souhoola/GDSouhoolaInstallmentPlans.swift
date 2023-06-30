//
//  GDSouhoolaInstallmentPlans.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 03.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaRetreiveInstallmentPlans: NSObject, Codable {

    public var customerIdentifier: String?
    public var customerPin: String?
    public var totalAmount = 0.0
    public var currency: String?
    public var downPayment = 0.0
    var language = GlobalConfig.shared.language.name.uppercased()
    
    @objc public init(customerIdentifier: String?,customerPin: String?, totalAmount: Double, currency: String?, adminFees: Double, downPayment: Double) {
        self.customerIdentifier = customerIdentifier
        self.customerPin = customerPin
        self.totalAmount = totalAmount
        self.currency = currency
        self.downPayment = downPayment
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
