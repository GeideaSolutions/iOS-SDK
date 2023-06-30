//
//  MeezaPaymentRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.07.2021.
//

import Foundation
enum MeezaPaymentRouter: BaseRouter {
  
    case getMessage(paymentIntentParams: QRParams)
    case getImage(paymentIntentParams: QRParams)
    case getBase64Image(paymentIntentParams: QRParams)
    var method: GDWSHTTPMethod {
        switch self {
        case .getImage, .getBase64Image, .getMessage:
            return .POST
        }
        
    }
   
    var path: String {
        switch self {
        case .getImage:
            return "meezaPayment/image"
        case .getBase64Image:
            return "meezaPayment/image/base64"
        case .getMessage:
            return "meezaPayment/message"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getImage(let paymentIntentParams):
            return paymentIntentParams.toJson()
        case .getBase64Image(let paymentIntentParams):
            return paymentIntentParams.toJson()
        case .getMessage(paymentIntentParams: let paymentIntentParams):
            return paymentIntentParams.toJson()
        }
        
    }
    
    func fullpath() -> String {
         return APIHost.PAYMENTINTENT.rawValue+BaseVersion.V1.rawValue + path
    }

}

