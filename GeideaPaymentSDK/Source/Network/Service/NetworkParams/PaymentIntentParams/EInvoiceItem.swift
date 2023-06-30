//
//  EInvoiceItem.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 10.11.2021.
//

import Foundation

struct EInvoiceItemParams: Codable {
    var total = 0.0
    var tax = 0.0
    var taxType: String?
    var price = 0.0
    var quantity = 0
    var itemDiscount = 0.0
    var itemDiscountType: String? = "Amount"
    var description: String? = nil
    var sku: String? = nil

    init(eInvoiceItemParams: GDEInvoiceItem) {
        self.total = eInvoiceItemParams.total
        self.price = eInvoiceItemParams.price
        self.tax = eInvoiceItemParams.tax
        self.quantity = eInvoiceItemParams.quantity
        self.sku = eInvoiceItemParams.sku
        self.itemDiscount = eInvoiceItemParams.itemDiscount

        if let taxType = eInvoiceItemParams.taxType, taxType.isEmpty {
            self.taxType = nil
        } else {
            self.taxType = eInvoiceItemParams.taxType
        }

        if let itemDiscountType = eInvoiceItemParams.itemDiscountType, itemDiscountType.isEmpty {
            self.itemDiscountType = nil
        } else {
            self.itemDiscountType = eInvoiceItemParams.itemDiscountType
        }

//        if let eInvoiceDescription = eInvoiceItemParams.eInvoiceDescription, eInvoiceDescription.isEmpty {
//            self.description = nil
//        } else {
//            self.description = eInvoiceItemParams.eInvoiceDescription
//        }
        
        if let sku = eInvoiceItemParams.sku, sku.isEmpty {
            self.sku = nil
        } else {
            self.sku = eInvoiceItemParams.sku
        }

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

