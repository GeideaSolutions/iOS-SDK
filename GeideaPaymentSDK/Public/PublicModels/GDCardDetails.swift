//
//  PaymentMethod.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 22/10/2020.
//

import Foundation

@objc public class GDCardDetails: NSObject {
    
    var cardholderName: String
    var cardNumber: String
    var cvv:String 
    var expiryYear: Int
    var expiryMonth: Int
    
    @objc public init(withCardholderName cardholderName: String, andCardNumber cardNumber: String, andCVV cvv: String, andExpiryMonth expiryMonth: Int, andExpiryYear expiryYear: Int) {
        self.cardholderName = cardholderName
        self.cardNumber = cardNumber
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
    }
    
}

