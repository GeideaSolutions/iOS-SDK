//
//  GDTerminalDetails.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14.09.2021.
//

import Foundation

@objcMembers public class GDTerminalDetails: NSObject, Codable {

    public var tid: String?
    public var mid: String?
    public var transactionNumber: String?
    public var transactionCreateDateTime: String?
    public var merchantReferenceId: String?
    public var transactionType: String?
    public var transactionOutcome: String?
    public var providerGateId: String?
    public var paymentWay: String?
    public var reconciliationKey: String?
    public var transactionReceiveDateTime: String?
    public var transactionSentDateTime: String?
    public var status: String?
    public var message: String?
    public var approvalCode: String?
    public var responseCode: String?
}
