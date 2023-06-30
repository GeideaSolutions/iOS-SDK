//
//  BNPLShahryViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 28.03.2022.
//

import Foundation
import UIKit

enum BNPShahryFlow {
    case CONFIRM_SHAHRY
    case PURCHASE_SHAHRY
    case PAYMENT
    case CARD_DETAILS
    case QR

}

class BNPLShahryViewModel: ViewModel {

    var currentFlow: BNPShahryFlow = .CONFIRM_SHAHRY
    var selectPaymentVM: SelectPaymentMethodViewModel
    var customerId: String?
    
    var confirmTitle: String {
        return "INSTALLMENT_STEP_CONFIRM_SHAHRY_TITLE".localized
    }

    var purchaseTitle: String {
        return "INSTALLMENT_STEP_SHAHRY_PURCHASE_TITLE".localized
    }

    var paymentTitle: String {
        return "INSTALLMENT_STEP_PAYMENT_TITLE".localized
    }

    var requestToPayButton: String {
        return "QR_PAYMENT_BUTTON".localized
    }

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
    
    func goToNextScren() {
        switch currentFlow {
        case .CONFIRM_SHAHRY:
            break
        case .PURCHASE_SHAHRY:
            break
        case .PAYMENT:
            break
        case .CARD_DETAILS:
            break
        case .QR:
            break
        }
    }
    
    func goToPreviousScren() {
        switch currentFlow {
            case .CONFIRM_SHAHRY:
            currentFlow = .CONFIRM_SHAHRY
        case .PURCHASE_SHAHRY:
            currentFlow = .CONFIRM_SHAHRY
        case .PAYMENT:
            currentFlow = .PURCHASE_SHAHRY
        case .CARD_DETAILS:
            currentFlow = .PAYMENT
        case .QR:
            currentFlow = .PAYMENT
        }
    }
    
    init(selectPaymentVM: SelectPaymentMethodViewModel, isNavController: Bool,  completion: @escaping PaymentFormCompletionHandler) {
        self.selectPaymentVM = selectPaymentVM
        
        super.init(screenTitle: "", isNavController: isNavController)
        
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
    
    
}
