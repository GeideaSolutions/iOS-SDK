//
//  PaymentFormCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 11.08.2021.
//

import Foundation
import UIKit

typealias PaymentFormCompletionHandler = (GDOrderResponse? ,GDErrorResponse?) -> Void

class PaymentFormCoordinator: NSObject, Coordinator {
    var navigationController: UIViewController
    var amount: GDAmount
    var showAdress: Bool
    var showEmail: Bool
    var showReceipt: Bool
    var tokenizationDetails: GDTokenizationDetails?
    var applePayDetails: GDApplePayDetails?
    var customerDetails: GDCustomerDetails?
    var config: GDConfigResponse?
    var paymentIntentId: String?
    var qrCustomerDetails: GDPICustomer?
    var qrExpiryDate: String?
    var paymentMethods: [String]?
    var completion: PaymentFormCompletionHandler
    
    init(with amount: GDAmount, showAddress: Bool, showEmail: Bool, showReceipt: Bool, andTokenizationDetails tokenizationDetails: GDTokenizationDetails?, andCustomerDetails customerDetails: GDCustomerDetails?, andApplePayDetails applePayDetails: GDApplePayDetails?, andConfig config: GDConfigResponse?, paymentIntentId: String?, qrCustomerDetails: GDPICustomer?, qrExpiryDate: String?, paymentMethods: [String]?, viewController: UIViewController, completion: @escaping PaymentFormCompletionHandler ) {
        navigationController = viewController
        self.amount = amount
        self.customerDetails = customerDetails
        self.config = config
        self.applePayDetails = applePayDetails
        self.tokenizationDetails = tokenizationDetails
        self.completion = completion
        self.showAdress = showAddress
        self.showEmail = showEmail
        self.showReceipt = showReceipt
        self.paymentIntentId = paymentIntentId
        self.qrExpiryDate = qrExpiryDate
        self.qrCustomerDetails = qrCustomerDetails
        self.paymentMethods = paymentMethods
        super.init()
    }
    
    func start() {
        
        GeideaPaymentAPI.shared.returnAction = { orderResponse, error in
            self.dismissPresentedViewController(true, completion: {
                self.completion(orderResponse as? GDOrderResponse, error)
            })
        }
        
            let vc = PaymentFactory.makeCardDetailsFormViewController()
            vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentFactory.makeCardDetailsFormViewModel(amount: amount, showAdress: showAdress, showEmail: showEmail, showReceipt: showReceipt, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePay: nil, config: config, paymentIntentId: paymentIntentId, paymentMethods: paymentMethods, isNavController: false, completion: completion)
        present(vc)
        
    }
    
}
