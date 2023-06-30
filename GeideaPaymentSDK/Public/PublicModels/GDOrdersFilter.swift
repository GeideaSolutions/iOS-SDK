//
//  GDOrdersFilter.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 01/03/2021.
//

import Foundation

@objcMembers public class GDOrdersFilter: NSObject, Codable {
   public var DetailedStatuses: [String]?
   public var Status: String?
   public var UpdatedDate: String?
   public var FromDate: String?
   public var ToDate: String?
   public var Skip: Int = 0
   public var Take: Int = 20
    
    @objc public init(withStatus status: String? = nil, andDetailedStatuses detailedStatuses: [String]? = nil,andUpdatedDate updatedDate: String? = nil, from fromDate: String? = nil, to toDate: String? = nil, skip: Int = 0, take: Int = 20) {
        self.DetailedStatuses = detailedStatuses
        self.Status = status
        self.UpdatedDate = updatedDate
        self.FromDate = fromDate
        self.ToDate = toDate
        self.Skip = skip
        self.Take = take
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
