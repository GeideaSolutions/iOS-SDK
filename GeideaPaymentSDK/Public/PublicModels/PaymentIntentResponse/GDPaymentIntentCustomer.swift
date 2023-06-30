//
//  GDPaymentIntentCustomer.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 19/02/2021.
//

import Foundation

@objcMembers public class GDPaymentIntentCustomer: NSObject, Codable {
    public var email: String?
    public var phone : String?
    public var name: String?
    public var customerId: String?
}
