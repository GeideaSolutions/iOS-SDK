//
//  PaymentCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12/10/2020.
//

import Foundation
import UIKit

typealias PayCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
typealias RTPCompletionHandler = (GDRTPQRResponse?, GDErrorResponse?) -> Void
typealias CancelCompletionHandler = (GDCancelResponse?, GDErrorResponse?) -> Void

class PaymentCoordinator: NSObject, Coordinator {
    var navigationController: UIViewController
    var authenticateParams: AuthenticateParams
    var config: GDConfigResponse?
    var isHPP: Bool
    var showReceipt: Bool
    var initializeResponse: GDInitiateAuthenticateResponse? = nil
    
    var completion: PayCompletionHandler
    var dismissAction: CancelCompletionHandler?
    
    init(with navController: UIViewController, authenticateParams: AuthenticateParams, config: GDConfigResponse?, showReceipt: Bool, initializeResponse: GDInitiateAuthenticateResponse? = nil,  isHPP:Bool  = false,completion: @escaping PayCompletionHandler) {
        navigationController = navController
        self.authenticateParams = authenticateParams
        self.config = config
        self.isHPP = isHPP
        self.showReceipt = showReceipt
        self.initializeResponse = initializeResponse
        self.completion = completion
        super.init()
    }
    
    func start() {
        GeideaPaymentAPI.shared.returnAction = { orderResponse, error in
            if self.navigationController is UINavigationController {
                self.pop()
                self.completion(orderResponse as? GDOrderResponse, error)
            } else {
                self.dismissPresentedViewController(true, completion: {
                    self.completion(orderResponse as? GDOrderResponse, error)
                })
            }
        }
        let isNavController =  navigationController is UINavigationController
        let viewModel  = PaymentFactory.makePaymentViewModel(authenticateParams: authenticateParams, initializeResponse: initializeResponse, isHpp: isHPP, isNavController: isNavController, config: config, showReceipt: showReceipt)
        viewModel.sessionId = authenticateParams.sessionId
        if(authenticateParams.sessionId.isEmpty) {
            viewModel.generateSession {error in
                if(error == nil) {
                    self.loadVC(viewModel: viewModel);
                } else {
                    GeideaPaymentAPI.shared.returnAction(nil, error)
                }
            }
        } else {
            self.loadVC(viewModel: viewModel);
        }
    }
    
    private func loadVC(viewModel: PaymentViewModel) {
        let isNavController =  navigationController is UINavigationController
        let vc = PaymentFactory.makePaymentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = viewModel
        vc.viewModel.dismissAction = dismissAction
        if let vm = vc.viewModel as? PaymentViewModel {
            vm.authenticateAction = { (authenticateParams, authenticateResponse) in
                vm.flowType = .webview
                self.openWebView(forAuthenticateParams: authenticateParams, authenticateResponse: authenticateResponse, paymentVC: vc)
            }
            
            if isNavController {
                push(vc)
            }else {
                present(vc)
            }
            if config?.useMpgsApiV60 ?? false {
                vm.flowType = .authenticatePayer
            } else {
                vm.flowType = .authenticate
            }
        }
    }
    
    private func openWebView(forAuthenticateParams authParams: AuthenticateParams, authenticateResponse: AuthenticateResponse, paymentVC: PaymentViewController) {
        let vc = PaymentFactory.makeWebViewViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentFactory.makeWebViewModel(authenticateParams: authParams, authenticateResponse: authenticateResponse)
        vc.payAction = { authenticateParams, authenticateResponse, error  in
            if error != nil {
                
                if paymentVC.viewModel.showReceipt {
                    paymentVC.showReceipt(order: nil, error: error)
                } else {
                    GeideaPaymentAPI.shared.returnAction(nil, error)
                }
                
                return
            }
            if let vm = paymentVC.viewModel as? PaymentViewModel {
                vm.authenticateResponse = authenticateResponse
                vm.flowType = .pay
            }
            
        }
        paymentVC.loadWebView(vc: vc)
    }
    
}
