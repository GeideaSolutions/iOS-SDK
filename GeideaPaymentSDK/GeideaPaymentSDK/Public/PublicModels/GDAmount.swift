//
//  Amount.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 22/10/2020.
//

import Foundation

@objc public class GDAmount: NSObject {
    
    public var amount: Double
    public var currency: String
    
    @objc public init(amount: Double, currency: String) {
        self.amount = amount
        self.currency = currency.uppercased()
    }
}
