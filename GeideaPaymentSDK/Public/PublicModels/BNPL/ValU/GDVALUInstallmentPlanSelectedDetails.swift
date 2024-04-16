//
//  GDInstallmentPlanSelected.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.03.2022.
//

import Foundation

@objcMembers public class GDVALUInstallmentPlanSelectedDetails: NSObject, Codable {
    public var customerIdentifier: String?
    public var adminFees = 0.0
    public var totalAmount = 0.0
    public var currency: String?
    public var downPayment = 0.0
    public var giftCardAmount = 0.0
    public var campaignAmount = 0.0
    public var tenure = 0
    public var merchantReferenceId: String?
    public var callbackUrl: String?
    public var billingAddress: GDAddress?
    public var shippingAddress: GDAddress?
    public var customerEmail: String?
    public var orderId: String?
    public var bnplOrderId: String?
    public var restrictPaymentMethods: Bool
    public var paymentMethods: [String]?
    public var cashOnDelivery:Bool
    public var source: String = Constants.source
    public var language = GlobalConfig.shared.language.name.uppercased()
    
    
    @objc public init(customerIdentifier: String?,totalAmount: Double, currency: String?, adminFees: Double, downPayment: Double, giftCardAmount: Double, campaignAmount: Double, tenure: Int, merchantReferenceId: String? = nil, callbackUrl: String? = nil, billingAddress: GDAddress? = nil, shippingAddress: GDAddress? = nil, customerEmail: String? = nil, orderId: String?, bnplOrderId: String?, cashOnDelivery: Bool, restrictPaymentMethods: Bool, paymentMethods: [String]?) {
        self.customerIdentifier = customerIdentifier
        self.adminFees = adminFees
        self.totalAmount = totalAmount
        self.currency = currency
        self.downPayment = downPayment
        self.giftCardAmount = giftCardAmount
        self.campaignAmount = campaignAmount
        self.tenure = tenure
        self.merchantReferenceId = merchantReferenceId
        self.callbackUrl = callbackUrl
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.customerEmail = customerEmail
        self.orderId = orderId
        self.bnplOrderId = bnplOrderId
        self.cashOnDelivery = cashOnDelivery
        self.restrictPaymentMethods = restrictPaymentMethods
        self.paymentMethods = paymentMethods

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
