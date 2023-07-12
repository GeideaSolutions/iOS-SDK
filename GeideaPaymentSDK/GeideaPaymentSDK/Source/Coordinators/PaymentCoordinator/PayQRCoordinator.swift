//
//  PayQRCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 15.07.2021.
//

import Foundation
import UIKit

class PayQRCoordinator: NSObject, Coordinator {
    
    var navigationController: UIViewController
    var amount: GDAmount
    var config: GDConfigResponse?
    var showReceipt: Bool
    var merchantName:String?
    var callbackUrl:String?
    var qrDetails: GDQRDetails?
    var orderId: String?
    var completion: PayCompletionHandler
    
    init(with amount: GDAmount, andQRDetials qrDetails: GDQRDetails?, config: GDConfigResponse?, orderId: String?, callbackUrl: String?,showReceipt: Bool, viewController: UIViewController, completion: @escaping PayCompletionHandler) {
        
        self.navigationController = viewController
        self.amount = amount
        self.qrDetails = qrDetails
        self.showReceipt = showReceipt
        self.config = config
        self.orderId = orderId
        self.callbackUrl = callbackUrl
        self.completion = completion
        super.init()
    }
    
    func start() {
        
        let vc = PaymentFactory.makeQRPaymentFormViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentFactory.makeQRPaymentFormViewModel(amount: amount, customerDetails: GDPICustomer(phoneNumber: qrDetails?.phoneNumber, andPhoneCountryCode: qrDetails?.phoneCountryCode), config: config, expiryDate: qrDetails?.qrExpiryDate, orderId:  orderId, callbackUrl: callbackUrl, showReceipt: showReceipt, isNavController: false, completion: completion)
        
        present(vc)
        
    }
}
