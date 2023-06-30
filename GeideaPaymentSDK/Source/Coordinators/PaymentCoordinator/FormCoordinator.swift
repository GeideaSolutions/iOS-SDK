//
//  FormCoordinator.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 06/01/2021.
//

import Foundation
import UIKit

typealias FormCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
typealias NextHandler = (PaymentType?, UIViewController?) -> Void

class FormCoordinator: NSObject, Coordinator {
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
    var bnplItems: [GDBNPLItem]?
    var paymentSelectionMethods: [GDPaymentSelectionMetods]?
    var completion: FormCompletionHandler
    
    var selectPaymentVM: SelectPaymentMethodViewModel!
    
    init(with amount: GDAmount, showAddress: Bool, showEmail: Bool, showReceipt: Bool, andTokenizationDetails tokenizationDetails: GDTokenizationDetails?, andCustomerDetails customerDetails: GDCustomerDetails?, andApplePayDetails applePayDetails: GDApplePayDetails?, andConfig config: GDConfigResponse?, paymentIntentId: String?, qrCustomerDetails: GDPICustomer?, qrExpiryDate: String?, shahryItems: [GDBNPLItem]?, cardPaymentMethods: [String]?, paymentSelectionMethods: [GDPaymentSelectionMetods]?, viewController: UIViewController, completion: @escaping FormCompletionHandler) {
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
        self.paymentMethods = cardPaymentMethods
        self.paymentSelectionMethods = paymentSelectionMethods
        self.bnplItems = shahryItems
        super.init()
    }
    
    func start() {
        
        GeideaPaymentAPI.shared.returnAction = { orderResponse, error in
            self.dismissPresentedViewController(true, completion: {
                self.completion(orderResponse as? GDOrderResponse, error)
            })
        }
        
        if let pm = paymentMethods {
            self.applePayDetails?.paymentMethods = pm
            if pm.contains("meezaDigital".lowercased()) && config?.isMeezaQrEnabled ?? false {
                if pm.count == 1 {
                    payQRWithGeideaForm()
                } else {
                    payWithSelectionForm()
                }
            } else if ( pm.contains("valU".lowercased()) && config?.isValuBnplEnabled ?? false) || ( pm.contains("shahry".lowercased()) && config?.isShahryCnpBnplEnabled ?? false) ||  ( pm.contains("souhoola".lowercased()) && config?.isSouhoolaCnpBnplEnabled ?? false)  {
                payWithSelectionForm()
            } else if config?.applePay?.isApplePayMobileEnabled ?? false && config?.applePay?.isApplePayMobileCertificateAvailable ?? false {
                payWithSelectionForm()
            } else {
                payWithGeideaForm()
            }
        } else {
            
            let pmAvailable: Bool = !(config?.paymentMethods?.isEmpty ?? true)
            let meezaEnabled = config?.isMeezaQrEnabled ?? false
            let valuEnabled = config?.isValuBnplEnabled ?? false
            let shahryEnabled = config?.isShahryCnpBnplEnabled ?? false
            let souhoolaEnabled = config?.isSouhoolaCnpBnplEnabled ?? false
            let applePayEnabled = config?.applePay?.isApplePayMobileEnabled ?? false && config?.applePay?.isApplePayMobileCertificateAvailable ?? false
            
            if pmAvailable && !meezaEnabled && !applePayEnabled && !valuEnabled && !shahryEnabled && !souhoolaEnabled{
                payWithGeideaForm()
            } else if pmAvailable && meezaEnabled && !applePayEnabled && valuEnabled && shahryEnabled && souhoolaEnabled{
                payWithGeideaForm()
            } else if meezaEnabled && !pmAvailable && !applePayEnabled && !valuEnabled && !shahryEnabled {
                payQRWithGeideaForm()
            } else  {
                payWithSelectionForm()
            }
            
        }
        
        
    }
    
    func payWithSelectionForm() {
        let vc = PaymentFactory.makePaymentSelectionFormViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = PaymentFactory.makePaymentSelectionFormViewModel(amount: amount, showAdress: showAdress, showEmail: showEmail, showReceipt: showReceipt, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePay: applePayDetails, config: config, paymentIntentId: paymentIntentId, qrCustomerDetails: qrCustomerDetails, qrExpiryDate: qrExpiryDate, shahryItems: bnplItems, paymentMethods: paymentMethods, paymentSelectionMethods: paymentSelectionMethods,  isNavController: false, completion: completion, nextAction: { action, navControlller  in
            
            self.selectPaymentVM = vc.viewModel
            
            if let  safeNavControlller = navControlller {
                self.navigationController = safeNavControlller
            }
            
            
            if let pm = self.paymentMethods, pm.isEmpty {
                
                self.paymentMethods = self.config?.paymentMethods
                
            }
            
            switch action {
            case .Card:
                
                if !self.navigationController.isKind(of: UINavigationController.self) {
                    vc.dismiss(animated: false, completion: nil)
                }
                self.payWithGeideaForm()
            case .QR:
                if !self.navigationController.isKind(of: UINavigationController.self) {
                    vc.dismiss(animated: false, completion: nil)
                }
                self.payQRWithGeideaForm()
            case .ValU:
                if self.amount.amount >=  Double(self.config?.valUMinimumAmount ?? 0) {
                    if !self.navigationController.isKind(of: UINavigationController.self) {
                        vc.dismiss(animated: false, completion: nil)
                    }
                    self.payWithBNPLForm(provider: .ValU)
                } else {
                    vc.errorView.isHidden = false
                    let minAmount = String(self.config?.valUMinimumAmount ?? 0)
                    vc.errorSnackMessage.text = String(format: "VALUE_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency)
                }
            case .Souhoola:
                
                if let bnplItemsValid = self.areBNPLItemsValid(authenticateParams: self.amount, bnplItems: self.bnplItems) {
                    
                    self.completion(nil, bnplItemsValid)
                    vc.dismiss(animated: false, completion: nil)
                    return
                }
                
                
                if  self.amount.amount >= Double(self.config?.souhoolaMinimumAmount ?? 0) {
                    if !self.navigationController.isKind(of: UINavigationController.self) {
                        vc.dismiss(animated: false, completion: nil)
                    }
                    self.payWithBNPLForm(provider: .Souhoola)
                } else {
                    vc.errorView.isHidden = false
                    let minAmount = String(self.config?.souhoolaMinimumAmount ?? 0)
                    vc.errorSnackMessage.text = String(format: "SOUHOOLA_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency)
                }
            case .Shahry:
                if let bnplItemsValid = self.areBNPLItemsValid(authenticateParams: self.amount, bnplItems: self.bnplItems) {
                    self.completion(nil, bnplItemsValid)
                    vc.dismiss(animated: false, completion: nil)
                    return
                } else {
                    if !self.navigationController.isKind(of: UINavigationController.self) {
                        vc.dismiss(animated: false, completion: nil)
                    }
                    self.payWithBNPLShahryForm()
                }

            case .none:
                break
            case .BNPLGroup:
                break
            }
        
        })
        
        let navViewController = UINavigationController(rootViewController: vc)
        navViewController.modalPresentationStyle = .fullScreen
        navViewController.setNavigationBarHidden(true, animated: false)
        
        present(navViewController)
    }
    
    private func areBNPLItemsValid(authenticateParams: GDAmount, bnplItems: [GDBNPLItem]?) -> GDErrorResponse? {
            

                guard  let items = bnplItems, !items.isEmpty else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E068.rawValue, code: GDErrorCodes.E068.description, detailedResponseMessage: GDErrorCodes.E068.detailedResponseMessage)
                }
                
                guard authenticateParams.amount > 0 else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage)
                }
                
                guard authenticateParams.amount.decimalCount() <= 2 else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage)
                }
                
                guard !authenticateParams.currency.isEmpty else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E006.rawValue, code: GDErrorCodes.E006.description, detailedResponseMessage: GDErrorCodes.E006.detailedResponseMessage)
                }
                
                guard authenticateParams.currency == "EGP" else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E032.rawValue, code: GDErrorCodes.E032.description, detailedResponseMessage: GDErrorCodes.E032.detailedResponseMessage)
                }
                
                let sum = bnplItems?.lazy.map  { $0.price * Double ($0.count) }.reduce(0, +)
                
                guard authenticateParams.amount == sum else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E031.rawValue, code: GDErrorCodes.E031.description, detailedResponseMessage: GDErrorCodes.E031.detailedResponseMessage)
                }
                return nil
           
        }
    
    func payWithGeideaForm() {
        let vc = PaymentFactory.makeCardDetailsFormViewController()
        vc.modalPresentationStyle = .fullScreen
        
        self.paymentMethods = getPaymentMethods()
        
        vc.viewModel = PaymentFactory.makeCardDetailsFormViewModel(amount: amount, showAdress: showAdress, showEmail: showEmail, showReceipt: showReceipt, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePay: nil, config: config, paymentIntentId: paymentIntentId, paymentMethods: paymentMethods, isNavController: false, completion: { orderResponse, error   in
            self.completion(orderResponse, error)
        })
        
        vc.viewModel.selectPaymentVM = selectPaymentVM
        
        if let navController = navigationController as? UINavigationController {
            navController.pushViewController(vc, animated: true)
        } else{
            present(vc)
        }
    }
    
    func payWithBNPLForm(provider: BNPLProvider) {
        let vc = PaymentFactory.makeBNPLViewController()
        vc.modalPresentationStyle = .fullScreen
        selectPaymentVM.nextAction = { action, navController  in

            if let pm = self.paymentMethods, pm.isEmpty {

                self.paymentMethods = self.config?.paymentMethods

            }

            switch action {

            case .Card:
                vc.dismiss(animated: false, completion: nil)
                self.payWithGeideaForm()
            case .QR:
                vc.dismiss(animated: false, completion: nil)
                self.payQRWithGeideaForm()
            case .ValU:
                self.payWithBNPLForm(provider: .ValU)
            case .Shahry:
                self.payWithBNPLShahryForm()
            case .Souhoola:
                self.payWithBNPLForm(provider: .Souhoola)
            case .BNPLGroup:
                break
            }

        }
        vc.viewModel = PaymentFactory.makeBNPLViewModel( bnplProvider: provider, selectPaymentVM: selectPaymentVM, isNavController: true, completion: { order, error in
            self.completion(order, error)
        })
        
        
        if let navController = navigationController as? UINavigationController {
            navController.pushViewController(vc, animated: true)
        } else{
            present(vc)
        }
        
    }
    
    func payWithBNPLShahryForm() {
        let vc = PaymentFactory.makeBNPLViewController()
        vc.modalPresentationStyle = .fullScreen
        selectPaymentVM.nextAction = { [self] action,navcontroller in
            
            if let pm = self.paymentMethods, pm.isEmpty {
                
                self.paymentMethods = self.config?.paymentMethods
                
            }
            vc.errorSnackView.isHidden = true
            switch action {
                
            case .Card:
                vc.dismiss(animated: false, completion: nil)
                self.payWithGeideaForm()
            case .QR:
                vc.dismiss(animated: false, completion: nil)
                self.payQRWithGeideaForm()
            case .ValU:
                if Double(self.config?.valUMinimumAmount ?? 0) <= self.amount.amount {
                    self.payWithBNPLForm(provider: .ValU)
                } else {
                    vc.errorSnackView.isHidden = false
                    let minAmount = String(self.config?.valUMinimumAmount ?? 0)
                    
                    if GlobalConfig.shared.language == .english {
                        vc.errorSnackCode.text = String(format: "VALUE_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency )
                    } else {
                        vc.errorSnackCode.text = "VALUE_INSTALLMENT_AMOUNT".localized
                    }
                   
                }
            case .Shahry:
                self.payWithBNPLShahryForm()
            case .Souhoola:
                if Double(self.config?.souhoolaMinimumAmount ?? 0) <= self.amount.amount {
                    self.payWithBNPLForm(provider: .Souhoola)
                } else {
                    vc.errorSnackView.isHidden = false
                    let minAmount = String(self.config?.souhoolaMinimumAmount ?? 0)
                    vc.errorSnackCode.text = String(format: "SOUHOOLA_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency )
                }
            case .BNPLGroup:
                break
            }
            
        }
        vc.viewModel = PaymentFactory.makeBNPLViewModel( bnplProvider: .SHAHRY, selectPaymentVM: selectPaymentVM, isNavController: true, completion: { order, error in
            self.completion(order, error)
        })
        
        if let navController = navigationController as? UINavigationController {
            navController.pushViewController(vc, animated: true)
        } else{
            present(vc)
        }
        
    }
    
    func payQRWithGeideaForm() {
        let vc = PaymentFactory.makeQRPaymentFormViewController()
        vc.modalPresentationStyle = .fullScreen
        
        vc.viewModel = PaymentFactory.makeQRPaymentFormViewModel(amount: amount, customerDetails: selectPaymentVM.qrCustomerDetails, config: config, expiryDate: qrExpiryDate, orderId: selectPaymentVM.orderId, callbackUrl: customerDetails?.callbackUrl, showReceipt: showReceipt, isNavController: false, completion:  { orderResponse, error   in
            self.completion(orderResponse, error)
        })
        
        if let navController = navigationController as? UINavigationController {
            navController.pushViewController(vc, animated: false)
        } else{
            present(vc)
        }
       
    }
    
    func getPaymentMethods() -> [String]?{
        var paymentMetods:[String]? = []
        var pmSetFilter = Set<String>()
        if let pms = paymentSelectionMethods {
            for pmsMethod  in pms {
                let pmSet = Set(pmsMethod.paymentMethods)
                if pmSet.isSubset(of: getAvailableCardPaymentMethods()) {
                    if pmSet.count == 1 {
                        paymentMetods?.append(pmSet.first ?? "")
                    } else {
                        paymentMetods?.append(contentsOf: Array(pmSet))
                    }
                   
                }
            }
            
            if let safePMs = paymentMetods, !safePMs.isEmpty  {
                pmSetFilter = Set(safePMs)
            }
            
            
            return Array(pmSetFilter)
        }
        return nil
    }
    
    func getAvailableCardPaymentMethods() -> [String] {
        guard let configPMs = config?.paymentMethods else  {
            return []
        }
        
        return configPMs
    }
}
