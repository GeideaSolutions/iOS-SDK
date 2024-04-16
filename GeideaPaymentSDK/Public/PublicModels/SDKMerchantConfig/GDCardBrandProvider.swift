//
//  GDCardBrandProvider.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.10.2021.
//

import Foundation

@objc public class GDCardBrandProvider: NSObject, Codable {
    
    public var acquiringProvider: String?
    public var cardBrand: String?
    public var threeDSecureProvider: String?
    
}
