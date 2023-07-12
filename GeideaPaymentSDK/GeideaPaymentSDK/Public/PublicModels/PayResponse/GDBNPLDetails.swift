//
//  GDBNPLDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 20.04.2022.
//

import Foundation

@objcMembers public class GDBNPLDetails: NSObject, Codable {
    public var transactionId: String?
    public var bnplDetailId: String?
    public var updatedDate: String?
    public var createdDate: String?
    public var createdBy: String?
    public var updatedBy: String?
    public var provider: String?
    public var bnplOrderId: String?
    public var providerTransactionId: String?
    public var loanNumber: String?
    public var tenure: Int?
    public var currency: String?
    public var totalAmount: Double?
    public var financedAmount: Double?
    public var downPayment: Double?
    public var installmentAmount: Double?
    public var giftCardAmount: Double?
    public var campaignAmount: Double?
    public var adminFees: Double?
    public var interestTotalAmount: Double?
    public var firstInstallmentDate: String?
    public var lastInstallmentDate: String?
    public var providerResponseCode: String?
    public var providerResponseDescription: String?
    public var monthlyInterestRate: Double?
    public var otherFees: Double?
    public var amountToCollect: Double?
    public var token: String?
    
}
