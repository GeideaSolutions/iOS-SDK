//
//  PayRessponseParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/10/2020.
//

import Foundation

struct PayResponseConstants {
    static let orderId = "orderId"
    static let threeDSecureId = "threeDSecureId"
    static let orders = "orders"
    static let responseCode = "responseCode"
    static let responseMessage = "responseMessage"
    static let detailedResponseMessage = "detailedResponseMessage"
    static let detailedResponseCode = "detailedResponseCode"
}

public class PayResponse: NSObject, Codable {
    
    var order: GDOrderResponse?
    public var responseCode: String?
    public var responseMessage: String?
    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var language: String?
    
    override init() {}
    
    func parse(json: Data) -> PayResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(PayResponse.self, from: json)
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


