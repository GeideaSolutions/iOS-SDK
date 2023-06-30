//
//  SouhoolaInstallmentPlan.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 03.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaInstallmentPlan: NSObject, Codable {

    public var tenorMonth = 0
    public var installmentAmount = 0.0
    public var adminFees: Double?
    public var downPayment: Double?
    public var minDownPayment: Double?
    public var rate: String?
    public var promoCode: String?
    public var downPaymentPromo: Bool = false
    public var adminFeesPromo: Bool = false
    public var interestPromo: Bool = false
}
