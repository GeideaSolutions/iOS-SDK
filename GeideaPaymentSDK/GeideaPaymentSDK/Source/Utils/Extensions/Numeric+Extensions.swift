//
//  Numeric+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.04.2022.
//

import Foundation

extension Numeric {
    var data: Data {
        var bytes = self
        return .init(bytes: &bytes, count: MemoryLayout<Self>.size)
    }
}
