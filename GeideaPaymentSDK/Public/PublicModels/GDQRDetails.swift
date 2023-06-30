//
//  GDQRDetails.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 06.12.2021.
//

import Foundation

@objc public class GDQRDetails: NSObject, Codable {
//    public var qrCustomerDetails: GDPICustomer? = nil
    public var name: String?
    public var email: String?
    public var phoneNumber: String?
    public var phoneCountryCode: String?
    public var qrExpiryDate: String? = nil
    
    @objc public init( phoneNumber: String?,  email: String? = nil,name: String? = nil, expiryDate: String? = nil) {
        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.phoneCountryCode = "+20"
        self.qrExpiryDate = expiryDate
    }
    
}
