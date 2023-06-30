//
//  GDExpiryDate.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.07.2022.
//

import Foundation

@objcMembers public class GDExpiryDate: NSObject, Codable {
    
    public var month = 0
    public var year = 0
    
    override init() {}
    
    func parse(json: Data) -> GDInitiateAuthenticateResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDInitiateAuthenticateResponse.self, from: json)
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
