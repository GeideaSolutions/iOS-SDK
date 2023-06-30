//
//  AuthenticationDetailsResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27/10/2020.
//

import Foundation

@objcMembers public class GDAuthenticationDetailsResponse: NSObject, Codable {
 
    public var acsEci: String?
    public var paResStatus: String?
    public var proofXml: String?
    public var veResEnrolled: String?
    public var authenticationToken: String?
    public var xid: String?
    public var accountAuthenticationValue: String?
    
}


