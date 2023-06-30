//
//  KeyedDecodingContainer.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.04.2022.
//

import Foundation

extension KeyedDecodingContainer {
    func decode(_ type: Decimal.Type, forKey key: K) throws -> Decimal {
        try decode(Data.self, forKey: key).decode(codingPath, key: key)
    }
    func decodeIfPresent(_ type: Decimal.Type, forKey key: K) throws -> Decimal? {
        try decodeIfPresent(Data.self, forKey: key)?.decode(codingPath, key: key)
    }
}
