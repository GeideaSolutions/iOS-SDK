//
//  GDShahryItem.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 08.04.2022.
//

import Foundation

@objcMembers public class GDBNPLItem: NSObject, Codable {
    public var merchantItemId: String?
    public var name:  String?
    public var itemDescription: String?
    public var categories: [String]?
    public var count = 0
    public var price = 0.0
    public var currency: String?
    
    @objc public init(merchantItemId: String?, name: String?, itemDescription: String?, categories: [String]?, count: Int, price: Double, currency: String? = "EGP" ) {
       
        self.merchantItemId = merchantItemId
        self.name = name
        self.itemDescription = itemDescription
        self.categories = categories
        self.count = count
        self.price = price
        self.currency = currency

    }
}
