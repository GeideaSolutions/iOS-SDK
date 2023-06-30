//
//  GDRecurrence.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 21.07.2022.
//

import Foundation


@objcMembers public class GDRecurrence: NSObject, Codable {

    public var amount = 0.0
    public var currency: Double?
    public var cycleInterval: String?
    public var frequency = 0
    public var startDate: String?
    public var endDate: String?
    public var numberOfPayments = 0
    public var minimumDaysBetweenPayments = 0
    public var recurrenceDescription: String?
}
