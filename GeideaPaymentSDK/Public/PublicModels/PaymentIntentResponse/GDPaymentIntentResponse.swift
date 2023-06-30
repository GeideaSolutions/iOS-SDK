//
//  GDPaymentIntentResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 19/02/2021.
//

import Foundation

@objcMembers public class GDPaymentIntentResponse: NSObject, Codable {
    public var paymentIntent: GDPaymentIntentDetailsResponse?
    public var responseMessage : String?
    public var detailedResponseMessage: String?
    public var responseCode: String?
    public var detailedResponseCode: String?
    public var language: String?
    
    override init() {}
    
    func parse(json: Data) -> GDPaymentIntentResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDPaymentIntentResponse.self, from: json)
            return response
        } catch DecodingError.dataCorrupted(let context) {
            print("codingPath:", context.codingPath)
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
