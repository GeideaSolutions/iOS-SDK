//
//  GDApplePayResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27/11/2020.
//

import Foundation

struct ApplePayeResponseConstants {
    static let responseCode = "responseCode"
    static let responseMessage = "responseMessage"
    static let detailedResponseCode = "detailedResponseCode"
    static let detailedResponseMessage = "detailedResponseMessage"
    static let orderId = "orderId"
}

@objcMembers public class GDApplePayResponse: NSObject, Codable {
    
    public var responseCode = ""
    public var responseMessage = ""
    public var detailedResponseCode = ""
    public var detailedResponseMessage = ""
    public var orderId = ""
    
    func parse(json: Data) -> GDApplePayResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDApplePayResponse.self, from: json)
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

