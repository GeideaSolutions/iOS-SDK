//
//  PaymentMethodParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation

struct PaymentMethodConstants {
    static let cardholderName = "cardholderName"
    static let cardNumber = "cardNumber"
    static let cvv = "cvv"
    static let expiryDate = "expiryDate"
}

struct PaymentMethodParams: Codable {

    var cardholderName = ""
    var cardNumber = ""
    var cvv = ""
    var expiryDate = ExpiryDateParams()
    
    
    init() {}
    
    func toDictionary() -> [String: Any] {
        let dictionary = [PaymentMethodConstants.cardholderName: cardNumber,
                          PaymentMethodConstants.cardNumber: cardNumber,
                          PaymentMethodConstants.cvv: cvv,
                          PaymentMethodConstants.expiryDate: expiryDate] as [String : Any]
        
        
        return dictionary
    }
    
    func fromCardDetails(cardDetails: GDCardDetails) -> PaymentMethodParams {
        var paymentMethod = PaymentMethodParams()

        paymentMethod.cardholderName = cardDetails.cardholderName
        paymentMethod.cvv = cardDetails.cvv
        paymentMethod.cardNumber = cardDetails.cardNumber
        
        var expiryDateParams = ExpiryDateParams()
        expiryDateParams.month = cardDetails.expiryMonth
        expiryDateParams.year = cardDetails.expiryYear
        
        paymentMethod.expiryDate = expiryDateParams
        return paymentMethod
    }
}

