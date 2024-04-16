//
//  GDPaymentIntentDetails.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/02/2021.
//

import Foundation

@objc public class GDPaymentIntentDetails: NSObject {
    var paymentIntentId: String?
    var amount: GDAmount
    var expiryDate: Date?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var phoneCountryCode: String?
    var activationDate: Date?
    var eInvoiceDetails: GDEInvoiceDetails?
    var status: String?
    var type: String?
    
    @objc public init(withAmount amount: GDAmount, andExpiryDate expiryDate:Date? = nil, andActivationDate activationDate:Date? = nil, andCustomer customer: GDPICustomer, andEInvoiceDetails eInvoiceDetails: GDEInvoiceDetails? = nil, paymentIntentId: String? = nil, status: String? = nil, type: String? = nil) {
        self.paymentIntentId = paymentIntentId
        self.amount = amount
        self.name = customer.name
        self.phoneNumber = customer.phoneNumber
        self.phoneCountryCode = customer.phoneCountryCode
        self.expiryDate = expiryDate
        self.activationDate = activationDate
        self.email = customer.email
        self.eInvoiceDetails = eInvoiceDetails
        self.status = status
        self.type = type
    }
    
}
