//
//  AddressParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation
import PassKit

struct AddressConstants {
    static let countryCode = "countryCode"
    static let city = "city"
    static let street = "street"
    static let postcode = "postcode"
}

struct AddressParams: Codable {

    var countryCode: String?
    var city: String?
    var street: String?
    var postcode: String?
    
    init(from gdAddress: GDAddress?)  {
        guard let safeAddress = gdAddress else {
            return
        }
    
        self.countryCode = safeAddress.countryCode
        self.city = safeAddress.city
        self.street = safeAddress.street
        self.postcode = safeAddress.postCode
    }
    
    init(from pkContact: PKContact?)  {
        guard let safeAddress = pkContact?.postalAddress else {
            return
        }
    
        self.countryCode = safeAddress.isoCountryCode
        self.city = safeAddress.city.replacingOccurrences(of: "\n", with: " ")
        self.street =  safeAddress.street.replacingOccurrences(of: "\n", with: " ")
        self.postcode =  safeAddress.postalCode.replacingOccurrences(of: "\n", with: " ")
    }
    
    func toDictionary() -> [String: Any] {
        let dictionary = [AddressConstants.countryCode: countryCode,
                          AddressConstants.city: city,
                          AddressConstants.street: street,
                          AddressConstants.postcode: postcode] as [String : Any]
        
        
        return dictionary
    }
}
