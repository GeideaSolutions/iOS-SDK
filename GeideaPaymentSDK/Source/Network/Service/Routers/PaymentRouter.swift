//
//  PaymentRouter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation

enum PaymentRouter: BaseRouter {
    

    case authenticate(authenticateParams: AuthenticateParams)
    case pay(payParams: PayParams)
    case capture(captureParams: CaptureParams)
    case refund(captureParams: CaptureParams)
    case applePay(applePayParams: ApplePayParams)
    case payToken(tokenParams: PayTokenParams)
    case cancel(cancelParams: CancelParams)
    case getToken(tokenId: String)
   
    var method: GDWSHTTPMethod {
        switch self {
        case  .authenticate, .pay, .applePay, .capture, .refund, .payToken, .cancel:
            return .POST
        case .getToken:
            return .GET
        }
    }
    
    var path: String {
        switch self {

        case .authenticate:
            return "direct/authenticate"
        case .pay:
            return "direct/pay"
        case .applePay:
            return "direct/apple/pay"
        case .capture:
            return "direct/capture"
        case .refund:
            return "direct/refund"
        case .payToken:
            return "direct/pay/token"
        case .cancel:
            return "direct/cancel"
        case .getToken(tokenId: let tokenId):
            return "direct/token/\(tokenId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .authenticate(let authenticateParams):
            return authenticateParams.toJson()
        case .pay(let payParams):
            return  payParams.toJson()
        case .applePay(let applePayParams):
            return applePayParams.toDictionary()
        case .capture(captureParams: let captureParams):
            return captureParams.toJson()
        case .refund(captureParams: let captureParams):
            return captureParams.toJson()
        case .payToken(tokenParams: let tokenParams):
            return tokenParams.toJson()
        case .cancel(cancelParams: let cancelParams):
            return cancelParams.toJson()
        case .getToken(tokenId: let tokenId):
            return nil
        }
    }
    
    func fullpath() -> String {
        switch self {
        case .pay:
            return APIHost.PGW.rawValue+BaseVersion.V2.rawValue + path
        default:
            return APIHost.PGW.rawValue+BaseVersion.V1.rawValue + path
        }
        
    }
}

