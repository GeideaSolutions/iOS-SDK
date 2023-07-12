//
//  GDReviewTransaction.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 09.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaReviewTransaction: NSObject, Codable {

    public var customerIdentifier: String?
    public var customerPin: String?
    public var totalAmount = 0.0
    public var currency: String?
    public var downPayment = 0.0
    public var tenure = 0
    public var minimumDownPaymentTenure = 0.0
    public var promoCode: String?
    public var approvedLimit = 0.0
    public var outstanding = 0.0
    public var availableLimit = 0.0
    public var minLoanAmount = 0.0
    public var items: [GDBNPLItem]?
    


    
    @objc public init(customerIdentifier: String?,customerPin: String?, totalAmount: Double, currency: String?, tenure: Int, downPayment: Double, minimumDownPaymentTenure: Double, promoCode: String?, approvedLimit: Double, outstanding: Double, availableLimit: Double, minLoanAmount: Double, items: [GDBNPLItem]?) {
        self.customerIdentifier = customerIdentifier
        self.customerPin = customerPin
        self.totalAmount = totalAmount
        self.currency = currency
        self.downPayment = downPayment
        self.tenure = tenure
        self.minimumDownPaymentTenure = minimumDownPaymentTenure
        self.promoCode = promoCode
        self.approvedLimit = approvedLimit
        self.outstanding = outstanding
        self.availableLimit = availableLimit
        self.minLoanAmount = minLoanAmount
        self.items = items
        
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
