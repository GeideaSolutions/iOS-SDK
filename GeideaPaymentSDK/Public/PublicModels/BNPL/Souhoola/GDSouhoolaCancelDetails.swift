//
//  GDSouhoolaCancelDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 29.06.2022.
//

import Foundation


@objcMembers public class GDSouhoolaCancelDetails: NSObject, Codable {
    
    public var customerIdentifier: String?
    public var customerPin: String?
    public var souhoolaTransactionId: String?

    
    @objc public init(customerIdentifier: String?,customerPin: String?, souhoolaTransactionId: String?) {
        self.customerIdentifier = customerIdentifier
        self.customerPin = customerPin
        self.souhoolaTransactionId = souhoolaTransactionId
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
