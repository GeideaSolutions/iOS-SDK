//
//  Decimal+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.04.2022.
//

import Foundation

fileprivate let currencyBehavior = NSDecimalNumberHandler(roundingMode: .bankers, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)

extension Decimal {
    var roundedCurrency: Decimal {
        return (self as NSDecimalNumber).rounding(accordingToBehavior: currencyBehavior) as Decimal
    }
}
