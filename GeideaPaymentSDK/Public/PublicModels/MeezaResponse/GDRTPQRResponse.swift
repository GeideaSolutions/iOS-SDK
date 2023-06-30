//
//  GDQRPaymentResponse.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 22.07.2021.
//

import Foundation

@objcMembers public class GDRTPQRResponse: NSObject, Codable {

    public var responseDescription: String?
    public var receiverName: String?
    public var receiverAddress: String?
    public var responseCode: String?
    
    override init() {}
    
    func parse(json: Data) -> GDRTPQRResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GDRTPQRResponse.self, from: json)
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
