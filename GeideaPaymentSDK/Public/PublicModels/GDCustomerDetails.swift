//
//  GDCustomerDetails.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 22/10/2020.
//

import Foundation

@objc public class GDCustomerDetails: NSObject {
    
    var customerEmail: String?
    var callbackUrl: String?
    var merchantReferenceId: String?
    var shippingAddress: GDAddress?
    var billingAddress: GDAddress?
    var paymentOperation: PaymentOperation? = nil

    @objc public override init() {}
    
    @objc public init(withEmail email: String?, andCallbackUrl callbackUrl: String? = nil, merchantReferenceId: String? = nil, shippingAddress: GDAddress? = nil, billingAddress: GDAddress? = nil, paymentOperation: PaymentOperation = .NONE) {
        
        if let safeEmail = email, safeEmail.isEmpty {
            self.customerEmail = nil
        } else {
            self.customerEmail = email
        }
        if let safeCallbackUrl = callbackUrl, safeCallbackUrl.isEmpty {
            self.callbackUrl = nil
        } else {
            self.callbackUrl = callbackUrl
        }
        if let safeMerchantReferenceId = merchantReferenceId, safeMerchantReferenceId.isEmpty {
            self.merchantReferenceId = nil
        } else {
            self.merchantReferenceId = merchantReferenceId
        }
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.paymentOperation = paymentOperation
    }
}
