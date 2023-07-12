//
//  QRParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.07.2021.
//

import Foundation

struct QRParams: Codable {

    var amount: Double? = nil
    var currency: String? = nil
//    var customer: GDPICustomer?
    var customerEmail: String?
    var customerPhoneNumber: String?
    var customerPhoneCountryCode: String?
    var expiryDate: String?
    var merchantPublicKey: String?
    var customerReferenceId: String?
    var activationDate: String?
    var parentPaymentIntentId: String?
    var orderId: String?
    var callbackUrl: String?
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.uppercased()
    
    init(amount: GDAmount, customer: GDPICustomer?, expiryDate: String?, merchantName: String, orderId: String? = nil, callbackUrl:String?) {
        guard let merchantKey = GeideaPaymentAPI.shared.getCredentials()?.0, !merchantKey.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E001.rawValue, code: GDErrorCodes.E001.description, detailedResponseMessage: GDErrorCodes.E001.detailedResponseMessage))
            return
        }
        self.amount = amount.amount
        self.currency = amount.currency
        self.customerEmail = customer?.email
        self.customerPhoneNumber = customer?.phoneNumber
        self.customerPhoneCountryCode = customer?.phoneCountryCode
        self.expiryDate = expiryDate
        self.merchantPublicKey = merchantKey
        self.orderId = orderId
        self.callbackUrl = callbackUrl
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
