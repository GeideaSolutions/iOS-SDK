//
//  GDBNPLReceiptResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.05.2022.
//

import Foundation

@objcMembers public class GDBNPLReceiptResponse: NSObject, Codable {
    

    public var provider: String?
    public var bnplOrderId: String?
    public var providerTransactionId: String?
    public var tenure: Int?
    public var currency: String?
    public var totalAmount: Double?
    public var financedAmount: Double?
    public var downPayment: Double?
    public var giftCardAmount: Double?
    public var campaignAmount: Double?
    public var installmentAmount: Double?
    public var adminFees: Double?
    public var loanNumber: String?
    public var interestTotalAmount: Double?
    public var firstInstallmentDate: String?
    public var lastinstallmentDate: String?
    public var providerResponseCode: String?
    public var providerResponseDescription: String?
    public var bnplDetailId: String?
    public var monthlyInterestRate: Double?
    public var otherFees: Double?
    public var amountToCollect: Double?
    public var annualInterestRate: Double?
    public var applicationId: String?
    public var applicationCreated: String?
    public var borrowerName: String?
    public var borrowerNationalId: String?
    public var borrowerAddress: String?
    public var orderCreated: String?
    
    override init() {}
    
    func parse(json: Data) -> GDBNPLReceiptResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDBNPLReceiptResponse.self, from: json)
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
