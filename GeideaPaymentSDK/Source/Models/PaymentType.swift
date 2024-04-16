//
//  PaymentMethod.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 09.08.2021.
//

import Foundation


@objc public enum PaymentType: Int {
    case Card, QR, ValU, Shahry, Souhoola, BNPLGroup

    var paymentTypeName : String {
        switch self {
        case .Card:
            return "PAYMENT_SELECTION_CARD".localized
        case .QR:
           return "PAYMENT_SELECTION_QR_CODE".localized
        case .ValU:
           return "PAYMENT_SELECTION_VAL_U".localized
        case .Shahry:
           return "PAYMENT_SELECTION_SHAHRY".localized
        case .Souhoola:
           return "PAYMENT_SELECTION_SOUHOOLA".localized
        case .BNPLGroup:
           return "PAYMENT_SELECTION_BNPL".localized 
        default:
           return ""
        }
    }
    
}
