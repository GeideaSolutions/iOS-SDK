//
//  GDSendMultipleDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.12.2021.
//

import Foundation

@objc public class GDSendLinkMultipleDetails: NSObject, Codable {
    public var paymentIntentIds: [String]? = nil
    public var sendingChannels: [String]? = nil
    
    @objc public init(withPaymentIntentId paymentIntentIds: [String]? = nil, sendingChannels:[String]? = nil) {
        
        self.paymentIntentIds = paymentIntentIds
        self.sendingChannels = sendingChannels
    }
    
}
