//
//  GDSouhoolsInstallmentPlanSelectedResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaInstallmentPlanSelectedResponse: NSObject, Codable {
    

    public var responseCode: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var detailedResponseMessage: String?
    public var language: String?
    public var souhoolaTransactionId: String?
    public var nextStep: String?
    public var orderId: String?
    
    override init() {}
    
    func parse(json: Data) -> GDSouhoolaInstallmentPlanSelectedResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDSouhoolaInstallmentPlanSelectedResponse.self, from: json)
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
