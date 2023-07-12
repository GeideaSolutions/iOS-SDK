//
//  ExpiryTimeParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/10/2020.
//

import Foundation

struct ExpireDateConstants {
    static let month = "month"
    static let year = "year"
}

public struct ExpiryDateParams: Codable {

    public var month = 0
    public  var year = 0
    
    init() {}
    
    func toDictionary() -> [String: Any] {
        let dictionary = [ExpireDateConstants.month: month,
                          ExpireDateConstants.year: year] as [String : Any]
        
        
        return dictionary
    }
}

