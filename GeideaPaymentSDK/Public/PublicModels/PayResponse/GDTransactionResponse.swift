//
//  TransactionResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/10/2020.
//

import Foundation

@objcMembers public class GDTransactionResponse: NSObject, Codable {

    public var authenticationDetails: GDAuthenticationDetailsResponse?
    public var amount = 0.0
    public var createdDate: String?
    public var createdBy: String?
    public var updatedDate: String?
    public var updatedBy: String?
    public var transactionId: String?
    public var type: String?
    public var status: String?
    public var currency: String?
    public var source: String?
    public var authorizationCode: String?
    public var rrn: String?
    public var paymentMethod: GDPaymentMethodResponse?
    public var codes: GDCodesResponse?
    public var postilionDetails: GDPostilionDetails?
    public var terminalDetails: GDTerminalDetails?
    public var meezaDetails: GDMeezaDetails?
    public var bnplDetails: GDBNPLDetails?
    public var correlationId: String?
    
}

