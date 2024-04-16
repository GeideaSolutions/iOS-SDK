//
//  BNPLVIewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.02.2022.
//

import Foundation
import UIKit

enum BNPLFlow {
    case SHAHRY_CONFIRM
    case PURCHASE_SHAHRY
    case BNPL_CONFIRM_PHONE
    case INSTALLMENT
    case PAYMENT
    case CARD_DETAILS
    case QR
    case OTP
    case REVIEW_TRANSACTION
}

enum BNPLProvider {
    case SHAHRY
    case ValU
    case Souhoola
    case NONE
}


class BNPLViewModel: ViewModel {
    
    var provider: BNPLProvider
    var currentFlow: BNPLFlow
    var selectPaymentVM: SelectPaymentMethodViewModel
    var otp: String?
    var bnplOrderID: String?
    var customerId: String?
    var pin: String?
    var downPayment: GDAmount?
    var cashBackAmount: GDAmount?
    var toUAmount: GDAmount?
    var tenure: Int = 0
    var adminFees: Double = 0.0
    var souhoolaVerifyResponse: GDSouhoolaVerifyResponse?
    
    
  
    
    var valuLimitTitle: String {
        return "VALUE_INSTALLMENT_AMOUNT".localized
    }
    
    var confirmTitle: String {
        return "INSTALLMENT_STEP_CONFIRM_SHAHRY_TITLE".localized
    }
    
    var confirmPinTitle: String {
        return "INSTALLMENT_STEP_CONFIRM_SOUHOOLA_TITLE".localized
    }

    var purchaseTitle: String {
        return "INSTALLMENT_STEP_SHAHRY_PURCHASE_TITLE".localized
    }
    
    var phoneTitle: String {
        return "INSTALLMENT_STEP_PHONE_TITLE".localized
    }

    var installmentTitle: String {
        return "INSTALLMENT_STEP_INSTALLMENT_TITLE".localized
    }

    var paymentTitle: String {
        return "INSTALLMENT_STEP_PAYMENT_TITLE".localized
    }

    var otpTitle: String {
        return "INSTALLMENT_STEP_OTP_TITLE".localized
    }
    
    var reviewTitle: String {
        return "REVIEW_SOUHOOLA_SCREEN_TITLE".localized
    }

    var requestToPayButton: String {
        return "QR_PAYMENT_BUTTON".localized
    }
    
    let customerIdInvalid = "CUSTOMER_ID_INVALID".localized

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }

    
    func goToNextScren() {
        switch currentFlow {
        case .BNPL_CONFIRM_PHONE:
            currentFlow = .INSTALLMENT
        case .INSTALLMENT:
            currentFlow = .PAYMENT
        case .PAYMENT:
            currentFlow = .OTP
        case .OTP:
           break
        case .CARD_DETAILS:
            break
        case .QR:
            break
        case .SHAHRY_CONFIRM:
            currentFlow = .PURCHASE_SHAHRY
        case .PURCHASE_SHAHRY:
            break
        case .REVIEW_TRANSACTION:
            currentFlow = .OTP
        }
    }
    
    func goToPreviousScren() {
        switch currentFlow {
        case .BNPL_CONFIRM_PHONE:
            currentFlow = .BNPL_CONFIRM_PHONE
        case .INSTALLMENT:
            currentFlow = .BNPL_CONFIRM_PHONE
        case .PAYMENT:
            currentFlow = .INSTALLMENT
        case .OTP:
            currentFlow = .PAYMENT
        case .CARD_DETAILS:
            currentFlow = .PAYMENT
        case .QR:
            currentFlow = .PAYMENT
        case .SHAHRY_CONFIRM:
            currentFlow = .SHAHRY_CONFIRM
        case .PURCHASE_SHAHRY:
            currentFlow = .SHAHRY_CONFIRM
        case .REVIEW_TRANSACTION:
            currentFlow = .INSTALLMENT
        }
    }
    
    init(bnplProvider: BNPLProvider,  selectPaymentVM: SelectPaymentMethodViewModel, isNavController: Bool,  completion: @escaping PaymentFormCompletionHandler) {
        self.selectPaymentVM = selectPaymentVM
        self.provider = bnplProvider
        self.currentFlow = .BNPL_CONFIRM_PHONE
        switch self.provider{
            case .ValU:
            self.currentFlow = .BNPL_CONFIRM_PHONE
        case .SHAHRY:
            self.currentFlow = .SHAHRY_CONFIRM
        case .Souhoola:
            self.currentFlow = .BNPL_CONFIRM_PHONE
        case .NONE:
            break
        }
        
        super.init(screenTitle: "", isNavController: isNavController, orderId: selectPaymentVM.orderId)
        
    }
    
    func areBNPLItemsValid(authenticateParams: GDAmount, bnplItems: [GDBNPLItem]?) -> GDErrorResponse? {
            
            if bnplItems == nil {
                return nil
            } else {
                guard authenticateParams.amount > 0 else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage)
                }
                
                guard authenticateParams.amount.decimalCount() <= 2 else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage)
                }
                
                guard !authenticateParams.currency.isEmpty else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E006.rawValue, code: GDErrorCodes.E006.description, detailedResponseMessage: GDErrorCodes.E006.detailedResponseMessage)
                }
                
                guard authenticateParams.currency == "EGP" else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E032.rawValue, code: GDErrorCodes.E032.description, detailedResponseMessage: GDErrorCodes.E032.detailedResponseMessage)
                }
                
                let sum = bnplItems?.lazy.map  { $0.price * Double ($0.count) }.reduce(0, +)
                
                guard authenticateParams.amount == sum else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E031.rawValue, code: GDErrorCodes.E031.description, detailedResponseMessage: GDErrorCodes.E031.detailedResponseMessage)
                }
                return nil
            }
           
        }
    
    
    func getInstallmentPlans(with phoneNumber:String, downPayment: Double = 0, giftCardAmount: Double = 0, campaignAmount: Double = 0, adminFees: Double = 0, completion: @escaping (GDInstallmentPlansResponse?, GDErrorResponse?)  -> Void ) {
        let details = GDInstallmentPlanDetails(customerIdentifier: phoneNumber, totalAmount: selectPaymentVM.amount.amount, currency: selectPaymentVM.amount.currency, downPayment: downPayment, giftCardAmount:giftCardAmount, campaignAmount: campaignAmount, adminFees: adminFees)
        
        GeideaBNPLAPI.VALUGetInstallmentPlan(with: details, completion: { response, error in
            completion(response,error)
        })
    }
    
    func verifyPhoneNumber(with phoneNumber:String, completion: @escaping (GDValuVerifyResponse?, GDErrorResponse?)  -> Void) {
        GeideaBNPLAPI.VALUVeriFyCustomer(with: phoneNumber, completion: { response, error in
            completion(response,error)
        })
    }
    
    func generateOTP(with phoneNumber:String, bnplOrderID: String, completion: @escaping (GDBNPLResponse?, GDErrorResponse?)  -> Void ) {
       
        
        GeideaBNPLAPI.VALUGenerateOTP(with: phoneNumber, BNPLOrderId: bnplOrderID, completion: { response, error in
            completion(response,error)
        })
    }
    
    func purchase(with purchaseDetails:GDBNPLPurchaseDetails, completion: @escaping (GDBNPLPurchaseResponse?, GDErrorResponse?)  -> Void ) {
        
        GeideaBNPLAPI.VALUPurchase(with: purchaseDetails, completion: { response, error in
            completion(response,error)
        })
    }
    
    func installmentPlanSelected(with installmentPlanDetails:GDVALUInstallmentPlanSelectedDetails, completion: @escaping (GDInstallmentPlanSelectedResponse?, GDErrorResponse?)  -> Void ) {
        
        GeideaBNPLAPI.VALUInstallmentPlanSelected(with: installmentPlanDetails, completion: { response, error in
            completion(response,error)
        })
    }
    
    func confirm(with purchaseDetails:GDShahryConfirm, completion: @escaping (GDOrderResponse?, GDErrorResponse?)  -> Void ) {
        
        GeideaBNPLAPI.shahryConfirm(with: purchaseDetails, completion: { response, error in
            completion(response,error)
        })
    }
    
    func installmentPlanSelected(with installmentPlanDetails:GDShahrySelectPlanInstallment, completion: @escaping (GDInstallmentPlanSelectedResponse?, GDErrorResponse?)  -> Void ) {
        
        GeideaBNPLAPI.sharyInstallmentPlanSelected(with: installmentPlanDetails,  completion: { response, error in
            completion(response,error)
        })
    }
    
    
    func getSouhoolaInstallmentPlans( completion: @escaping (GDSouhoolaInstallmentPlansResponse?, GDErrorResponse?)  -> Void ) {
        let details = GDSouhoolaRetreiveInstallmentPlans(customerIdentifier: customerId, customerPin: pin, totalAmount: selectPaymentVM.amount.amount, currency: selectPaymentVM.amount.currency, adminFees: adminFees, downPayment: downPayment?.amount ?? 0.0)
        
        GeideaBNPLAPI.souhoolaGetInstallmentPlan(with: details, completion: { response, error in
            completion(response,error)
        })
        
    }
    
    func souhoolaVerifyCustomer(with phoneNumber:String, pin: String, completion: @escaping (GDSouhoolaVerifyResponse?, GDErrorResponse?)  -> Void) {
        GeideaBNPLAPI.souhoolaVeriFyCustomer(with: phoneNumber, pin: pin, completion: { response, error in
            self.souhoolaVerifyResponse = response
            completion(response,error)
        })
    }
    
    func souhoolaReviewTransaction(with details: GDSouhoolaReviewTransaction, completion: @escaping (GDSouhoolaReviewResponse?, GDErrorResponse?)  -> Void) {
        GeideaBNPLAPI.souhoolaReviewTransaction(with: details, completion: { response, error in
            completion(response,error)
        })
    }
    
    func souhoolaPlanSelected(with details: GDSouhoolaInstallmentPlanSelected, completion: @escaping (GDSouhoolaInstallmentPlanSelectedResponse?, GDErrorResponse?)  -> Void) {

        GeideaBNPLAPI.souhoolaInstallmentPlanSelected(with: details, completion: { response, error in
            completion(response,error)
        })
    }
    
    func souhoolaGenerateOTP(with details: GDSouhoolaOTPDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?)  -> Void ) {
       
        GeideaBNPLAPI.souhoolaGenerateOTP(with: details, completion: { response, error in
            completion(response,error)
        })
    }
    
    func souhoolaResendOTP(with details: GDSouhoolaResendOTPDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?)  -> Void ) {
       
        GeideaBNPLAPI.souhoolaResendOTP(with: details, completion: { response, error in
            completion(response,error)
        })
    }
    
    func souhoolaCancel(with details: GDSouhoolaCancelDetails, completion: @escaping (GDSouhoolaBasicResponse?, GDErrorResponse?)  -> Void ) {
       
        GeideaBNPLAPI.souhoolaCancel(with: details, completion: { response, error in
            completion(response,error)
        })
    }
}
