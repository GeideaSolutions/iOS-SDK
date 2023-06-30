//
//  GDEInvoiceDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.11.2021.
//

import Foundation

@objcMembers public class GDEInvoiceDetails: NSObject, Codable {
    public var collectCustomersBillingShippingAddress: Bool = true
    public var preAuthorizeAmount: Bool = true
    public var subtotal = 0.0
    public var grandTotal = 0.0
    public var extraCharges = 0.0
    public var extraChargesType: String? = "Amount"
    public var chargeDescription: String? = nil
    public var paymentIntentReference: String? = nil
    public var invoiceDiscount = 0.0
    public var invoiceDiscountType: String? = "Amount"
    public var merchantReferenceId: String? = nil
    public var eInvoiceItems: [GDEInvoiceItem]?
    
    @objc public init(collectCustomersBillingShippingAddress: Bool, preAuthorizeAmount: Bool, subTotal: Double, grandTotal: Double, extraCharges: Double,extraChargesType: String?, chargeDescription: String?, paymentIntentReference: String?, invoiceDiscount: Double, invoiceDiscountType: String?, eInvoiceItems: [GDEInvoiceItem]?) {
        self.collectCustomersBillingShippingAddress = collectCustomersBillingShippingAddress
        self.preAuthorizeAmount = preAuthorizeAmount
        self.subtotal = subTotal
        self.grandTotal = grandTotal
        self.extraCharges = extraCharges
        self.extraChargesType = extraChargesType
        self.chargeDescription = chargeDescription
        self.paymentIntentReference = paymentIntentReference
        self.invoiceDiscount = invoiceDiscount
        self.invoiceDiscountType = invoiceDiscountType
        self.eInvoiceItems = eInvoiceItems
    }
}
