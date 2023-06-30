//
//  GDApplePayParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 07/01/2021.
//

import Foundation
import UIKit
import PassKit

@objc public class GDApplePayDetails: NSObject {
    
    var merchantIdentifier: String
    var buttonView: UIView?
    var hostViewController: UIViewController?
    var callBackUrl: String?
    var merchantRefId: String?
    var paymentMethods: [String]?
    var merchantDisplayName: String?
    var requiredBillingContactFields: Set<PKContactField>?
    var requiredShippingContactFields: Set<PKContactField>?
    
    
    @objc public init(in hostViewController: UIViewController? = nil, andButtonIn buttonView: UIView? = nil, forMerchantIdentifier merchantIdentifier: String, andMerchantDisplayName merchantDisplayName: String? = nil, requiredBillingContactFields: Set<PKContactField>? = nil, requiredShippingContactFields: Set<PKContactField>? = nil, paymentMethods:[String]?, withCallbackUrl callBackUrl: String?, andReferenceId merchantRefId: String?) {
        self.merchantIdentifier = merchantIdentifier
        self.hostViewController = hostViewController
        self.buttonView = buttonView
        self.callBackUrl = callBackUrl
        self.merchantRefId = merchantRefId
        self.paymentMethods = paymentMethods
        self.merchantDisplayName = merchantDisplayName
        self.requiredBillingContactFields = requiredBillingContactFields
        self.requiredShippingContactFields = requiredShippingContactFields
    }
}

