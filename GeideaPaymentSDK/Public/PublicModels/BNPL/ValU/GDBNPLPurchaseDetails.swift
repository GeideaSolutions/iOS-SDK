//
//  GDBNPLPurchaseDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 23.02.2022.
//

import Foundation

@objc public class GDBNPLPurchaseDetails: NSObject, Codable {
    public var orderId: String?
    public var bnplOrderId: String?
    public var otp: String?
    public var customerIdentifier: String?
    public var totalAmount: Double?
    public var currency: String?
    public var downPayment: Double?
    public var giftCardAmount: Double?
    public var campaignAmount: Double?
    public var tenure: Int?
    public var adminFees: Double?
    
    @objc public init(customerIdentifier: String?, orderId: String?, bnplOrderId: String?, otp: String?,totalAmount: Double, currency: String?, downPayment: Double, giftCardAmount: Double, campaignAmount: Double, tenure: Int, adminFees: Double) {
        self.customerIdentifier = customerIdentifier
        self.orderId = orderId
        self.bnplOrderId = bnplOrderId
        self.otp = otp
        self.totalAmount = totalAmount
        self.currency = currency
        self.downPayment = downPayment
        self.giftCardAmount = giftCardAmount
        self.campaignAmount = campaignAmount
        self.tenure = tenure
        self.adminFees = adminFees

    }
}
