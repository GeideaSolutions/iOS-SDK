//
//  ProductManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 28.09.2021.
//

import Foundation

class ProductManager {
    
    typealias QRCompletionHandler = (GDQRResponse?, GDErrorResponse?) -> Void
    
    func getMerchantConfig(productMConfig: GDSDKMerchantConfig, completion: @escaping QRCompletionHandler) {
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
            
            let payResponse = GDQRResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
        }
    }
}
