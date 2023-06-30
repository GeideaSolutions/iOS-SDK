//
//  GSSouhoolaInstallmentPlan.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 10.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaInstallmentPlanResponse: NSObject, Codable {
    

    public var kstNo: Double?
    public var kstAmt: Double?
    public var kstInt: Double?
    public var kstBal: Double?
    public var kstDate: String?
    public var oldDebtBal: Double?
    public var newDebtBal: Double?
    public var debtNo: String?
    
    override init() {}
    
    func parse(json: Data) -> GDSouhoolaInstallmentPlanResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDSouhoolaInstallmentPlanResponse.self, from: json)
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
