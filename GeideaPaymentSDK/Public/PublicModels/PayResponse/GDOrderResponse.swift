//
//  OrderResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/10/2020.
//

import Foundation

@objcMembers public class GDOrderResponse: NSObject, Codable {
    
    public var createdDate: String?
    public var createdBy: String?
    public var updatedDate: String?
    public var updatedBy: String?
    public var orderId : String?
    public var amount = 0.0
    public var currency: String?
    public var language: String?
    public var detailedStatus: String?
    public var status: String?
    public var threeDSecureId: String?
    public var merchantId: String?
    public var merchantPublicKey: String?
    public var merchantName: String?
    public var parentOrderId: String?
    public var multiCurrency: GDMultiCurrency?
    
    public var merchantReferenceId: String?
    public var callbackUrl: String?
    public var customerEmail: String?
    public var billingAddress: GDAddress?
    public var shippingAddress: GDAddress?
    public var returnUrl: String?
    public var cardOnFile = false
    
    public var tokenId: String?
    public var initiatedBy: String?
    public var agreementId: String?
    public var agreementType: String?
    
    public var paymentOperation: String?
    public var custom: String?
    public var paymentMethod: GDPaymentMethodResponse?
    
    public var tipAmount = 0.0
    public var totalAmount = 0.0
    public var settleAmount = 0.0
    public var totalAuthorizedAmount = 0.0
    public var totalCapturedAmount = 0.0
    public var totalRefundedAmount = 0.0
    public var paymentIntent: GDPaymentIntent?
    public var isTokenPayment = false
    public var restrictPaymentMethods = false
    public var platform: GDPlatform?
    public var transactions: [GDTransactionResponse]?
    public var statementDescriptor: GDStatementDescriptor?
    
    
    func parse(json: Data) -> GDOrderResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDOrderResponse.self, from: json)
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
