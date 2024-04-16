//
//  GDInstallmentPlanSelectedResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.03.2022.
//

import Foundation

@objcMembers public class GDInstallmentPlanSelectedResponse: NSObject, Codable {
    

    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    public var orderId: String?
    public var nextStep: String?
    public var language: String?
    
    override init() {}
    
    func parse(json: Data) -> GDInstallmentPlanSelectedResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDInstallmentPlanSelectedResponse.self, from: json)
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
