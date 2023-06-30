//
//  GDSouhoolaReviewResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 10.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaReviewResponse: NSObject, Codable {
    

    public var responseCode: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var detailedResponseMessage: String?
    public var language: String?
    public var souhoolaTransactionId: String?
    public var installments: [GDSouhoolaInstallmentPlanResponse]?
    public var totalInvoicePrice: Double?
    public var loanAmount: Double?
    public var downPayment: Double?
    public var administrativeFees: String?
    public var netAdministrativeFees: Double?
    public var merchantName: String?
    public var cartCount: Double?
    public var promoCode: String?
    public var mainAdministrativeFees: Double?
    public var annualRate: Double = 0
    public var firstInstallmentDate: String?
    public var lastInstallmentDate: String?
    public var installmentAmount: Double = 0
    
    override init() {}
    
    func parse(json: Data) -> GDSouhoolaReviewResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDSouhoolaReviewResponse.self, from: json)
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
