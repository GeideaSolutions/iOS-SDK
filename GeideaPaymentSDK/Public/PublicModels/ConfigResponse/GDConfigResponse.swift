//
//  ConfigResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/10/2020.
//

import Foundation

@objcMembers public class GDConfigResponse: NSObject, Codable {
    
    public var hppDefaultTimeout = 1800
    public var countries: [ConfigCountriesResponse]?
    public var is3dsV2Enabled: Bool?
    public var isTokenizationEnabled: Bool = false
    public var isCallbackEnabled: Bool = false
    public var isPaymentMethodSelectionEnabled: Bool = false
    public var isTransactionReceiptEnabled: Bool = false
    public var isValuBnplEnabled: Bool = false
    public var valUMinimumAmount: Int?
    public var isOfflineShahryBnplEnabled: Bool? = false
    public var isShahryCnpBnplEnabled: Bool = false
    public var isShahryCpBnplEnabled: Bool = false
    public var isSouhoolaCnpBnplEnabled: Bool = false
    public var souhoolaMinimumAmount: Int?
    public var isMeezaQrEnabled: Bool = false
    public var useMpgsApiV60: Bool = false
//    public var merchantPaymentNotification: Bool = false
//    public var customerPaymentNotification: Bool = false
    public var merchantNotificationEmail: String?
    public var detailedResponseMessage: String?
    public var detailedResponseCode: String?
    public var responseMessage: String?
    public var responseCode: String?
    public var language: String?
    public var merchantName: String?
    public var merchantNameAr: String?
    public var merchantLogoUrl: String?
    public var merchantCountryTwoLetterCode: String?
    public var name: String?
    public var applePay: GDConfigApplePay?
    public var paymentMethods: [String]?
    public var currencies: [String]?
    public var allowedInitiatedByValues: [String]?
    public var cardBrandAuthentications: [GDCardBrandAuthentication]?
    public var allowCashOnDeliveryShahry: Bool = false
    public var allowCashOnDeliverySouhoola: Bool = false
    public var allowCashOnDeliveryValu: Bool = false
    public var is3dsRequiredForTokenPayments: Bool = false
    public var isCvvRequiredForTokenPayments: Bool = false
    public var branding: GDBrandingResponse? = nil
   
    
    override init() {}
    
    func parse(json: Data) -> GDConfigResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDConfigResponse.self, from: json)
            return response
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return nil
    }
}
