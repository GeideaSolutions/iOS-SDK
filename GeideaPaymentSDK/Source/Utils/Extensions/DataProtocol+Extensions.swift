//
//  DataProtocol+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.04.2022.
//

import Foundation

extension DataProtocol {
func decode<T: Numeric>(_ codingPath: [CodingKey], key: CodingKey) throws -> T {
        var value: T = .zero
        guard withUnsafeMutableBytes(of: &value, copyBytes) == MemoryLayout.size(ofValue: value) else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "The key \(key) could not be converted to a numeric value: \(Array(self))"))
        }
        return value
    }
}
