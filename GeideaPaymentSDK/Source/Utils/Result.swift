//
//  Result.swift
//  GeideaPaymentSampleSwift
//
//  Created by euvid on 13/10/2020.
//

import Foundation

enum Result<SuccessType: Equatable, ErrorType: Equatable>: Equatable {
    case success(SuccessType)
    case error(ErrorType)
}

func ==<SuccessType, ErrorType> (left: Result<SuccessType, ErrorType>, right: Result<SuccessType, ErrorType>) -> Bool {
    switch (left, right) {
    case (.success(let lValue), .success(let rValue))    where lValue == rValue: return true
    case (.error(let lError), .error(let rError))        where lError == rError: return true
    default: return false
    }
}
