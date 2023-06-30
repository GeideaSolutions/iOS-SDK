//
//  GDBranding.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.08.2022.
//

import Foundation
import UIKit


@objcMembers public class GDBrandingResponse: NSObject, Codable {

    var accentTextColor: String? = nil
    var headerColor: String? = nil
    var backgroundTextColor: String? = nil
    var accentColor: String? = nil
    var backgroundColor:String? = nil
    var logoPublicUrl:String? = nil
    
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
