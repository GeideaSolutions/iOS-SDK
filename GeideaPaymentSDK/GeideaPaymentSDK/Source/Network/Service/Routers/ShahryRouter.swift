//
//  ShahryRouter.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 14.04.2022.
//

import Foundation

enum ShahryRouter: BaseRouter {
    
    case confirm(params: GDShahryConfirm)
    case installmentPlanSelected(params: shahryInstallmentPlanSelectedParams?)
    case cashOnDelivery(params: GDCashOnDelivery?)
   
    var method: GDWSHTTPMethod {
        switch self {
        case .confirm, .installmentPlanSelected, .cashOnDelivery:
            return .POST
        }
    }
    
    var path: String {
        switch self {

        case .confirm:
            return "confirm"
        case .installmentPlanSelected:
            return "selectInstallmentPlan"
        case .cashOnDelivery:
            return "cashOnDelivery"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
     
        case .confirm(params: let params):
            return params.toJson()
        case .installmentPlanSelected(params: let params):
            return params?.toJson()
        case .cashOnDelivery(params: let params):
            return params?.toJson()
        }
        
    }
    func fullpath() -> String {
         return
        APIHost.BNPL.rawValue+"api/direct/"+APIHost.SHAHRY_CNP.rawValue+SimpleBaseVersion.V1.rawValue + path
    }
}

