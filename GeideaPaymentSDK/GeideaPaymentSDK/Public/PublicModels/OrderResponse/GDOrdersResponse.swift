//
//  GDOrdersResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 01/03/2021.
//

import Foundation

@objcMembers public class GDOrdersResponse: NSObject, Codable {
    
    public var orders: [GDOrderResponse]?
    public var totalCount: Int = 0
    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    
    override init() {}
    
    func parse(json: Data) -> GDOrdersResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDOrdersResponse.self, from: json)
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
