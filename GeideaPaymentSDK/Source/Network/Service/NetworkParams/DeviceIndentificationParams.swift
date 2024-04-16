//
//  DeviceIndentificationParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.08.2022.
//

import Foundation
import UIKit


struct DeviceIndentificationParams: Codable {
    
    var userAgent = Utils.getBrowser()
    var language:String? = GlobalConfig.shared.language.name.lowercased()
    var providerDeviceId =  UIDevice.current.identifierForVendor?.uuidString ?? ""
    
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
