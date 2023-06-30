//
//  SendLinkMultipleParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.12.2021.
//

import Foundation

struct SendLinkMultipleParams: Codable {
    var paymentIntentIds: [String]?
    var sendingChannels: [String]?
    
    init(sendDetails: GDSendLinkMultipleDetails) {
        self.paymentIntentIds = sendDetails.sendingChannels
        self.sendingChannels = sendDetails.sendingChannels
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
