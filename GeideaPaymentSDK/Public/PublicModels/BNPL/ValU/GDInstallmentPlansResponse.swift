//
//  GDInstallmentPlansResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 17.02.2022.
//

import Foundation


@objcMembers public class GDInstallmentPlansResponse: NSObject, Codable {
    

    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    public var language: String?
    public var currency: String?
    public var bnplOrderId: String?
    public var minimumDownPayment = 0.0
    public var totalAmount = 0.0
    public var financedAmount = 0.0
    public var giftCardAmount = 0.0
    public var campaignAmount = 0.0
    public var installmentPlans: [GDInstallmentPlan]?
    
    override init() {}
    
    func parse(json: Data) -> GDInstallmentPlansResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDInstallmentPlansResponse.self, from: json)
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
