//
//  GDPaymentIntentsResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12.07.2021.
//

import Foundation

@objcMembers public class GDPaymentIntentsResponse: NSObject, Codable {
    public var paymentIntents: [GDPaymentIntentDetailsResponse]?
    public var responseMessage : String?
    public var detailedResponseMessage: String?
    public var responseCode: String?
    public var detailedResponseCode: String?
    public var language: String?
    
    override init() {}
    
    func parse(json: Data) -> GDPaymentIntentsResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDPaymentIntentsResponse.self, from: json)
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
