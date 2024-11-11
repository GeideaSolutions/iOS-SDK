//
//  HppCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by Virender on 12/06/24.
//

import Foundation
import UIKit
typealias HppCompletionHandler = (PaymentResponse?, GDErrorResponse?) -> Void
class HppCoordinator: NSObject, Coordinator {
    
    var navigationController: UIViewController
    var authParams: InitiateAuthenticateParams
    var completion: HppCompletionHandler
    
    init(viewController: UIViewController, authParams: InitiateAuthenticateParams, completion: @escaping HppCompletionHandler) {
        
        self.navigationController = viewController
        self.authParams = authParams
        self.completion = completion
        super.init()
    }
    
    func start() {
        GeideaPaymentAPI.shared.returnAction = { orderResponse, error in
            if self.navigationController is UINavigationController {
                self.pop()
                self.completion(orderResponse as? PaymentResponse, error)
            } else {
                self.dismissPresentedViewController(true, completion: {
                    self.completion(orderResponse as? PaymentResponse, error)
                })
            }
        }
        
        let isNavController =  navigationController is UINavigationController
        let vc = PaymentFactory.makeHppViewController(authParams: authParams)
        vc.modalPresentationStyle = .fullScreen
        if isNavController {
            push(vc)
        }else {
            present(vc)
        }
    }
}
