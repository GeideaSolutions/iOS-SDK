//
//  PaymentMethodResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27/10/2020.
//

import Foundation

@objcMembers public class GDPaymentMethodResponse: NSObject, Codable {
 
    public var type: String?
    public var brand: String?
    public var cardholderName: String?
    public var maskedCardNumber: String?
    public var wallet: String?
    public var expiryDate: ExpiryDateParams?
    public var meezaTransactionId: String?
    public var meezaSenderId: String?
}
