//
//  ApplePayResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 11/02/2021.
//

import Foundation

@objc public class GDConfigApplePay: NSObject, Codable {
    
    public var paymentProcessingCertificateExpiryDate: String?
    public var isApplePayMobileCertificateAvailable: Bool = true
    public var isApplePayWebEnabled: Bool = true
    public var isApplePayMobileEnabled: Bool = true
    
    @objc public override init() {}
    
    func parse(json: Data) -> GDConfigApplePay? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDConfigApplePay.self, from: json)
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
