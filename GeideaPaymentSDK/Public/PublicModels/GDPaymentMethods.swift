//
//  GDPaymentMethods.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 21.10.2022.
//

import Foundation

@objc public class GDPaymentSelectionMetods: NSObject, Codable {
    public var label: String? = nil
    public var paymentMethods: [String]
    
    @objc public init( label: String, paymentMethods: [String]) {
        
        self.label = label
        self.paymentMethods = paymentMethods
    }
    
}

