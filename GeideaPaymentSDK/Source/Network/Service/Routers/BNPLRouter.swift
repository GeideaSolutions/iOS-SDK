//
//  BNPLRouter.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

enum BNPLRouter: BaseRouter {
    

    case installmentPlan(params: InstallmentPlanParams)
    case generateOTP(params: GenerateOTPParams)
    case verifyCustomer(params: VerifyCustomerParams)
    case purchase(params: PurchaseParams)
    case installmentPlanSelected(params: GDVALUInstallmentPlanSelectedDetails?)
   
    var method: GDWSHTTPMethod {
        switch self {
        case  .installmentPlan, .generateOTP, .verifyCustomer, .purchase, .installmentPlanSelected:
            return .POST
        }
    }
    
    var path: String {
        switch self {

        case .installmentPlan:
            return "installmentPlans"
        case .generateOTP:
            return "generateOTP"
        case .verifyCustomer:
            return "verifyCustomer"
        case .purchase:
            return "confirm"
        case .installmentPlanSelected:
            return "selectInstallmentPlan"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .installmentPlan(let params):
            return params.toJson()
        case .generateOTP(let params):
            return  params.toJson()
        case .verifyCustomer(let params):
            return params.toJson()      
        case .purchase(params: let params):
            return params.toJson()
        case .installmentPlanSelected(params: let params):
            return params?.toJson()
        }
        
    }
    func fullpath() -> String {
         return
        APIHost.BNPL.rawValue+"api/direct/"+APIHost.VALU_CNP.rawValue+SimpleBaseVersion.V1.rawValue + path
    }
}

