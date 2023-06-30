//
//  GDPlatformResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14.09.2021.
//

import Foundation

@objcMembers public class GDPlatform: NSObject, Codable {

    public var integrationType: String?
    public var name: String?
    public var version: String?
    public var pluginVersion: String?
    public var partnerId: String?
    
}
