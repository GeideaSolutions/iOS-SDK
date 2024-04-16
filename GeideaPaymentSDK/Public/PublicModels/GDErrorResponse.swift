//
//  GDError.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 23/10/2020.
//

import Foundation

public struct SDKErrorConstants {
    static let GENERAL_TITLE = "Payment Error"
    static let SESSION_ERROR = "Can't create session"
    static let GENERAL_ERROR = "SDK General Error"
    static let NETWORK_ERROR = "Network Connection Error"
    static let PARSING_ERROR = "SDK Parsing Error"
    static let NAV_ERROR = "Geidea Form not allow pushing on navigation controller"
    static let CREDENTIALS_STORE_ERROR = " SDK Failed to store credentials"
    static let CREDENTIALS_RETREIVE_ERROR = "SDK Failed to get credentials"
    static let CREDENTIALS_REMOVE_ERROR = "SDK Failed to remove credentials"
    static let APPLE_PAY_BUTTON_VIEW_ERROR = " An UIVIew for ApplePay button is mandatory"
    static let APPLE_PAY_HOST_ERROR = " An UIVIewController as a host is Mandatory"
}

struct GDErrorConstants {
    static let errors = "errors"
    static let status = "status"
    static let title = "title"
    static let traceId = "traceId"
    static let type = "type"
    static let responseCode = "responseCode"
    static let responseMessage = "responseMessage"
    static let detailedResponseCode = "detailedResponseCode"
    static let detailedResponseMessage = "detailedResponseMessage"
    static let responseDescription = "responseDescription"
    static let orderId = "orderId"
}

@objcMembers public class GDErrorResponse: NSObject {
    
    public var errors = [String: [String]]()
    public var status = 0
    public var title = SDKErrorConstants.GENERAL_ERROR
    public var traceId = ""
    public var type = ""
    public var responseCode = ""
    public var responseMessage = ""
    public var detailedResponseCode = ""
    public var detailedResponseMessage = ""
    public var responseDescription = ""
    public var orderId = ""
    public var correlationId = ""
    var isError = false
    
    override init() {}
    
    init(status: String, title: String) {
        self.status = Int(status) ?? 0
        self.title = title
    }
    
    func withResponse(response: Response) -> GDErrorResponse? {
        guard let data = response.data, let json = try? JSON.dataToJson(data).toDictionary() else {
            return nil
        }
        
        if let errorResponseCode = json[GDErrorConstants.responseCode] as? String, errorResponseCode != "000", errorResponseCode != "00000"  {
            isError = true
            title = json[GDErrorConstants.detailedResponseMessage] as? String ?? ""
            responseMessage = json[GDErrorConstants.responseMessage] as? String ?? ""
            responseCode = json[GDErrorConstants.responseCode] as? String ?? ""
            detailedResponseCode = json[GDErrorConstants.detailedResponseCode] as? String ?? ""
            detailedResponseMessage = json[GDErrorConstants.detailedResponseMessage] as? String ?? ""
            responseDescription = json[GDErrorConstants.responseDescription] as? String ?? ""
            orderId = json[GDErrorConstants.orderId] as? String ?? ""
            correlationId = response.headers?["x-correlation-id"] ?? ""
            return self
        }
        
        if json[GDErrorConstants.status]  == nil {
            isError = false
            return nil
        }
        
        status = json[GDErrorConstants.status] as? Int ?? 0
        errors = json[GDErrorConstants.errors] as? [String:[String]] ?? [:]
        title = json[GDErrorConstants.title] as? String ?? ""
        traceId = json[GDErrorConstants.traceId] as? String ?? ""
        type = json[GDErrorConstants.type] as? String ?? ""
        
        if status == 400 {
            isError = true
        }
        return self
    }
    func withError(error: String) -> GDErrorResponse {
        self.title = SDKErrorConstants.GENERAL_TITLE
        self.responseMessage = error
        return self
    }
    
    func withErrorCode(title: String = SDKErrorConstants.GENERAL_TITLE,error: String, code: String, detailedResponseMessage: String = "", orderId: String = "") -> GDErrorResponse {
        self.title = title
        self.responseMessage  = error
        self.responseCode  = code
        self.detailedResponseCode = ""
        self.detailedResponseMessage = detailedResponseMessage
        self.orderId = orderId
        return self
    }
    
    func withCancelCode(responseMessage: String, code: String, detailedResponseCode: String, detailedResponseMessage: String = "", orderId:String) -> GDErrorResponse {
        self.title = ""
        self.responseMessage  = responseMessage
        self.responseCode  = code
        self.detailedResponseCode = detailedResponseCode
        self.detailedResponseMessage = detailedResponseMessage
        self.orderId = orderId
        return self
    }
}
