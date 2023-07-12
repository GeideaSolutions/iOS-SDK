//
//  KeyEncodingContainer.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.04.2022.
//

import Foundation

extension KeyedEncodingContainer {
    mutating func encode(_ value: Decimal, forKey key: K) throws {
        try encode(value.data, forKey: key)
    }
    mutating func encodeIfPresent(_ value: Decimal?, forKey key: K) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }
}
