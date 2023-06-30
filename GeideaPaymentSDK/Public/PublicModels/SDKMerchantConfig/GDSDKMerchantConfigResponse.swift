//
//  SDKMerchantConfigResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.10.2021.
//

import Foundation


@objcMembers public class GDSDKMerchantConfigResponse: NSObject, Codable {
    
   public var merchantId: String? = nil
   public var storeId: String? = nil
   public var data: GDMerchantDataResponse? = nil
    
    override init() {}
    
    func parse(json: Data) -> [GDSDKMerchantConfigResponse]? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode([GDSDKMerchantConfigResponse].self, from: json)
            return response
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return nil
    }
}
