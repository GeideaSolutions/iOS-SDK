//
//  GDAddress.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 23/10/2020.
//

import Foundation

@objc public class GDAddress: NSObject, Codable {
    
    var countryCode: String?
    var city: String?
    var street: String?
    var postCode: String?
    
    @objc public override init() {}
    
    @objc public init(withCountryCode countryCode: String?, andCity city: String?, andStreet street: String?, andPostCode postCode: String?) {
       
        if let safeCountryCode = countryCode, safeCountryCode.isEmpty {
            self.countryCode = nil
        } else {
            self.countryCode = countryCode?.uppercased()
        }
        if let safeCity = city, safeCity.isEmpty {
            self.city = nil
        } else {
            self.city = city
        }
        if let safeStreet = street, safeStreet.isEmpty {
            self.street = nil
        } else {
            self.street = street
        }
        if let safePostCode = postCode, safePostCode.isEmpty {
            self.postCode = nil
        } else {
            self.postCode = postCode
        }
    }
}
