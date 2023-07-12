//
//  GDSouhoolaBNPLDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaBNPLDetails: NSObject, Codable {
    
    public var souhoolaTransactionId: String?
    public var totalInvoicePrice: Double?
    public var downPayment: Double?
    public var loanAmount: Double?
    public var netAdminFees: Double?
    public var mainAdminFees: Double?
    public var tenure: Int?
    public var annualRate: Double?
    public var firstInstallmentDate: String?
    public var lastInstallmentDate: String?
    public var installmentAmount: Double?
    
    @objc public init(souhoolaTransactionId: String?,totalInvoicePrice: Double, downPayment: Double, loanAmount: Double, netAdminFees: Double, mainAdminFees: Double, tenure: Int, annualRate: Double, firstInstallmentDate: String?, lastInstallmentDate: String?, installmentAmount: Double = 0) {
        self.souhoolaTransactionId = souhoolaTransactionId
        self.totalInvoicePrice = totalInvoicePrice
        self.downPayment = downPayment
        self.loanAmount = loanAmount
        self.netAdminFees = netAdminFees
        self.mainAdminFees = mainAdminFees
        self.tenure = tenure
        self.annualRate = annualRate
        self.firstInstallmentDate = firstInstallmentDate
        self.lastInstallmentDate = lastInstallmentDate
        self.installmentAmount = installmentAmount

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
