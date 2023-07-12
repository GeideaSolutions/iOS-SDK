//
//  DeviceIndentificationParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.08.2022.
//

import Foundation
import UIKit


struct DeviceIndentificationParams: Codable {
    
    var browser = Utils.getBrowser()
    var customerIp: String? = nil
    var colorDepth = Utils.getColorDepth()
    var language:String? = GlobalConfig.shared.language.name.lowercased()
    var timezoneOffset = Utils.getTimezoneOffset()
    var screenHeight = Utils.getScreenHeight()
    var screenWidth = Utils.getScreenWidth()
    var javaEnabled: Bool = false
    var javaScriptEnabled = true
    var providerDeviceId =  UIDevice.current.identifierForVendor?.uuidString ?? ""
    var acceptHeaders: String? = "accept"
    var challangeSize: String? = "FULL_SCREEN"
    
    
    private enum CodingKeys: String, CodingKey {
        case browser
        case customerIp
        case colorDepth
        case language
        case timezoneOffset
        case screenHeight
        case screenWidth
        case javaEnabled
        case javaScriptEnabled
        case providerDeviceId
        case acceptHeaders
        case challangeSize = "3DSecureChallengeWindowSize"
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
