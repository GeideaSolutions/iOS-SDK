//
//  InitiateAuthenticationParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.10.2021.
//

import Foundation

struct InitiateAuthenticateParams: Codable {
    var merchantKey: String? = nil
    var orderId: String? = nil
    var merchantReferenceId: String? = nil
    var callbackUrl: String? = nil
    var billingAddress: AddressParams? = nil
    var shippingAddress: AddressParams? = nil
    var paymentOperation: String? = "Pay"
    var custom: String? = nil
    var customerEmail: String? = nil
    var cardOnFile = false
    var paymentIntentId: String? = nil
    var initiatedBy: String? = nil
    var agreementId: String? = nil
    var agreementType: String? = nil
    var restrictPaymentMethods = false
    var paymentMethods: [String]? = nil
    var source = Constants.source
    var amount = 0.0
    var currency = ""
    var cardNumber: String? = nil
    var platform: GDPlatform? = nil
    var statementDescriptor: GDStatementDescriptor? = nil
    var device = DeviceIndentificationParams()
    var subscriptionId: String? = nil
    //    var paymentMethod: PaymentMethodParams = PaymentMethodParams()
    var returnUrl = Constants.sdkReturnURL
    var language = GlobalConfig.shared.language.name.uppercased()
    
    init(amount: GDAmount, cardNumber: String?, tokenizationDetails: GDTokenizationDetails?, paymentIntentId: String? = nil, customerDetails: GDCustomerDetails?, orderId:String? = nil, paymentMethods: [String]? = nil) {
        guard let merchantKey = GeideaPaymentAPI.shared.getCredentials()?.0, !merchantKey.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E001.rawValue, code: GDErrorCodes.E001.description, detailedResponseMessage: GDErrorCodes.E001.detailedResponseMessage))
            return
        }
//        self.paymentMethod = PaymentMethodParams().fromCardDetails(cardDetails: cardDetails)
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
        self.cardNumber = cardNumber
        self.merchantKey = merchantKey
        if let pm = paymentMethods{
            self.restrictPaymentMethods = true
            self.paymentMethods = pm
        }
        
        var paymentintentId: String? = paymentIntentId
        if let safeId = paymentIntentId, safeId.isEmpty {
            paymentintentId = nil
        }
        self.paymentIntentId = paymentintentId
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
