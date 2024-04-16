//
//  CodesResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27/10/2020.
//

import Foundation

@objcMembers public class GDCodesResponse: Codable {
 
    public var acquirerCode: String?
    public var acquirerMessage: String?
    public var responseCode: String?
    public var responseMessage: String?
    public var detailedResponseCode: String?
    public var detailedResponseMessage: String?
    
    init() {}
    
}
