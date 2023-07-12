//
//  SouhoolaRouter.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 03.05.2022.
//

import Foundation

enum SouhoolaRouter: BaseRouter {
    

    case installmentPlan(params: GDSouhoolaRetreiveInstallmentPlans)
    case generateOTP(params: GDSouhoolaOTPDetails)
    case verifyCustomer(params: VerifyCustomerParams)
    case reviewTransaction(params: SouhoolaReviewParams)
    case installmentPlanSelected(params: SouhoolaIPSelectedParams?)
    case confirm(params: GDSouhoolaConfirmDetails?)
    case resendOTP(params: GDSouhoolaResendOTPDetails?)
    case cancel(params: GDSouhoolaCancelDetails?)
   
    var method: GDWSHTTPMethod {
        switch self {
        case  .installmentPlan, .generateOTP, .verifyCustomer, .reviewTransaction, .installmentPlanSelected, .confirm, .resendOTP:
            return .POST
        case .cancel:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {

        case .installmentPlan:
            return "retrieveInstallmentPlans"
        case .generateOTP:
            return "generateOTP"
        case .verifyCustomer:
            return "verifyCustomer"
        case .reviewTransaction:
            return "reviewTransaction"
        case .installmentPlanSelected:
            return "selectInstallmentPlan"
        case .confirm:
            return "confirm"
        case .resendOTP:
            return "resendOTP"
        case .cancel:
            return "cancel"
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
        case .reviewTransaction(params: let params):
            return params.toJson()
        case .installmentPlanSelected(params: let params):
            return params?.toJson()
        case .confirm(params: let params):
            return params?.toJson()
        case .resendOTP(params: let params):
            return params?.toJson()
        case .cancel(params: let params):
            return params?.toJson()
        }
        
    }
    func fullpath() -> String {
         return
        APIHost.BNPL.rawValue+"api/direct/"+APIHost.SOUHOOLA_CNP.rawValue+SimpleBaseVersion.V1.rawValue + path
    }
}

