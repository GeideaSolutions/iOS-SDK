//
//  GDShahrySelectPlanInstallment.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 08.04.2022.
//

import Foundation

@objcMembers public class GDShahrySelectPlanInstallment: NSObject, Codable {
    public var customerIdentifier: String?
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
    public var items: [GDBNPLItem]?
    public var orderId: String?
    
    @objc public init(customerIdentifier: String?,totalAmount: Double, currency: String?, merchantReferenceId: String? = nil, callbackUrl: String? = nil, billingAddress: GDAddress? = nil, shippingAddress: GDAddress? = nil, customerEmail: String? = nil, restrictPaymentMethods: Bool, paymentMethods: [String]?, items: [GDBNPLItem]?, orderId: String?) {
        
        self.orderId = orderId
        self.customerIdentifier = customerIdentifier
        self.totalAmount = totalAmount
        self.currency = currency
        self.merchantReferenceId = merchantReferenceId
        self.callbackUrl = callbackUrl
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.customerEmail = customerEmail
        self.restrictPaymentMethods = restrictPaymentMethods
        self.paymentMethods = paymentMethods
        if let safeItems = items {
            safeItems.indices.forEach { safeItems[$0].currency = currency }
            self.items = safeItems
        }
      

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
