//
//  PurchseParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 23.02.2022.
//

import Foundation

struct PurchaseParams: Codable {

    var customerIdentifier = ""
    var orderId = ""
    var bnplOrderId = ""
    var otp = ""
    var totalAmount = 0.0
    var currency = ""
    var downPayment = 0.0
    var giftCardAmount = 0.0
    var campaignAmount = 0.0
    var tenure = 0
    
    var adminFees = 0.0

    init(params: GDBNPLPurchaseDetails?) {
        self.customerIdentifier = params?.customerIdentifier ?? ""
        self.totalAmount = params?.totalAmount ?? 0.0
        self.currency = params?.currency ?? "EGP"
        self.downPayment = params?.downPayment ?? 0.0
        self.giftCardAmount = params?.giftCardAmount ?? 0.0
        self.campaignAmount = params?.campaignAmount ?? 0.0
        self.tenure = params?.tenure ?? 0
        self.orderId = params?.orderId ?? ""
        self.bnplOrderId = params?.bnplOrderId ?? ""
        self.otp = params?.otp ?? ""
        self.adminFees = params?.adminFees ?? 0.0
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
