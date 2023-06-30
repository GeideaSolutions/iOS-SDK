//
//  GDWSConstants.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

enum GDWSConstants {
    
    enum ContentType {
        static let json = "application/json"
    }
    
    enum HeaderKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
        static let accept = "Accept"
        static let acceptEncoding = "Accept-Encoding"
        static let connection = "Connection"
        static let host = "Host"
        static let counterPartyCode = "X-CounterPartyCode"
        static let language = "x-language"
    }
}
