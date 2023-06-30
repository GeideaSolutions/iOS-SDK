//
//  PaymentMethod.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 24/11/2020.
//

import Foundation

struct PaymentMehodConstants {
    static let month = "month"
    static let year = "year"
}

public struct PaymentMehodParams: Codable {

    public var month = 0
    public  var year = 0
    
    init() {}
    
    func toDictionary() -> [String: Any] {
        let dictionary = [ExpireDateConstants.month: month,
                          ExpireDateConstants.year: year] as [String : Any]
        
        
        return dictionary
    }
}
