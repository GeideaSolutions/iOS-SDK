//
//  EInvoiceRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 17/02/2021.
//

import Foundation

enum PaymentIntentRouter: BaseRouter {
    
    case create(paymentIntentParams: PaymentIntentParams)
    case getInvoice(paymentIntentId: String)
    case getPaymentIntent(paymentIntentId: String)
    case getAll(paymentIntentFilter: GDPaymentIntentFilter)
    case delete(paymentIntentId: String)
    case update(paymentIntentParams: PaymentIntentParams)
    case sendLinkBySMS(paymentIntentId: String)
    case sendLinkByEmail(paymentIntentId: String)
    case sendLinkByMultiple(sendLinkMultipleDetails: SendLinkMultipleParams)
   
    var method: GDWSHTTPMethod {
        switch self {
        case .create, .sendLinkBySMS, .sendLinkByEmail, .sendLinkByMultiple:
            return .POST
        case .getInvoice, .getAll, .getPaymentIntent:
            return .GET
        case .delete:
            return .DELETE
        case .update:
            return .PUT
        }
        
    }
   
    var path: String {
        switch self {
        case .create, .update:
            return "direct/eInvoice"
        case .getInvoice(let paymentIntentId), .delete(let paymentIntentId):
            return "direct/eInvoice/\(paymentIntentId)"
        case .getAll:
            return "direct/eInvoice"
        case .getPaymentIntent(paymentIntentId: let paymentIntentId):
            return "paymentIntent/\(paymentIntentId)"
        case .sendLinkBySMS(paymentIntentId: let paymentIntentId):
            return "direct/eInvoice/\(paymentIntentId)/sendBySMS"
        case .sendLinkByEmail(paymentIntentId: let paymentIntentId):
            return "direct/eInvoice/\(paymentIntentId)/sendByEmail"
        case .sendLinkByMultiple(sendLinkMultipleDetails: let sendLinkMultipleDetails):
            return "paymentIntent/sendMultiple"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .create(let paymentIntentParams), .update(let paymentIntentParams):
            return paymentIntentParams.toJson()
        case .getInvoice, .delete, .getPaymentIntent, .sendLinkBySMS, .sendLinkByEmail:
            return nil
        case .getAll(let paymentIntentFilter):
            return paymentIntentFilter.toJson()
        case .sendLinkByMultiple(sendLinkMultipleDetails: let sendLinkMultipleDetails):
            return sendLinkMultipleDetails.toJson()
        }
        
    }
    
    func fullpath() -> String {
         return APIHost.PAYMENTINTENT.rawValue+BaseVersion.V1.rawValue + path
    }
}

