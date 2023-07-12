//
//  AuthenticateTokenParamsV3.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 21.07.2022.
//

import Foundation

struct AuthenticateTokenPayerParams: Codable {
    var tokenId: String? = nil
    var orderId: String? = nil
    var merchantName: String? = nil
    var amount = 0.0
    var currency = ""
    var paymentMethod: PaymentMethodParams = PaymentMethodParams()
    var restrictPaymentMethods = false
    var paymentMethods: [String]? = nil
    var merchantReferenceId: String? = nil
    var callbackUrl: String? = nil
    var billingAddress: AddressParams? = nil
    var shippingAddress: AddressParams? = nil
    var customerEmail: String? = nil
    var returnUrl = Constants.sdkReturnURL
    var paymentOperation: String? = nil
    var cardOnFile = false
    var initiatedBy: String? = nil
    var agreementId: String? = nil
    var agreementType: String? = nil
    var paymentIntentId: String? = nil
    var recurrence: GDRecurrence? = nil
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.lowercased()
    var browser =  "Mozilla 5.0 iPhone CPU iPhone OS 15 5 like Mac OS X AppleWebKit/605.1.15 KHTML like Gecko Mobile 15E148"
    var timezone = 273
    var javaEnabled = true
    var javaScriptEnabled = true
    var cvv: String? = nil
//    var deviceIdentification = DeviceIndentificationParams()
    
  
    init(amount: GDAmount, tokenId: String, tokenizationDetails: GDTokenizationDetails?, paymentIntentId: String?, customerDetails: GDCustomerDetails?, recurrence: GDRecurrence? = nil, orderId:String?, paymentMethods: [String]? = nil) {
        self.tokenId = tokenId
        self.orderId = orderId
        if let safeCardOnFile = tokenizationDetails?.cardOnFile {
            self.cardOnFile = safeCardOnFile
        }
        self.initiatedBy = tokenizationDetails?.initiatedBy
        if let agreementId = tokenizationDetails?.agreementId {
            if agreementId.isEmpty {
                self.agreementId = nil
            } else {
                self.agreementId = agreementId
            }
        } else{
            self.agreementId = tokenizationDetails?.agreementId
        }
        if let agreementType = tokenizationDetails?.agreementType {
            if agreementType.isEmpty {
                self.agreementType = nil
            } else {
                self.agreementType = agreementType
            }
        } else{
            self.agreementType = tokenizationDetails?.agreementType
        }
        self.amount = amount.amount
        self.currency = amount.currency
        self.merchantReferenceId = customerDetails?.merchantReferenceId
        self.callbackUrl = customerDetails?.callbackUrl
        self.billingAddress = AddressParams(from: customerDetails?.billingAddress)
        self.shippingAddress = AddressParams(from: customerDetails?.shippingAddress)
        self.customerEmail = customerDetails?.customerEmail
        self.paymentOperation = customerDetails?.paymentOperation?.paymentOperation
        
        if let pm = paymentMethods{
            self.restrictPaymentMethods = true
            self.paymentMethods = pm
        }
        
        var paymentintentId: String? = paymentIntentId
        if let safeId = paymentIntentId, safeId.isEmpty {
            paymentintentId = nil
        }
        self.paymentIntentId = paymentintentId
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale.variantCode
        print(formatter.string(from: Date()))
//        timezone =ormatter.string(from: Date())
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

