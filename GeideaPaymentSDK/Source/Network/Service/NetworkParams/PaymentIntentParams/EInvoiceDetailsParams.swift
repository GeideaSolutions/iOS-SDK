//
//  EInvoiceDetailsParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 10.11.2021.
//

import Foundation

struct EInvoiceDetailsParams: Codable {
    var collectCustomersBillingShippingAddress: Bool = true
    var preAuthorizeAmount: Bool = true
    var subtotal = 0.0
    var grandTotal = 0.0
    var extraCharges = 0.0
    var extraChargesType: String? = "Amount"
    var chargeDescription: String? = nil
    var paymentIntentReference: String? = nil
    var invoiceDiscount = 0.0
    var invoiceDiscountType: String? = "Amount"
    var eInvoiceItems: [GDEInvoiceItem]?
    

    init(eInvoiceDetails: GDEInvoiceDetails) {
        self.collectCustomersBillingShippingAddress = eInvoiceDetails.collectCustomersBillingShippingAddress
        self.preAuthorizeAmount = eInvoiceDetails.preAuthorizeAmount
        self.subtotal = eInvoiceDetails.subtotal
        self.grandTotal = eInvoiceDetails.grandTotal
        self.extraCharges = eInvoiceDetails.extraCharges
        self.invoiceDiscount = eInvoiceDetails.invoiceDiscount
        self.eInvoiceItems = eInvoiceDetails.eInvoiceItems

        if let extraChargesType = eInvoiceDetails.extraChargesType, extraChargesType.isEmpty {
            self.extraChargesType = nil
        } else {
            self.extraChargesType = eInvoiceDetails.extraChargesType
        }

        if let chargeDescription = eInvoiceDetails.chargeDescription, chargeDescription.isEmpty {
            self.chargeDescription = nil
        } else {
            self.chargeDescription = eInvoiceDetails.chargeDescription
        }

        if let paymentIntentReference = eInvoiceDetails.paymentIntentReference, paymentIntentReference.isEmpty {
            self.paymentIntentReference = nil
        } else {
            self.paymentIntentReference = eInvoiceDetails.paymentIntentReference
        }

        if let status = eInvoiceDetails.invoiceDiscountType, status.isEmpty {
            self.invoiceDiscountType = nil
        } else {
            self.invoiceDiscountType = eInvoiceDetails.invoiceDiscountType
        }

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

