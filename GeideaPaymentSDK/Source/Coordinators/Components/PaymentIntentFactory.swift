//
//  PaymentIntentFactory.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/02/2021.
//

import Foundation

class PaymentIntentFactory: NSObject {
   
    static func makePaymentIntentViewController() -> PaymentIntentViewController {
        return PaymentIntentViewController(nibName: String(describing: PaymentIntentViewController.self), bundle:  Bundle(for: PaymentIntentViewController.self))
    }

    static func makePaymentIntentViewModel(paymentIntentID: String?, status: String?, type: String?, currency: String?) -> PaymentIntentViewModel {
        return PaymentIntentViewModel(paymentId: paymentIntentID, type: type, status: status, currency: currency)
    }
    
    static func makeEInvoiceDetailsViewController() -> EInvoiceDetailsViewController {
        return EInvoiceDetailsViewController(nibName: String(describing: EInvoiceDetailsViewController.self), bundle:  Bundle(for: EInvoiceDetailsViewController.self))
    }
    
    static func makeEInvoiceDetailsViewModel(paymentIntentDetails: GDPaymentIntentDetails, isUpdate: Bool = false) -> EInvoiceDetailsViewModel {
        return EInvoiceDetailsViewModel(paymentIntentDetails: paymentIntentDetails, isUpdate:isUpdate)
    }
    
    static func makeEInvoiceItemViewController() -> EInvoiceItemViewController {
        return EInvoiceItemViewController(nibName: String(describing: EInvoiceItemViewController.self), bundle:  Bundle(for: EInvoiceItemViewController.self))
    }
}

extension PaymentFactory {
    
}

fileprivate extension String {
    
}
