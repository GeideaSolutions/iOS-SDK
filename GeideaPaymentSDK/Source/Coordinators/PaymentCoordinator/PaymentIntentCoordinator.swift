//
//  EinvoiceCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 09.11.2021.
//

import Foundation

import UIKit

typealias PaymentIntentCompletionHandler = (GDPaymentIntentResponse?, GDErrorResponse?) -> Void

class PaymentIntentCoordinator: NSObject, Coordinator {
    var navigationController: UIViewController
    var paymentIntentId: String?
    var status: String?
    var type: String?
    var currency: String?
    var completion: PaymentIntentCompletionHandler
    
    init(with navController: UIViewController, paymentIntentId: String?, status: String?, type: String?, currency:String?, completion: @escaping PaymentIntentCompletionHandler) {
        navigationController = navController
        self.paymentIntentId = paymentIntentId
        self.status = status
        self.type = type
        self.currency = currency
        self.completion = completion
        super.init()
    }
    
    func start() {
        
        GeideaPaymentAPI.shared.returnAction = { response, error in
            self.dismissPresentedViewController(true, completion: {
                self.completion(response as? GDPaymentIntentResponse, error)
            })
        }
        
        let vc = PaymentIntentFactory.makePaymentIntentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentIntentFactory.makePaymentIntentViewModel(paymentIntentID: paymentIntentId, status: status, type: type, currency: currency)
        
        present(vc)
    }
}




