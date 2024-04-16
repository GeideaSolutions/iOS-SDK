//
//  InstallmentPlansParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

struct InstallmentPlanParams: Codable {

    var customerIdentifier = ""
    var totalAmount = 0.0
    var currency = ""
    var downPayment = 0.0
    var giftCardAmount = 0.0
    var campaignAmount = 0.0

    init(params: GDInstallmentPlanDetails?) {
        self.customerIdentifier = params?.customerIdentifier ?? ""
        self.totalAmount = params?.totalAmount.rounded(toPlaces: 2) ?? 0.0
        self.currency = params?.currency ?? "EGP"
        self.downPayment = params?.downPayment.rounded(toPlaces: 2) ?? 0.0
        self.giftCardAmount = params?.giftCardAmount.rounded(toPlaces: 2) ?? 0.0
        self.campaignAmount = params?.campaignAmount.rounded(toPlaces: 2) ?? 0.0
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
