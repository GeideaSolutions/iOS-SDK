//
//  GDPaymentIntentDetailsResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 19/02/2021.
//

import Foundation

@objcMembers public class GDPaymentIntentDetailsResponse: NSObject, Codable {
    public var customer: GDPaymentIntentCustomer?
    public var link: String?
    public var merchantId: String?
    public var amount: Double?
    public var createdDate: String?
    public var updatedDate: String?
    public var type: String?
    public var expiryDate: String?
    public var activationDate: String?
    public var createdBy: String?
    public var merchantName: String?
    public var orders: [GDPaymentIntentOrder]?
    public var isPending: Bool
    public var number: String? = nil
    public var eInvoiceDetails: GDEInvoiceDetails?
    public var eInvoiceSentLinks: [GDEInvoiceSentLink]?
    public var updatedBy: String?
    public var paymentIntentId: String?
    public var currency : String?
    public var status: String?
    public var merchantPublicKey: String?
    

}
