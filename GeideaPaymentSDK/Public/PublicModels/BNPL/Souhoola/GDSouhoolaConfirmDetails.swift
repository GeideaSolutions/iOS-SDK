//
//  GDSouhoolaConfirmDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaConfirmDetails: NSObject, Codable {
    
    public var customerIdentifier: String?
    public var customerPin: String?
    public var orderId: String?
    public var souhoolaTransactionId: String?
    public var otp: String?
    var language = GlobalConfig.shared.language.name.uppercased()

    
    @objc public init(customerIdentifier: String?,customerPin: String?, orderId: String?, souhoolaTransactionId: String?, otp: String?) {
        self.customerIdentifier = customerIdentifier
        self.customerPin = customerPin
        self.orderId = orderId
        self.souhoolaTransactionId = souhoolaTransactionId
        self.otp = otp
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
