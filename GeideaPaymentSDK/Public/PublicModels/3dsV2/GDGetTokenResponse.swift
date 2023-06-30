//
//  GDGetTokenResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.07.2022.
//

import Foundation

@objcMembers public class GDGetTokenResponse: NSObject, Codable {
    
    var expiryDate: GDExpiryDate? = nil
    var lastFourDigits: String? = nil
    var schema: String? = nil
    var responseCode: String? = nil
    var responseMessage: String? = nil
    var detailedResponseMessage: String? = nil
    var detailedResponseCode: String? = nil
    var language: String? = nil
    
    override init() {}
    
    func parse(json: Data) -> GDGetTokenResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDGetTokenResponse.self, from: json)
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
