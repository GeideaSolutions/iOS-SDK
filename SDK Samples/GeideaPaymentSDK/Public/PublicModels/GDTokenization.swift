//
//  GDTokenization.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/01/2021.
//

import Foundation

@objc public class GDTokenization: NSObject {
    var cardOnFile: Bool
    var initiatedBy: String?
    var agreementId: String?
    var agreementType: String?
    
    @objc public init(withCardOnFile isCardOnFile: Bool, initiatedBy: String?, agreementId: String? = nil, agreementType: String? = nil) {
        self.cardOnFile = isCardOnFile
        self.initiatedBy = initiatedBy
        self.agreementId = agreementId
        self.agreementType = agreementType
    }
    
}
