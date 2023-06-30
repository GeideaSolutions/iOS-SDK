//
//  GDVerifyCustomer.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 16.02.2022.
//

import Foundation

@objc public class GDVerifyCustomerDetails: NSObject {
    
    public var customerIdentifier: String?
    
    @objc public init(customerIdentifier: String?) {
        self.customerIdentifier = customerIdentifier

    }
}
