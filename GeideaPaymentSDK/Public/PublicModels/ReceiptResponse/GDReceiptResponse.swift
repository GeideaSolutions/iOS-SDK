//
//  GDReceiptResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.03.2022.
//

import Foundation

@objcMembers public class GDReceiptResponse: NSObject, Codable {

    public var responseMessage : String?
    public var detailedResponseMessage: String?
    public var responseCode: String?
    public var detailedResponseCode: String?
    public var language: String?
    public var receipt: GDReceipt?
    
    func parse(json: Data) -> GDReceiptResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDReceiptResponse.self, from: json)
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
