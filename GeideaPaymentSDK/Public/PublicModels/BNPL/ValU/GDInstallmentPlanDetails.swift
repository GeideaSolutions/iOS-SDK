//
//  GDInstallmenrPlan.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

@objc public class GDInstallmentPlanDetails: NSObject {
    
    public var customerIdentifier: String?
    public var totalAmount = 0.0
    public var adminFees = 0.0
    public var currency: String?
    public var downPayment = 0.0
    public var giftCardAmount = 0.0
    public var campaignAmount = 0.0
    
    @objc public init(customerIdentifier: String?, totalAmount: Double, currency: String?, downPayment: Double, giftCardAmount: Double, campaignAmount: Double, adminFees: Double) {
        self.customerIdentifier = customerIdentifier
        self.totalAmount = totalAmount
        self.currency = currency
        self.downPayment = downPayment
        self.giftCardAmount = giftCardAmount
        self.campaignAmount = campaignAmount
        self.adminFees = adminFees

    }
}
