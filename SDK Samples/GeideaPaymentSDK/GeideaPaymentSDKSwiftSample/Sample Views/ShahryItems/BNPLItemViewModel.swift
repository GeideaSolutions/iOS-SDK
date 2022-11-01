//
//  ShahryItemViewModel.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Eugen Vidolman on 13.04.2022.
//

import Foundation
import GeideaPaymentSDK


typealias FormCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void

class BNPLItemViewModel {
    public var amount: GDAmount
    public var customerDetails: GDCustomerDetails?
    public var config: GDConfigResponse?
    public var applePay: GDApplePayDetails?
    public var tokenizationDetails: GDTokenizationDetails?
    public var paymentIntentId: String?
    public var qrCustomerDetails: GDQRDetails?
    public var paymentMethods: [String]?
    public var showAddress: Bool
    public var showEmail: Bool
    public var showReceipt: Bool
    public var showQRCode: Bool = false
    public var showValu: Bool = true
    public var showShahry: Bool = true
    public var showApplePay: Bool = false
    public var showCard: Bool = false
    public var paymentSelectionMethods: [GDPaymentSelectionMetods]?
    public var completion: FormCompletionHandler
    
    init(amount: GDAmount, showAddress: Bool, showEmail: Bool, showReceipt: Bool,customerDetails: GDCustomerDetails?, tokenizationDetails: GDTokenizationDetails?, applePayDetails: GDApplePayDetails?, config: GDConfigResponse?, paymentIntent: String?,  qrCustomerDetails: GDQRDetails?, paymentMethods: [String]?, paymentSelectionMethods: [GDPaymentSelectionMetods]?, isNavController: Bool, completion: @escaping FormCompletionHandler) {
        self.amount = amount
        self.applePay = applePayDetails
        self.customerDetails = customerDetails
        self.config = config
        self.tokenizationDetails = tokenizationDetails
        self.showAddress = showAddress
        self.showEmail = showEmail
        self.showReceipt = showReceipt
        self.paymentIntentId = paymentIntent
        self.qrCustomerDetails = qrCustomerDetails
        self.paymentMethods = paymentMethods
        self.paymentSelectionMethods = paymentSelectionMethods
        self.completion = completion
        
    }

}
