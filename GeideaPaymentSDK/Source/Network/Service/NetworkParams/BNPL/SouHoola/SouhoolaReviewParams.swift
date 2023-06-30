//
//  SouhoolaReviewParams.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 09.05.2022.
//

import Foundation



struct SouhoolaReviewParams: Codable {
    
    public var customerIdentifier: String?
    public var customerPin: String?
    public var totalAmount = 0.0
    public var currency: String?
    public var downPayment = 0.0
    public var tenure = 0
    public var minimumDownPaymentTenure = 0.0
    public var promoCode: String?
    public var approvedLimit = 0.0
    public var outstanding = 0.0
    public var availableLimit = 0.0
    public var minLoanAmount = 0.0
    public var items: [SouhoolaItemParams]?
    public var source: String = Constants.source
    public var language = GlobalConfig.shared.language.name.uppercased()

    init(publicSouhoola: GDSouhoolaReviewTransaction?) {
        self.customerIdentifier = publicSouhoola?.customerIdentifier
        self.customerPin = publicSouhoola?.customerPin
        self.totalAmount = publicSouhoola?.totalAmount ?? 0
        self.currency = publicSouhoola?.currency
        self.downPayment = publicSouhoola?.downPayment ?? 0
        self.tenure = publicSouhoola?.tenure ?? 0
        self.minimumDownPaymentTenure = publicSouhoola?.minimumDownPaymentTenure ?? 0
        self.promoCode = publicSouhoola?.promoCode ?? ""
        self.approvedLimit = publicSouhoola?.approvedLimit ?? 0
        self.outstanding = publicSouhoola?.outstanding ?? 0
        self.approvedLimit = publicSouhoola?.approvedLimit ?? 0
        self.availableLimit = publicSouhoola?.availableLimit ?? 0
        self.minLoanAmount = publicSouhoola?.minLoanAmount ?? 0
        


        var items = [SouhoolaItemParams]()
        if let safeItems = publicSouhoola?.items {
            for item in safeItems {
                items.append(SouhoolaItemParams(item: item))
            }
            self.items = items
        }
        
        
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
