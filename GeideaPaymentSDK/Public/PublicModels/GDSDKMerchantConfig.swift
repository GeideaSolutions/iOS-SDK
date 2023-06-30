//
//  GDSDKMerchantConfig.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 26.10.2021.
//

import Foundation

@objc public class GDSDKMerchantConfig: NSObject, Codable {
    public var token: String?
    public var countryHeader: String?
    public var params: GDProductMConfig?
    
    @objc public init(withToken token: String? = nil, andCountryHeader countryHeader: String? = nil, params: GDProductMConfig?) {
        
        self.token = token
        self.countryHeader = countryHeader
        self.params  = params
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
