//
//  GDSouhoolaVerify.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 03.05.2022.
//

import Foundation


@objcMembers public class GDSouhoolaVerifyResponse: NSObject, Codable {
    

    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    public var language: String?
    public var approvedLimit: Double?
    public var outstanding: Double?
    public var availableLimit: Double?
    public var minLoanAmount: Double?
    
    override init() {}
    
    func parse(json: Data) -> GDSouhoolaVerifyResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDSouhoolaVerifyResponse.self, from: json)
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
