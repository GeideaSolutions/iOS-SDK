//
//  BNPLManager.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

class BNPLManager {
    typealias PayCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
    typealias InstallmentCompletionHandler = (GDInstallmentPlansResponse?, GDErrorResponse?) -> Void
    typealias VerifyCompletionHandler = (GDValuVerifyResponse?, GDErrorResponse?) -> Void
    typealias BNPLCompletionHandler = (GDBNPLResponse?, GDErrorResponse?) -> Void
    typealias BNPLPurchaseCompletionHandler = (GDBNPLPurchaseResponse?, GDErrorResponse?) -> Void
    typealias InstallmentPlanSelectedCompletionHandler = (GDInstallmentPlanSelectedResponse?, GDErrorResponse?) -> Void
    typealias SouhoolaVerifyCompletionHandler = (GDSouhoolaVerifyResponse?, GDErrorResponse?) -> Void
    typealias SouhoolaGetInstallmentPlanCompletionHandler = (GDSouhoolaInstallmentPlansResponse?, GDErrorResponse?) -> Void
    typealias SouhoolReviewCompletionHandler = (GDSouhoolaReviewResponse?, GDErrorResponse?) -> Void
    typealias SouhoolIPSelectedCompletionHandler = (GDSouhoolaInstallmentPlanSelectedResponse?, GDErrorResponse?) -> Void
    typealias SouhoolaBasicHandler = (GDSouhoolaBasicResponse?, GDErrorResponse?) -> Void
    
    func verifyCustomer(with verifyCustomerParams: VerifyCustomerParams, completion: @escaping VerifyCompletionHandler) {
        
        let request = Request(router: BNPLRouter.verifyCustomer(params: verifyCustomerParams))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDValuVerifyResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func getInstallmentPlan(with installmentPlanParams: InstallmentPlanParams, completion: @escaping InstallmentCompletionHandler) {
        
        let request = Request(router: BNPLRouter.installmentPlan(params: installmentPlanParams))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let installmentPlansResponse = GDInstallmentPlansResponse().parse(json: data)
            guard let response = installmentPlansResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func generateOTP(with generateOTPParams: GenerateOTPParams, completion: @escaping BNPLCompletionHandler) {
        
        let request = Request(router: BNPLRouter.generateOTP(params: generateOTPParams))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let bnplResponse = GDBNPLResponse().parse(json: data)
            guard let response = bnplResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func purchase(with purchaseParams: PurchaseParams, completion: @escaping BNPLPurchaseCompletionHandler) {
        
        let request = Request(router: BNPLRouter.purchase(params: purchaseParams))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let bnplResponse = GDBNPLPurchaseResponse().parse(json: data)
            guard let response = bnplResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func valuInstallmentPlanSelected(with params: GDVALUInstallmentPlanSelectedDetails?, completion: @escaping InstallmentPlanSelectedCompletionHandler) {
        
        let request = Request(router: BNPLRouter.installmentPlanSelected(params: params))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let bnplResponse = GDInstallmentPlanSelectedResponse().parse(json: data)
            guard let response = bnplResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func shahryInstallmentPlanSelected(with params: shahryInstallmentPlanSelectedParams?, completion: @escaping InstallmentPlanSelectedCompletionHandler) {
        
        let request = Request(router: ShahryRouter.installmentPlanSelected(params: params))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let bnplResponse = GDInstallmentPlanSelectedResponse().parse(json: data)
            guard let response = bnplResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    
    func shahryPurchase(with params: GDShahryConfirm, completion: @escaping PayCompletionHandler) {
        
        let request = Request(router: ShahryRouter.confirm(params: params))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let response = PayResponse().parse(json: data)
            guard let response = response else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response.order, error)
        }
    }
    
    func shahryCashOnDelivery(with params: GDCashOnDelivery, completion: @escaping PayCompletionHandler) {
        
        
        let request = Request(router: ShahryRouter.cashOnDelivery(params: params))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let response = PayResponse().parse(json: data)
            guard let response = response else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response.order, error)
        }
    }
    
    func souhoolaVerifyCustomer(with verifyCustomerParams: VerifyCustomerParams, completion: @escaping SouhoolaVerifyCompletionHandler) {
        
        let request = Request(router: SouhoolaRouter.verifyCustomer(params: verifyCustomerParams))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaVerifyResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaGetInstallmentPlans(with retreiveInstallmentPlans: GDSouhoolaRetreiveInstallmentPlans, completion: @escaping SouhoolaGetInstallmentPlanCompletionHandler) {
        
        let request = Request(router: SouhoolaRouter.installmentPlan(params: retreiveInstallmentPlans))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaInstallmentPlansResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaReviewTransaction(with transaction: GDSouhoolaReviewTransaction, completion: @escaping SouhoolReviewCompletionHandler) {
        
        let request = Request(router: SouhoolaRouter.reviewTransaction(params: SouhoolaReviewParams(publicSouhoola: transaction)))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaReviewResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaInstallmentPlanSelected(with details: GDSouhoolaInstallmentPlanSelected, completion: @escaping SouhoolIPSelectedCompletionHandler) {
        
        let request = Request(router: SouhoolaRouter.installmentPlanSelected(params: SouhoolaIPSelectedParams(publicSouhoola: details)))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaInstallmentPlanSelectedResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaGenerateOTP(with details: GDSouhoolaOTPDetails, completion: @escaping SouhoolaBasicHandler) {
        
        let request = Request(router: SouhoolaRouter.generateOTP(params: details))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaBasicResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaResendOTP(with details: GDSouhoolaResendOTPDetails, completion: @escaping SouhoolaBasicHandler) {
        
        let request = Request(router: SouhoolaRouter.resendOTP(params: details))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaBasicResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaConfirm(with details: GDSouhoolaConfirmDetails, completion: @escaping SouhoolaBasicHandler) {
        
        let request = Request(router: SouhoolaRouter.confirm(params: details))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaBasicResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
    
    func souhoolaCancel(with details: GDSouhoolaCancelDetails, completion: @escaping SouhoolaBasicHandler) {
        
        let request = Request(router: SouhoolaRouter.cancel(params: details))
       
        request.sendAsync { response, error in
            
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let payResponse = GDSouhoolaBasicResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
}
