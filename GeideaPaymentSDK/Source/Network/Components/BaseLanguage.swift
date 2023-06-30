//
//  BaseLanguage.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 23.08.2021.
//

import Foundation

@objc public enum Language:Int {
    case english
    case arabic 
    
    
    var name: String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
}

