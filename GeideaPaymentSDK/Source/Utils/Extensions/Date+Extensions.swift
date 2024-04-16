//
//  Date+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/02/2021.
//

import Foundation

extension Date {
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

}
