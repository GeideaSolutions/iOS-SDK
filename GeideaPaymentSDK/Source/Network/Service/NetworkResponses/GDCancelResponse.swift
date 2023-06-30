//
//  CancelResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 02/02/2021.
//

import Foundation

@objcMembers public class GDCancelResponse: NSObject, Codable {
    
    public var orderId: String?
    public var responseCode: String?
    public var responseMessage: String?
    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    
    
    func parse(json: Data) -> GDCancelResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDCancelResponse.self, from: json)
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


