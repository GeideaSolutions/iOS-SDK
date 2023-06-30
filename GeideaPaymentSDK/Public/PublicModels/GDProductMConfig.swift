//
//  GDProductMConfig.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 28.09.2021.
//

import Foundation

struct ProductConstants {
    static let MerchantId = "MerchantId"
    static let StoreId = "StoreId"
    static let IsTest = "IsTest"
}

@objc public class GDProductMConfig: NSObject, Codable {
    public var StoreId: String?
    public var MerchantId: String?
    public var IsTest = true
    
    @objc public init(withMerchantId merchantId: String? = nil, andStoreId storeId: String? = nil, isTest: Bool = true) {
        
        self.MerchantId = merchantId
        self.StoreId = storeId 
        self.IsTest = isTest
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
    
    func toDictionary() -> [String: Any] {
        
        
        var dictionary = [ProductConstants.IsTest: IsTest] as [String : Any]
        if let storeID = StoreId {
            dictionary.updateValue(storeID, forKey: ProductConstants.StoreId)
        }
        if let merchantID = MerchantId {
            dictionary.updateValue(merchantID, forKey: ProductConstants.MerchantId)
        }
        
        return dictionary
    }
}
