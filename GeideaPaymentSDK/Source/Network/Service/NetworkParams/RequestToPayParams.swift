//
//  RequestToPayParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21.07.2021.
//

import Foundation

struct RequestToPayParams: Codable {
    var MerchantPublicKey: String?
    var QRCodeMessage: String?
    var ReceiverId: String?
    var orderId: String?
//    var language = GlobalConfig.shared.language.name.uppercased()
    
    init(receiverId: String, qrCodeMessage: String, orderId: String?) {
        guard let merchantKey = GeideaPaymentAPI.shared.getCredentials()?.0, !merchantKey.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E001.rawValue, code: GDErrorCodes.E001.description, detailedResponseMessage: GDErrorCodes.E001.detailedResponseMessage))
            return
        }
        self.MerchantPublicKey = merchantKey
        self.QRCodeMessage = qrCodeMessage
        self.ReceiverId = receiverId
        self.orderId = orderId
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

