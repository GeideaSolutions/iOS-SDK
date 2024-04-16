//
//  SessionResponse.swift
//  GeideaPaymentSDK
//
//  Created by Virender on 28/03/24.
//

import Foundation

struct SessionResponse: Codable {
    let session: Session
}

struct Session: Codable {
    let id: String
    let amount: Int
    let currency: String
}
