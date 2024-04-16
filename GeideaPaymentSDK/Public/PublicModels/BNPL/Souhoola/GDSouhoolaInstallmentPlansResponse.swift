//
//  GDSouhoolaInstallmentPlansResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 03.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaInstallmentPlansResponse: NSObject, Codable {
    

    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    public var language: String?
    public var currency: String?
    public var installmentPlans: [GDInstallmentPlan]?
    
    override init() {}
    
    func parse(json: Data) -> GDSouhoolaInstallmentPlansResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDSouhoolaInstallmentPlansResponse.self, from: json)
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
