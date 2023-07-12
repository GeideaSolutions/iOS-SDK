//
//  DoubleExtensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/10/2020.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func decimalCount() -> Int {
           if self == Double(Int(self)) {
               return 0
           }

           let integerString = String(Int(self))
           let doubleString = String(Double(self))
           let decimalCount = doubleString.count - integerString.count - 1

           return decimalCount
       }
}
