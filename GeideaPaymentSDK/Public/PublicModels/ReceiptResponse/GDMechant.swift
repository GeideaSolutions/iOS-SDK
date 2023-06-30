//
//  GDMechant.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.03.2022.
//

import Foundation

@objcMembers public class GDMerchant: NSObject, Codable {
 
    public var referenceId: String?
    public var name: String?
    public var nameAr: String?
    public var vatNumber: String?
    public var vatNumberAr: String?
}
