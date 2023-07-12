//
//  ConfigCountries.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 02/12/2020.
//

import Foundation

@objcMembers public class ConfigCountriesResponse: NSObject, Codable {
    
    public var key3: String?
    public var nameEn: String?
    public var nameAr: String?
    public var key2: String?
    public var isSupported: Bool = false
    public var numericCode: Int?
    
    
    func parse(json: Data) -> ConfigCountriesResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ConfigCountriesResponse.self, from: json)
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
