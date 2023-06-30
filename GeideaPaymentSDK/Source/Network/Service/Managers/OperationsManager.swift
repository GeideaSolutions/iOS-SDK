//
//  CaptureManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 08/12/2020.
//

import Foundation

class OperationsManager {
    typealias CaptureCompletionHandler = (GDOrderResponse?, GDErrorResponse?) -> Void
    
    func capture(with orderId: String, callbackUrl: String?, completion: @escaping CaptureCompletionHandler) {
        
        let request = Request(router: PaymentRouter.capture(captureParams: fromCaptureParams(from: orderId, callbackUrl: callbackUrl)))
        
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
            
            let payResponse = PayResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response.order, error)
        }
    }
    
    func refund(with orderId: String, callbackUrl: String?, completion: @escaping CaptureCompletionHandler) {
        
        let request = Request(router: PaymentRouter.refund(captureParams: fromCaptureParams(from: orderId, callbackUrl: callbackUrl)))
        
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
            let payResponse = PayResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response.order, error)
        }
    }
    
    private func fromCaptureParams(from orderId: String, callbackUrl: String?) -> CaptureParams {
        var captureParams = CaptureParams()
        captureParams.orderId = orderId
        if let callback = callbackUrl, callback.isEmpty {
            captureParams.callBackUrl = nil
        } else {
            captureParams.callBackUrl = callbackUrl
        }
       
        return captureParams
    }
}

