//
//  SessionRequest.swift
//  GeideaPaymentSDK
//
//  Created by Virender on 28/03/24.
//

import Foundation

func decodeJSONString<T: Decodable>(_ jsonData: Data, as type: T.Type) -> T? {
    let decoder = JSONDecoder()
    return try? decoder.decode(type, from: jsonData)
}

struct SessionRequest: Codable {
    let amount: Double
    let currency, timestamp, merchantReferenceID, signature: String
    
    enum CodingKeys: String, CodingKey {
        case amount, currency, timestamp
        case merchantReferenceID = "merchantReferenceId"
        case signature
    }
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            let dict = try JSONSerialization.jsonObject(with: json, options: []) as! [String : Any]
            return dict
        } catch {
            return [:]
        }
        
    }
}
