//
//  GeideaBNPLAPI.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 26.05.2022.
//

import Foundation

@objc public class GeideaBNPLAPI: NSObject {
    
    // MARK: ValU Public Methods
    
    /**
     ValU
     
     Add this to check if ValU customer can be verified. Please check GeideaForm with BNPL details for exmaple in GeideaPaymentAPI
     
     - Since: 2.3
     - Version: 2.3
     */
    @objc public static func VALUVeriFyCustomer(with phoneNumber: String?, completion: @escaping (GDValuVerifyResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("BNPL Verify customer")
        
        BNPLManager().verifyCustomer(with: VerifyCustomerParams(customerIdentifer: phoneNumber), completion: { verifyCustomerResponse, error in
            completion(verifyCustomerResponse, error)
        })
    }
    
    /**
     ValU
     
     Use this method for getting the valU installment plans object based of GDInstallmentPlanDetails
     
     - Since: 2.3
     - Version: 2.3
     */
    
    @objc public static func VALUGetInstallmentPlan(with installmentPlanDetails: GDInstallmentPlanDetails?, completion: @escaping (GDInstallmentPlansResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
        
        BNPLManager().getInstallmentPlan(with: InstallmentPlanParams(params: installmentPlanDetails), completion: { response, error in
            completion(response, error)
        })
    }
    
    /**
     ValU
     
     You need to usde this method when the user selects an installment plan from table. Order Id and BNPLOrder id will be retreived in response
     
     - Since: 2.3
     - Version: 2.3
     */
    @objc public static func VALUInstallmentPlanSelected(with installmentPlanDetails: GDVALUInstallmentPlanSelectedDetails?, completion: @escaping (GDInstallmentPlanSelectedResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
        
        BNPLManager().valuInstallmentPlanSelected(with: installmentPlanDetails, completion: { response, error in
            completion(response, error)
        })
    }
    
    /**
     ValU
     
     Use this method for generate the OTP. You can use it for resend code also. Need customerIdentifier and the BNPLOrderId from selected plans
     
     - Since: 2.3
     - Version: 2.3
     */
    
    @objc public static func VALUGenerateOTP(with customerIdentier: String, BNPLOrderId: String,completion: @escaping (GDBNPLResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("BNPL Generate OTP")
        
        BNPLManager().generateOTP(with: GenerateOTPParams(customerIdentifer: customerIdentier, BNPLOrderID: BNPLOrderId), completion: { response, error in
            completion(response, error)
        })
    }
    
    /**
     ValU
     
     Use this method for confirm the purchase with valU
     
     - Since: 2.3
     - Version: 2.3
     */
    
    @objc public static func VALUPurchase(with purchaseParams: GDBNPLPurchaseDetails?,completion: @escaping (GDBNPLPurchaseResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("BNPL Purchase")
        
        BNPLManager().purchase(with: PurchaseParams(params: purchaseParams), completion: { response, error in
            completion(response, error)
        })
    }
    
   
    // MARK: Shahry Public Methods
    
    /**
     Shahry
     
     Add this to check if Shahry customer can be verified. You need a Shahry id form TextField to let the user type his own Shahry Id. Please check GeideaForm with BNPL details for exmaple in GeideaPaymentAPI
     
     - Since: 2.3
     - Version: 2.3
     */
    
    
    
    @objc public static func sharyInstallmentPlanSelected(with installmentPlanDetails: GDShahrySelectPlanInstallment?, completion: @escaping (GDInstallmentPlanSelectedResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
        
        BNPLManager().shahryInstallmentPlanSelected(with: shahryInstallmentPlanSelectedParams(publicShahry: installmentPlanDetails), completion: { response, error in
            completion(response, error)
        })
    }
    
    @objc public static func shahryConfirm(with confirmDetails: GDShahryConfirm, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
        
        BNPLManager().shahryPurchase(with: confirmDetails, completion: { response, error in
            completion(response, error)
        })
    }
    
    @objc public static func shahryCashOnDelivery(with details: GDCashOnDelivery, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Shahry cash on delivery")
        
        BNPLManager().shahryCashOnDelivery(with: details, completion: { response, error in
            completion(response, error)
        })
    }
    
   
    
    
    // MARK: Souhoola Public Methods
    
    @objc public static func souhoolaVeriFyCustomer(with phoneNumber: String?, pin: String?, completion: @escaping (GDSouhoolaVerifyResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("BNPL Verify customer")
        
        BNPLManager().souhoolaVerifyCustomer(with: VerifyCustomerParams(customerIdentifer: phoneNumber, pin: pin), completion: { verifyCustomerResponse, error in
                        completion(verifyCustomerResponse, error)
                })
    }
    
    @objc public static func souhoolaGetInstallmentPlan(with installmentPlanDetails: GDSouhoolaRetreiveInstallmentPlans, completion: @escaping (GDSouhoolaInstallmentPlansResponse?, GDErrorResponse?) -> Void) {
        
            logEvent("Get BNPL Installment plans")
            
            BNPLManager().souhoolaGetInstallmentPlans(with: installmentPlanDetails, completion: { response, error in
                completion(response, error)
        })
    }
    
    @objc public static func souhoolaReviewTransaction(with details: GDSouhoolaReviewTransaction, completion: @escaping (GDSouhoolaReviewResponse?, GDErrorResponse?) -> Void) {
        
            logEvent("Get BNPL Installment plans")
            
            BNPLManager().souhoolaReviewTransaction(with: details, completion: { response, error in
                completion(response, error)
        })
    }
    
    @objc public static func souhoolaInstallmentPlanSelected(with details: GDSouhoolaInstallmentPlanSelected, completion: @escaping (GDSouhoolaInstallmentPlanSelectedResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
            
        BNPLManager().souhoolaInstallmentPlanSelected(with: details, completion: { response, error in
                completion(response, error)
        })
    }
    
    @objc public static func souhoolaGenerateOTP(with details: GDSouhoolaOTPDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
            
        BNPLManager().souhoolaGenerateOTP(with: details, completion: { response, error in
                completion(response, error)
        })
    }
    
    @objc public static func souhoolaResendOTP(with details: GDSouhoolaResendOTPDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
            
        BNPLManager().souhoolaResendOTP(with: details, completion: { response, error in
                completion(response, error)
        })
    }
    
    @objc public static func souhoolaCancel(with details: GDSouhoolaCancelDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Souhoola Cancel")
            
        BNPLManager().souhoolaCancel(with: details, completion: { response, error in
                completion(response, error)
        })
    }
    
    @objc public static func souhoolaConfirm(with details: GDSouhoolaConfirmDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get BNPL Installment plans")
            
        BNPLManager().souhoolaConfirm(with: details, completion: { response, error in
                completion(response, error)
        })
    }
    
    
}
