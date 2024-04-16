//
//  CaptureCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/12/2020.
//

import Foundation
import UIKit

typealias CaptureCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void

class OperationCoordinator: NSObject, Coordinator {
    var navigationController: UIViewController
    var orderId: String
    var callbackURL: String?
    var operation: Operation
    var completion: PayCompletionHandler
    
    init(with navController: UIViewController, orderId: String, callbackURL: String?, operation: Operation, completion: @escaping CaptureCompletionHandler ) {
        navigationController = navController
        self.orderId = orderId
        self.callbackURL = callbackURL
        self.operation = operation
        self.completion = completion
        super.init()
    }
    
    func start() {
        let isNavController =  navigationController is UINavigationController
        GeideaPaymentAPI.shared.returnAction = { orderResponse, error in
            if self.navigationController is UINavigationController {
                self.pop()
                self.completion(orderResponse as? GDOrderResponse, error)
            }else {
                self.dismissPresentedViewController(true, completion: {
                    self.completion(orderResponse as? GDOrderResponse, error)
                })
            }
        }
        
        let vc = PaymentFactory.makePaymentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentFactory.makeOperationViewModel(orderId: orderId, callbackURL: callbackURL, operation: operation, isNavController: isNavController)
        
        if isNavController {
            push(vc)
        }else {
            present(vc)
        }
    }
}
