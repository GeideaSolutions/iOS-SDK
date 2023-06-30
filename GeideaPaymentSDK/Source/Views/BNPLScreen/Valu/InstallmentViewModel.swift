//
//  InstallmentViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.02.2022.
//


import Foundation
import UIKit

class InstallmentViewModel: ViewModel {
    var customerIdentifier: String?
    var amount: GDAmount?
    var financedAmount: GDAmount?
    var downPaymentAmount: Double = 0.0
    var installmentPlans: [InstallmantPlanCellViewModel] = [InstallmantPlanCellViewModel]()
    var installmentSelected: GDInstallmentPlan?
    
    var totalAmountTitle: String {
        return  "TOTAL_AMOUNT".localized
    }
    
    var financedAmountTitle: String {
        return  "FINANCED_AMOUNT".localized
    }
    
    var doneTitle: String {
        return  "DONE_BUTTON".localized
    }
    
    var cancelTitle: String {
        return  "CANCEL_BUTTON".localized
    }
    
    var nextTitle: String {
        return "NEXT_BUTTON".localized
    }
    
    var installmentPlansTitle: String {
        return "INSTALLMENT_INSTALLMENT_PLANS".localized
    }
    
    var payUpFrontTitle: String {
        return "INSTALLMENT_PAY_UPFRONT".localized
    }
    
    var purchaseFeeTitle: String {
        return "INSTALLMENT_PURCHASE_FEES".localized
    }
    
    var totalAmountUpfrontTitle: String {
        return "INSTALLMENT_TOTAL_AMOUNT_UPFRONT".localized
    }
    
    var downPaymentTitle: String {
        return "DOWN_PAYMENT".localized
    }
    
    var toUBalanceTitle: String {
        return "TO_U_BALANCE".localized
    }
    
    var cashbackTitle: String {
        return "CASHBACK_AMOUNT".localized
    }
    
    var monthsTitle: String {
        return "MONTHS".localized
    }
    
    var monthTitle: String {
        return "MONTH".localized
    }
    
    var choosePay: String {
        return "CHOOSE_HOW_PAY".localized
    }
    
    var cashSelectedTitle: String {
        return "CASH_PAYMWENT_OPTION".localized
    }
    
    var cardSelectedTitle: String {
        return "CARD_PAYMWENT_OPTION".localized
    }
    
    var souhoulaRangeLabel: String {
        return "INSTALLMENT_SOUHOOLA_RANGE".localized
    }
    

    var souhoulaAproxLabel: String {
        return "APROX_INSTALLMENT".localized
    }
    var souhoulaFinancedError: String {
        return "FINANCED_AMOUNT_ERROR".localized

    }
    
    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }

    init(custumerIdentifer: String?, amount: GDAmount?) {
        self.customerIdentifier = custumerIdentifer
        self.amount = amount
        super.init(screenTitle: "", isNavController: false)
    }
}

extension InstallmentViewModel {

    func isCustomerDetailsValid(params: GDPICustomer) -> GDErrorResponse? {
        
        if let safeEmail = params.email {
            guard safeEmail.isValidEmail else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E016.rawValue, code: GDErrorCodes.E016.description, detailedResponseMessage: GDErrorCodes.E016.detailedResponseMessage)
            }
        }
        
        return nil
    }
    
    func isAmountValid(amount: Double) -> GDErrorResponse? {
        
        guard amount >= 0 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage)
        }
        
        guard amount.decimalCount() <= 2 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage)
        }
        
        return nil
    }
    
    func getMinMax(limit: Double, minDownPayment: Double, souhoolaMinimumAmount: Int) -> (Double,Double) {
        var minAmount = 0.0
        var maxAmount = 0.0
        
        //MAX calculation
        if limit < amount?.amount ?? 0 {
            minAmount = (amount?.amount ?? 0) - limit
            minAmount = max(minAmount, minDownPayment)
        } else {
            minAmount = minDownPayment
        }
        
        
        maxAmount = (amount?.amount ?? 0) - Double(souhoolaMinimumAmount)
        
        if minAmount > maxAmount {
            return (maxAmount, minAmount)
        } else {
            return (minAmount, maxAmount)
        }
        
       
    }
    
    
    func isAmountNumeric(amount: String) -> GDErrorResponse? {
        
        if !amount.isEmpty {
            guard Double(amount) != nil else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E030.rawValue, code: GDErrorCodes.E030.description, detailedResponseMessage: GDErrorCodes.E030.detailedResponseMessage)
            }
        }
        
        
        return nil
    }
    
    func isSouhoolaDownPaymentValid(amount: String, min: Double, max: Double) -> GDErrorResponse? {
            
            if !amount.isEmpty {
                guard let amount = Double(amount) else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E030.rawValue, code: GDErrorCodes.E030.description, detailedResponseMessage: GDErrorCodes.E030.detailedResponseMessage)
                }
                
                guard amount >= min && amount <= max else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E033.rawValue, code: GDErrorCodes.E033.description, detailedResponseMessage: GDErrorCodes.E033.detailedResponseMessage)
                }

            }
            
            
            return nil
        }
}



