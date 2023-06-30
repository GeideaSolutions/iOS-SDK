//
//  GDEInvoiceSentLink.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.11.2021.
//

import Foundation

@objcMembers public class GDEInvoiceSentLink: NSObject, Codable {
    public var sentDate: String?
    public var channel : String?
    public var recipient : String?
}
