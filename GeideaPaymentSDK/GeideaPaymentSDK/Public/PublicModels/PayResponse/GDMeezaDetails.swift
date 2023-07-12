//
//  GDMeezaDetails.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14.09.2021.
//

import Foundation

@objcMembers public class GDMeezaDetails: NSObject, Codable {
    public var transactionId: String?
    public var meezaTransactionId: String?
    public var type: String?
    public var transactionTimeStamp: String?
    public var adviceId: String?
    public var senderId: String?
    public var senderName: String?
    public var senderAddress: String?
    public var receiverId: String?
    public var receiverName: String?
    public var receiverAddress: String?
    public var amount = 0.0
    public var currency: String?
//    public var description: String?
    public var responseCode: String?
    public var responseDescription: String?
    public var interchange = 0.0
    public var interchangeAction: String?
    public var reference1: String?
    public var reference2: String?
    public var tips =  0.0
    public var convenienceFee = 0.0
    
}
