//
//  GDPaymentIntentCustomer.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 15.07.2021.
//

import Foundation

@objc public class GDPICustomer: NSObject, Codable {
    public var customerId: String?
    public var name: String?
    public var email: String?
    public var phoneNumber: String?
    public var phoneCountryCode: String?
    
    // ADDED as last resort because of meeeza refactoring at the last day. TODO: split meeza GDPIcustomer to actual GDPIcustomer
    public var qrCode: String?
    public var paymentIntentId: String?
    
    @objc public init(phoneNumber:String?, andPhoneCountryCode phoneCountryCode:String?, andEmail email:String? =  nil , name: String? = nil) {
        
        if  let safeName = name,
            safeName.isEmpty {
            self.name = nil
        } else {
            self.name = name
        }
        
        self.email = email
        self.phoneNumber = phoneNumber
        self.phoneCountryCode = phoneCountryCode
    }
    
}
