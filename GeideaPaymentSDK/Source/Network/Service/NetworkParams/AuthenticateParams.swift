//
//  AuthenticateParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation

struct Constants {
    static let sdkReturnURL = "https://geideapaymentsdk"
    static let source = "MobileApp"
}

struct AuthenticateParams: Codable {

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
    var device = DeviceIndentificationParams()
    var subscriptionId: String? = nil
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.uppercased()
    
    init(amount: GDAmount, cardDetails: GDCardDetails, tokenizationDetails: GDTokenizationDetails?, paymentIntentId: String?, customerDetails: GDCustomerDetails?, orderId:String? = nil, paymentMethods: [String]? = nil) {
        self.paymentMethod = PaymentMethodParams().fromCardDetails(cardDetails: cardDetails)
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
//        self.timezone = TimeZone.current.
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
