//
//  GDPaymentIntentOrder.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 15.09.2021.
//

import Foundation

@objcMembers public class GDPaymentIntentOrder: NSObject, Codable {
    public var paymentIntentId: String?
    public var createdDate : String?
    public var orderId : String?
    public var orderStatus: String?
}
