//
//  OTPViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 24.05.2022.
//

import Foundation

import UIKit

class OTPViewModel: ViewModel {
    
    var doneTitle: String {
        return  "DONE_BUTTON".localized
    }
    
    var nextTitle: String {
        return "NEXT_BUTTON".localized
    }
    
    var OTPDescriptionTitle: String {
        return "INSTALLMENT_OTP_DESCRIPTION".localized
    }
    
    var resendTitle: String {
        return "INSTALLMENT_OTP_RESEND_TITLE".localized
    }
    
    var resendBtnTitle: String {
        return "INSTALLMENT_OTP_RESEND_BUTTON".localized
    }
    
    var purchaseBtnTitle: String {
        return "INSTALLMENT_CONFIRM_FINAL".localized
    }
    
    var timeRemainingTitle: String {
        return "INSTALLMENT_OTP_REMAINING".localized
    }
    
    var attemptsLeftTitle: String {
        return "INSTALLMENT_OTP_ATTEMPTS".localized
    }
    
    var secondsTitle: String {
        return "INSTALLMENT_OTP_SECONDS".localized
    }
}




