//
//  GDSouhoolaInstallmentPlanSelected.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.05.2022.
//

import Foundation

@objcMembers public class GDSouhoolaInstallmentPlanSelected: NSObject, Codable {
    public var customerIdentifier: String?
    public var customerPIN: String?
    public var totalAmount = 0.0
    public var currency: String?
    public var merchantReferenceId: String?
    public var callbackUrl: String?
    public var billingAddress: GDAddress?
    public var shippingAddress: GDAddress?
    public var customerEmail: String?
    public var returnUrl: String?
    public var restrictPaymentMethods: Bool
    public var paymentMethods: [String]?
    public var source: String = Constants.source
    public var items: [GDBNPLItem]?
    public var bnplDetails: GDSouhoolaBNPLDetails?
    public var cashOnDelivery: Bool = false
    public var orderId: String?
    
    @objc public init(customerIdentifier: String?, customerPIN: String?,totalAmount: Double, currency: String?, merchantReferenceId: String? = nil, callbackUrl: String? = nil, billingAddress: GDAddress? = nil, shippingAddress: GDAddress? = nil, customerEmail: String? = nil, restrictPaymentMethods: Bool, paymentMethods: [String]?, items: [GDBNPLItem]?, bnplDetails: GDSouhoolaBNPLDetails?, cashOnDelivery: Bool, orderId: String?) {
        self.customerIdentifier = customerIdentifier
        self.customerPIN = customerPIN
        self.totalAmount = totalAmount
        self.currency = currency
        self.merchantReferenceId = merchantReferenceId
        self.callbackUrl = callbackUrl
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.customerEmail = customerEmail
        self.restrictPaymentMethods = restrictPaymentMethods
        self.paymentMethods = paymentMethods
        self.items = items
        self.bnplDetails = bnplDetails
        self.cashOnDelivery = cashOnDelivery
        self.orderId = orderId
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
