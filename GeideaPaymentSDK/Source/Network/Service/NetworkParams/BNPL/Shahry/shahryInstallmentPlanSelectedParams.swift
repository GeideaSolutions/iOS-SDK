//
//  ShahryInstallmentPlanSelectedParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 14.04.2022.
//

import Foundation

struct shahryInstallmentPlanSelectedParams: Codable {

    public var orderId: String?
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
    public var items: [ShahryItemParams]?
    public var source: String = Constants.source
    public var language = GlobalConfig.shared.language.name.uppercased()

    init(publicShahry: GDShahrySelectPlanInstallment?) {
        
        self.orderId = publicShahry?.orderId
        self.customerIdentifier = publicShahry?.customerIdentifier
        self.totalAmount = publicShahry?.totalAmount ?? 0.0
        self.currency = publicShahry?.currency
        self.merchantReferenceId = publicShahry?.merchantReferenceId
        self.callbackUrl = publicShahry?.callbackUrl
        self.billingAddress = publicShahry?.billingAddress
        self.shippingAddress = publicShahry?.shippingAddress
        self.customerEmail = publicShahry?.customerEmail
        self.returnUrl = publicShahry?.returnUrl
        if let safeRestrictPM = publicShahry?.restrictPaymentMethods {
            self.restrictPaymentMethods = safeRestrictPM
        } else  {
            self.restrictPaymentMethods = false
        }
        self.paymentMethods = publicShahry?.paymentMethods
        var items = [ShahryItemParams]()
        if let shahryItems =  publicShahry?.items {
            for item in shahryItems {
                items.append(ShahryItemParams(item: item))
            }
            self.items = items
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
