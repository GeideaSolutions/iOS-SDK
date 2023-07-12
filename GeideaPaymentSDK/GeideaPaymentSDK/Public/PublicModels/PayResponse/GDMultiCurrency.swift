//
//  GDMultiCurrency.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 15.06.2022.
//

import Foundation

@objcMembers public class GDMultiCurrency: NSObject, Codable {
    

    public var settleAmount: Double?
    public var authCurrency: String?
    public var settleCurrency: String?
    public var authAmount: Double?
    
    override init() {}
    
    func parse(json: Data) -> GDMultiCurrency? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDMultiCurrency.self, from: json)
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
