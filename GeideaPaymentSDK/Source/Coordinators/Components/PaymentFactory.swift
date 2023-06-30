//
//  PaymentFactory.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12/10/2020.
//

import Foundation
import UIKit

class PaymentFactory: NSObject {
    static func makeWebViewViewController() -> WebviewViewController {
        return WebviewViewController(nibName: String(describing: WebviewViewController.self), bundle:  Bundle(for: WebviewViewController.self))
    }

    static func makeWebViewModel(authenticateParams: AuthenticateParams, authenticateResponse: AuthenticateResponse) -> WebViewViewModel {
        return WebViewViewModel(authenticateParams: authenticateParams, authenticateResponse: authenticateResponse)
    }
    
    static func makeWebViewModel(payTokenParams: PayTokenParams, authenticateResponse: AuthenticateResponse) -> WebViewViewModel {
        return WebViewViewModel(payTokenParams: payTokenParams, autheticateResponse: authenticateResponse)
    }
    
    static func makePaymentViewController() -> PaymentViewController {
        return PaymentViewController()
    }
    
    static func makeCVVViewController() -> CVVViewController {
        return CVVViewController()
    }
    
    static func makeCardDetailsFormViewController() -> CardDetailsFormViewController {
        return CardDetailsFormViewController()
    }
    
    static func makeInstallmentViewController() -> InstallmentViewController {
        return InstallmentViewController()
    }
    
    static func makePaymentSelectionFormViewController() -> SelectPaymentMethodViewController {
        return SelectPaymentMethodViewController()
    }
    
    static func makeBNPLViewController() -> BNPLViewController {
        let BNPL = UIStoryboard(name: "BNPL", bundle: Bundle(identifier: "net.geidea.GeideaPaymentSDK"))
        let BNPLViewController = BNPL.instantiateViewController(withIdentifier: "BNPLViewController") as! BNPLViewController
        return BNPLViewController
    }
    
    static func makeBNPLViewModel(bnplProvider: BNPLProvider, selectPaymentVM: SelectPaymentMethodViewModel,isNavController: Bool, completion: @escaping PaymentFormCompletionHandler ) -> BNPLViewModel {
        return BNPLViewModel(bnplProvider: bnplProvider, selectPaymentVM: selectPaymentVM,isNavController: isNavController, completion: completion)
    }
    
    static func makePhoneNumberViewModel() -> PhoneNumberViewModel {
        return PhoneNumberViewModel(screenTitle: "", isNavController: false)
    }

    static func makePaymentViewModel(authenticateParams: AuthenticateParams, initializeResponse: GDInitiateAuthenticateResponse?, isHpp: Bool,isNavController: Bool, config: GDConfigResponse?, showReceipt: Bool) -> PaymentViewModel {
        return PaymentViewModel(authenticateParams: authenticateParams, config: config, showReceipt: showReceipt, initializeRespone: initializeResponse, isHpp: isHpp, isNavController: isNavController)
    }
    
    
    
    static func makeOperationViewModel(orderId: String, callbackURL: String?, operation: Operation, isNavController: Bool) -> OperationViewModel {
        return OperationViewModel(orderId: orderId, callbackUrl: callbackURL, operation: operation,  isNavController: isNavController)
    }
    
    static func makePaymentTokenViewModel(payTokenParams: PayTokenParams,config: GDConfigResponse?, showReceipt: Bool, isNavController: Bool) -> PaymentTokenViewModel {
        return PaymentTokenViewModel(payTokenParms: payTokenParams, config: config, showReceipt: showReceipt, isNavController: isNavController)
    }
    
    static func makeCardDetailsFormViewModel(amount: GDAmount, showAdress: Bool, showEmail: Bool, showReceipt: Bool,tokenizationDetails:  GDTokenizationDetails?, customerDetails: GDCustomerDetails?, applePay: GDApplePayDetails?, config: GDConfigResponse?, paymentIntentId: String?, paymentMethods: [String]?, isEmbedded:Bool = false,isNavController: Bool, completion: @escaping PaymentFormCompletionHandler ) -> CardDetailsFormViewModel {
        return CardDetailsFormViewModel(amount: amount, showAddress: showAdress, showEmail: showEmail, showReceipt: showReceipt, customerDetails: customerDetails,tokenizationDetails: tokenizationDetails, applePayDetails: applePay, config: config, paymentIntent: paymentIntentId, paymentMethods: paymentMethods, isEmbedded: isEmbedded,isNavController: isNavController, completion: completion)
    }
    
    static func makePaymentSelectionFormViewModel(amount: GDAmount, showAdress: Bool, showEmail: Bool, showReceipt: Bool,tokenizationDetails:  GDTokenizationDetails?, customerDetails: GDCustomerDetails?, applePay: GDApplePayDetails?, config: GDConfigResponse?, paymentIntentId: String?,  qrCustomerDetails: GDPICustomer?, qrExpiryDate: String?, shahryItems: [GDBNPLItem]?, paymentMethods: [String]?,  paymentSelectionMethods: [GDPaymentSelectionMetods]?, isNavController: Bool, embedded: Bool = false, showValu: Bool = true, completion: @escaping FormCompletionHandler, nextAction: @escaping NextHandler ) -> SelectPaymentMethodViewModel {
        return SelectPaymentMethodViewModel(amount: amount, showAddress: showAdress, showEmail: showEmail, showReceipt: showReceipt, customerDetails: customerDetails,tokenizationDetails: tokenizationDetails, applePayDetails: applePay, config: config, paymentIntent: paymentIntentId, qrCustomerDetails: qrCustomerDetails, qrExpiryDate: qrExpiryDate, shahryItems: shahryItems, paymentMethods: paymentMethods, paymentSelectionMethods: paymentSelectionMethods, isNavController: isNavController, embedded: embedded, completion: completion, nextAction: nextAction)
    }
    
    static func makeCountrySelectionController(countries: [ConfigCountriesResponse], buttontag: Int) -> CountrySelectionViewController {
        let vc = CountrySelectionViewController()
        vc.countries = countries
        vc.buttonTag = buttontag
        return vc
    }
    
    static func makeCVVAlertViewController() -> CVVAlertViewController {
        let vc = CVVAlertViewController()
        return vc
    }
    
    static func makeCancelAlertViewController() -> CancelAlertViewController {
        let vc = CancelAlertViewController()
        return vc
    }
    
    static func makeQRPaymentFormViewController() -> QRPaymentFormViewController {
        return QRPaymentFormViewController()
    }
    
    static func makeQRPaymentFormViewModel(amount: GDAmount, customerDetails: GDPICustomer?, config: GDConfigResponse?, expiryDate: String?, orderId: String?, callbackUrl: String?, showReceipt: Bool, isEmbedded: Bool = false, isNavController: Bool, completion: @escaping PayCompletionHandler) -> QRPaymentFormViewModel {
        return QRPaymentFormViewModel(amount: amount, customerDetails: customerDetails, config: config, expiryDate: expiryDate, showReceipt: showReceipt, merchantName: customerDetails?.name, orderID: orderId, callbackUrl: callbackUrl, isEmbedded: isEmbedded,isNavController: isNavController, completion: completion)
    }
    
    static func makeRequestToPayViewController() -> RequestToPayViewController {
        return RequestToPayViewController()
    }
    
    static func makeReceiptViewController() -> ReceiptViewController {
        return ReceiptViewController()
    }
    
    static func makeReceiptViewModel(withOrderResponse response: GDOrderResponse?, withError gdError: GDErrorResponse?, withReceipt gdReceipt:GDReceipt? = nil,receiptFlow: ReceiptFlow, config: GDConfigResponse?, isEmbedded: Bool = false, completion: @escaping PayCompletionHandler ) -> ReceiptViewModel {
        return ReceiptViewModel(order: response, error: gdError, receipt: gdReceipt, receiptFlow: receiptFlow,  config: config, isEmbedded: isEmbedded, isNavController: false,  completion: completion)
    }
    
    static func makeRequestToPayViewModel(withQRCodeMessage qrCodeMessage: String, config: GDConfigResponse?, orderId: String?, completion: @escaping RTPCompletionHandler ) -> RequestToPayViewModel {
        return RequestToPayViewModel(qrCodeMessage: qrCodeMessage, config: config, orderId: orderId, isNavController: false,  completion: completion)
    }

}

