//
//  GDTokenisationDetails.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27/01/2021.
//

import Foundation

@objc public class GDTokenizationDetails: NSObject {
   public var cardOnFile: Bool = false
   public var initiatedBy: String?
   public var agreementId: String?
   public var agreementType: String?
public var subscriptionId: String?
    
    @objc public init(withCardOnFile isCardOnFile: Bool = false, initiatedBy: String? = nil, agreementId: String? = nil, agreementType: String? = nil, subscriptionId: String? = nil) {
        self.cardOnFile = isCardOnFile
        self.initiatedBy = initiatedBy
        self.agreementId = agreementId
        self.agreementType = agreementType
        self.subscriptionId = subscriptionId
    }
}
