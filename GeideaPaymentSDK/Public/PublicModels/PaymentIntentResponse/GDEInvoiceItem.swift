//
//  GDEInvoiceItem.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.11.2021.
//

import Foundation

@objcMembers public class GDEInvoiceItem: NSObject, Codable {
    public var total: Double
    public var tax: Double = 0
    public var taxType: String?
    public var price: Double = 0
    public var quantity = 0
    public var itemDiscount: Double = 0
    public var itemDiscountType: String?
    public var itemDescription: String?
    public var sku: String?
    
    private enum CodingKeys : String, CodingKey {
         case itemDescription = "description", total, tax, taxType,price,quantity,itemDiscount,itemDiscountType, sku
    }
    
    @objc public init(total: Double, tax: Double, taxType: String?, price: Double, quantity: Int, itemDiscount: Double, itemDiscountType: String?, description: String?, sku: String?) {
        self.total = total
        self.tax = tax
        self.taxType = taxType
        self.price = price
        self.quantity = quantity
        self.itemDiscount = itemDiscount
        self.itemDiscountType = itemDiscountType
        self.itemDescription = description
        self.sku = sku
        
    }
    
    
}
