//
//  SouhoolaIPSelectedParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 13.05.2022.
//

import Foundation

struct SouhoolaIPSelectedParams: Codable {
   
    public var orderId: String?
    public var customerIdentifier: String?
    public var customerPin: String?
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
    public var items: [SouhoolaItemParams]?
    public var source: String = Constants.source
    public var language = GlobalConfig.shared.language.name.uppercased()
    public var bnplDetails: GDSouhoolaBNPLDetails?
    public var cashOnDelivery: Bool = false

    init(publicSouhoola: GDSouhoolaInstallmentPlanSelected?) {
        self.orderId = publicSouhoola?.orderId
        self.customerIdentifier = publicSouhoola?.customerIdentifier
        self.customerPin = publicSouhoola?.customerPIN
        self.totalAmount = publicSouhoola?.totalAmount ?? 0
        self.currency = publicSouhoola?.currency
        self.merchantReferenceId = publicSouhoola?.merchantReferenceId
        self.callbackUrl = publicSouhoola?.callbackUrl
        self.billingAddress = publicSouhoola?.billingAddress
        self.shippingAddress = publicSouhoola?.shippingAddress
        self.customerEmail = publicSouhoola?.customerEmail
        self.returnUrl = publicSouhoola?.returnUrl
        self.restrictPaymentMethods = publicSouhoola?.paymentMethods != nil
        self.paymentMethods = publicSouhoola?.paymentMethods
        self.bnplDetails = publicSouhoola?.bnplDetails
        if let ps = publicSouhoola {
            self.cashOnDelivery = ps.cashOnDelivery
        }
        
        var items = [SouhoolaItemParams]()
        if let safeItems = publicSouhoola?.items {
            for item in safeItems {
                items.append(SouhoolaItemParams(item: item))
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
