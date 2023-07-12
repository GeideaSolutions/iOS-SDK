//
//  ShahryItemParam.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 14.04.2022.
//

import Foundation

struct ShahryItemParams: Codable {

    var merchantItemId: String? = nil
    var name: String? = nil
    var description: String? = nil
    var currency: String? = nil
    var price: Double? = 0.0
    var count: Int? = 0
    var categories: [String]? = nil

    init(item: GDBNPLItem?) {
        self.merchantItemId = item?.merchantItemId
        self.name = item?.name
        self.description = item?.itemDescription
        self.currency = item?.currency
        self.price = item?.price
        self.count = item?.count
        self.categories = item?.categories
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
