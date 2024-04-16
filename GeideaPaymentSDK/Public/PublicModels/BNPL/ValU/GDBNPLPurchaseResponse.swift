//
//  BNPLPurchaseResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 23.02.2022.
//

import Foundation

import Foundation


@objcMembers public class GDBNPLPurchaseResponse: NSObject, Codable {
    

    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    public var language: String?
    public var bnplOrderId: String?
    public var providerTransactionId: String?
    public var orderId: String?
    public var loanNumber: String?
    public var financedAmount: Double?
    public var downPayment: Double?
    public var giftCardAmount: Double?
    public var campaignAmount: Double?
    public var tenure: Int?
    public var installmentAmount: Double?
    public var firstInstallmentDate: String?
    public var lastinstallmentDate: String?
    public var adminFees: Double?
//    public var interestTotalAmount = 0.0
    
    override init() {}
    
    func parse(json: Data) -> GDBNPLPurchaseResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDBNPLPurchaseResponse.self, from: json)
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
