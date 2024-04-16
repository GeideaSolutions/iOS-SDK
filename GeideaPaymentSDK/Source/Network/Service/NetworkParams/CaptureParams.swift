//
//  CaptureParams.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 08/12/2020.
//

import Foundation

struct CaptureParams: Codable {
    var orderId = ""
    var callBackUrl: String? = nil
    var source = Constants.source
    var language = GlobalConfig.shared.language.name.uppercased()
    
    init() {}
    
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
