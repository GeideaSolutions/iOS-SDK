//
//  ConfigManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

class ConfigManager {
    
    typealias ConfigCompletionHandler = (GDConfigResponse?, GDErrorResponse?) -> Void
    typealias SDDKConfigCompletionHandler = ([GDSDKMerchantConfigResponse]?, GDErrorResponse?) -> Void
    
    func getConfig(completion: @escaping ConfigCompletionHandler) {
        guard let merchantKey = GeideaPaymentAPI.shared.getCredentials()?.0, !merchantKey.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E001.rawValue, code: GDErrorCodes.E001.description, detailedResponseMessage: GDErrorCodes.E001.detailedResponseMessage))
            return
        }
        let request = Request(router: ConfigRouter.getMerchantConfig(merchantKey: merchantKey.trimmingCharacters(in: .whitespacesAndNewlines)))
        request.sendAsync { response, error in
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
            
            let configResponse = GDConfigResponse().parse(json: data )
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func getConfig( productMConfig: GDSDKMerchantConfig?,completion: @escaping SDDKConfigCompletionHandler) {

        let request = Request(router: ProductRouter.getMerchantConfig(params: productMConfig))
        request.sendAsync { response, error in
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data  = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                return
            }
     
            let configResponse = GDSDKMerchantConfigResponse().parse(json: data)
                guard let response = configResponse else {
                    guard let data  = res.data else {
                        completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
                        return
                    }
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        completion( nil, GDErrorResponse().withError(error: "\(json)" ))
                    } else {
                        completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                    }
                  
                    return
                }
                
                completion(response, error)
            }
            
           
        }
    }

