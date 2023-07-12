//
//  PayTokenParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 10/12/2020.
//

import Foundation

struct PayTokenParams: Codable {

    var amount = 0.0
    var currency = ""
    var tokenId = ""
    var source = Constants.source
    var merchantReferenceId: String? = nil
    var billingAddress: AddressParams? = nil
    var shippingAddress: AddressParams? = nil
    var isCreateCustomerEnabled: Bool? = false
    var customerId: String? = nil
    var customerReferenceId: String? = nil
    var customerEmail: String? = nil
    var paymentOperation: String? = nil
    var paymentIntentId: String? = nil
    var orderId: String? = nil
    var paymentIntent: String? = nil
    var initiatedBy: String? = nil
    var agreementId: String? = nil
    var callbackUrl: String? = nil
    var agreementType: String? = nil
    var cvv: String? = nil
    var threeDSecureId: String? = nil
    var subscriptionId: String? = nil
    var items: [String]? = [String]()
    var returnUrl = Constants.sdkReturnURL
    var language = GlobalConfig.shared.language.name.uppercased()
    
    init(amount: GDAmount, tokenId: String, orderId: String? = nil, paymentIntent: String?, initiatedBy: String?, agreementId: String? = nil, agreementType: String? = nil, customerDetails: GDCustomerDetails?) {
       
        self.initiatedBy = initiatedBy
        if initiatedBy == "Merchant" {
            self.agreementId = agreementId
        }
        self.amount = amount.amount
        self.currency = amount.currency
        self.tokenId = tokenId
        self.orderId = orderId
        self.merchantReferenceId = customerDetails?.merchantReferenceId
        self.callbackUrl = customerDetails?.callbackUrl
        self.billingAddress = AddressParams(from: customerDetails?.billingAddress)
        self.shippingAddress = AddressParams(from: customerDetails?.shippingAddress)
        self.customerEmail = customerDetails?.customerEmail
        self.paymentOperation = customerDetails?.paymentOperation?.paymentOperation
        self.paymentIntent = paymentIntent
    }
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            let dict = try JSONSerialization.jsonObject(with: json, options: []) as! [String : Any]
            return dict
        } catch {
            return [:]
        }
    }
}
