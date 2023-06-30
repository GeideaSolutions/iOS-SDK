//
//  GDCardBrandAuthentication.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 13.09.2021.
//

import Foundation

@objc public class GDCardBrandAuthentication: NSObject, Codable {
    
    var cardBrand: String?
    var endpointVersion: String? 
    
    @objc public override init() {}
    
    func parse(json: Data) -> GDCardBrandAuthentication? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDCardBrandAuthentication.self, from: json)
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
