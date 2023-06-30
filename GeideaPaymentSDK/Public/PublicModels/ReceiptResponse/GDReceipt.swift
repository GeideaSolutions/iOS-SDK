//
//  GDReceipt.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.03.2022.
//

import Foundation

@objcMembers public class GDReceipt: NSObject, Codable {
    
    public var orderId : String?
    public var paymentDate: String?
    public var amount = 0.0
    public var currency: String?
    public var customerEmail: String?
    public var paymentIntentType: String?
    public var paymentIntentNumber: String?
    public var paymentOperation: String?
    public var paymentMethod: GDPaymentMethodResponse?
    public var merchant: GDMerchant?
    public var eInvoiceCustomer: GDPICustomer?
    public var eInvoice: GDEInvoiceDetails?
    public var bnplDetails: GDBNPLReceiptResponse?
    
    
    func parse(json: Data) -> GDReceipt? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDReceipt.self, from: json)
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
