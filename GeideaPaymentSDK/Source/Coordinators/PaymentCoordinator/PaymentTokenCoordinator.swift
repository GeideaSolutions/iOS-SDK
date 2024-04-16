//
//  PaymentTokenCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/12/2020.
//

import Foundation
import UIKit
import PassKit

typealias PayTokenCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void

class PayTokenCoordinator: NSObject, Coordinator {
    var navigationController: UIViewController
    var payTokenParams: PayTokenParams
    var config: GDConfigResponse?
    var showReceipt: Bool
    var completion: PayCompletionHandler
    var cvv: String?
    var isNavController = false
    
    init(with navController: UIViewController, payTokenParams: PayTokenParams, config: GDConfigResponse?, showReceipt: Bool, completion: @escaping PayTokenCompletionHandler ) {
        navigationController = navController
        self.payTokenParams = payTokenParams
        self.config = config
        self.completion = completion
        self.showReceipt = showReceipt
        super.init()
    }
    
    func start() {
        isNavController =  navigationController is UINavigationController
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
        
        if config?.isCvvRequiredForTokenPayments ?? false && config?.useMpgsApiV60 ?? false {
            PayTokenManager().getToken(with: payTokenParams.tokenId, completion: { response, error in
                
                if let res = response {
                    let cvvVC = PaymentFactory.makeCVVViewController()
                    cvvVC.viewModel = CVVViewModel(tokenResponse: res, config: self.config, isNavController: false, completion: {response in
                        
                        if let res = response {
                            self.dismissPresentedViewController()
                            self.payTokenParams.cvv = res
                            self.startTokenPayment()
                        }
                    })
                    
                    self.present(cvvVC)
                }
            })
        } else {
            startTokenPayment()
        }
        
    }
    
    func startTokenPayment() {
                let vc = PaymentFactory.makePaymentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentFactory.makePaymentTokenViewModel(payTokenParams: payTokenParams, config: config, showReceipt: showReceipt, isNavController: isNavController)
                if let vm = vc.viewModel as? PaymentTokenViewModel {
                    vm.action = { (payTokenParams, autheticateResponse) in
        
                        if self.config?.is3dsRequiredForTokenPayments ?? false {
                            vm.flowType = .webview
                            self.openWebView(forTokenParams: payTokenParams, authenticateResponse: autheticateResponse, paymentVC: vc)
                        } else {
                            vm.flowType = .pay
                        }
        
                    }
        
                    if isNavController {
                        push(vc)
                    }else {
                        present(vc)
                    }
        
                    if config?.useMpgsApiV60 ?? false && config?.is3dsRequiredForTokenPayments ?? false {
                        vm.flowType = .initiatePayment
                    } else {
                        vm.flowType = .pay
                    }
                }
    }
    
    private func openWebView(forTokenParams payTokenParam: PayTokenParams, authenticateResponse: AuthenticateResponse, paymentVC: PaymentViewController) {
        let vc = PaymentFactory.makeWebViewViewController()
        vc.modalPresentationStyle = .fullScreen
        
        vc.viewModel = PaymentFactory.makeWebViewModel(payTokenParams: payTokenParam, authenticateResponse: authenticateResponse)
        vc.payTokenAction = { payTokenParam, authenticateResponse, error  in
            if error != nil {
                
                if paymentVC.viewModel.showReceipt {
                    paymentVC.showReceipt(order: nil, error: error)
                } else {
                    GeideaPaymentAPI.shared.returnAction(nil, error)
                }
                return
            }
            if let vm = paymentVC.viewModel as? PaymentTokenViewModel {
                vm.authenticateResponse = authenticateResponse
                vm.flowType = .pay
            }

        }
        paymentVC.loadWebView(vc: vc)
    }
}
