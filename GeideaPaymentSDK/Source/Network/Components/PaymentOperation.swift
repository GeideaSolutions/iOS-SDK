//
//  PaymentOperation.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 07/12/2020.
//

import Foundation

@objc public enum PaymentOperation:Int, Codable {
    case pay 
    case preAuthorize
    case authorizeCapture
    case NONE
    
    var paymentOperation: String? {
        switch self {
        case .pay:
            return "Pay"
        case .preAuthorize:
            return "PreAuthorize"
        case .authorizeCapture:
            return "AuthorizeCapture"
        case .NONE:
            return nil
        }
    }
    
}


