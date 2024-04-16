//
//  ApplePayParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 24/11/2020.
//

import Foundation
import PassKit

struct ApplePayConstants {
    static let orderId = "orderId"
    static let token = "token"
    static let owner = "owner"
    static let merchantReferenceId = "merchantReferenceId"
    static let callbackUrl = "callbackUrl"
    static let customerEmail = "customerEmail"
    static let shippingAddress = "shippingAddress"
    static let billingAddress = "billingAddress"
    static let paymentOperation = "paymentOperation"
    static let source = "source"
    
}

struct ApplePayParams {
    var payment: PKPayment
    var orderId: String?
    var merchantReferenceId: String?
    var callbackUrl: String?
    var paymentOperation = "Pay"
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.uppercased()
    
    
    func toDictionary() -> [String: Any] {
        let tokenJson = fromApplePayToken(payment: payment)

        var owner: String? = nil
        if let givenName = payment.shippingContact?.name?.givenName, let name = payment.shippingContact?.name?.familyName {
            owner = "\(givenName) \(name)"
        }
                
        var billingAddress: [String : Any]? = nil
        var shippingAddres: [String : Any]? = nil
        var customerEmail: String? = nil
        if payment.billingContact != nil {
            billingAddress =  AddressParams(from: payment.billingContact).toDictionary()
            customerEmail = payment.shippingContact?.emailAddress
        }
        if payment.shippingContact != nil {
            shippingAddres = AddressParams(from: payment.shippingContact).toDictionary()
        }
        
        let dictionary = [
            ApplePayConstants.orderId: orderId,
            ApplePayConstants.token: tokenJson,
            ApplePayConstants.owner: owner,
            ApplePayConstants.merchantReferenceId: merchantReferenceId,
            ApplePayConstants.callbackUrl: callbackUrl,
            ApplePayConstants.source: source,
            ApplePayConstants.customerEmail: customerEmail,
            ApplePayConstants.billingAddress: billingAddress,
            ApplePayConstants.shippingAddress: shippingAddres,
            ApplePayConstants.paymentOperation: paymentOperation] as [String : Any] as [String : Any]
        
        return dictionary
    }
    
    func fromApplePayToken(payment: PKPayment)  -> [String: Any] {
        
        let paymentDataDictionary: [AnyHashable: Any]? = try? JSONSerialization.jsonObject(with: payment.token.paymentData, options: .mutableContainers) as! [AnyHashable : Any]
        var paymentType: String = "debit"

        var paymentMethodDictionary: [AnyHashable: Any] = ["network": "", "type": paymentType, "displayName": ""]

        if #available(iOS 9.0, *) {
            paymentMethodDictionary = ["network": payment.token.paymentMethod.network ?? "", "type": paymentType, "displayName": payment.token.paymentMethod.displayName ?? ""]

            switch payment.token.paymentMethod.type {
                case .debit:
                    paymentType = "debit"
                case .credit:
                    paymentType = "credit"
                case .store:
                    paymentType = "store"
                case .prepaid:
                    paymentType = "prepaid"
                default:
                    paymentType = "unknown"
                }
        }

        let cryptogramDictionary: [AnyHashable: Any] = ["paymentData": paymentDataDictionary ?? "", "transactionIdentifier": payment.token.transactionIdentifier, "paymentMethod": paymentMethodDictionary]
        let cardCryptogramPacketDictionary: [AnyHashable: Any] = cryptogramDictionary
        let cardCryptogramPacketData: Data? = try? JSONSerialization.data(withJSONObject: cardCryptogramPacketDictionary, options: [])
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: cardCryptogramPacketData!,  options: []) as? [String: Any] {
                // try to read out a string array
                
                return json
            }
            
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return [String: Any]()
    }

}
