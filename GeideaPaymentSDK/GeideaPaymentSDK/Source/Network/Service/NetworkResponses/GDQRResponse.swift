//
//  GDQRResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.07.2021.
//

import Foundation

@objcMembers public class GDQRResponse: NSObject, Codable {
    
    public var paymentIntentId: String?
    public var message: String?
    public var image: String?
    public var type: String?
   
    override init() {}
  
    func parse(json: Data) -> GDQRResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDQRResponse.self, from: json)
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


