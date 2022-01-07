//
//  Date+Extensions.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 19.07.2021.
//

import Foundation

extension Date {
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

}
