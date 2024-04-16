//
//  RecurreceParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 21.07.2022.
//

import Foundation

struct RecurrenceParams: Codable {

     var amount = 0.0
     var currency: Double?
     var cycleInterval: String? = nil
     var frequency = 0
     var startDate: String? = nil
     var endDate: String? = nil
     var numberOfPayments = 0
     var minimumDaysBetweenPayments = 0
     var description: String? = nil

    init(recurrence: GDRecurrence?) {
        self.amount = recurrence?.amount ?? 0
        self.currency = recurrence?.currency
        self.cycleInterval = recurrence?.cycleInterval
        self.startDate = recurrence?.startDate
        self.endDate = recurrence?.endDate
        self.numberOfPayments = recurrence?.numberOfPayments ?? 0
        self.minimumDaysBetweenPayments = recurrence?.minimumDaysBetweenPayments ?? 0
        self.description = recurrence?.recurrenceDescription
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
