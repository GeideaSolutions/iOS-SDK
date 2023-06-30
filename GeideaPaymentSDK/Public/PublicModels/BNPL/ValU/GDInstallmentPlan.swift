//
//  GDInstallmentPlan.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 17.02.2022.
//

import Foundation

@objcMembers public class GDInstallmentPlan: NSObject, Codable {

    public var tenorMonth = 0
    public var installmentAmount = 0.0
    public var adminFees = 0.0
    public var downPayment = 0.0
    
    // MARK: - Just for Souhoola BNPL
    public var minDownPayment: Double?
    public var rate: String?
    public var promoCode: String?
    public var downPaymentPromo: Bool? = false
    public var adminFeesPromo: Bool? = false
    public var interestPromo: Bool? = false
    
}
