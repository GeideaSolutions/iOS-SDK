//
//  QRManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.07.2021.
//

import Foundation

class QRMeezaPaymentManager {
    
    typealias QRCompletionHandler = (GDQRResponse?, GDErrorResponse?) -> Void
    typealias MessageCompletionHandler = (String?, GDErrorResponse?) -> Void
    typealias RequestToPayCompletionHandler = (GDRTPQRResponse?, GDErrorResponse?) -> Void
    
    func getQRBase64Image(with amount: GDAmount, cusomerDetails: GDPICustomer?, expiryDate: String?, merchantName: String, orderId: String?, callbackUrl: String?, completion: @escaping QRCompletionHandler) {
        
        let params = QRParams(amount: amount, customer: cusomerDetails, expiryDate: expiryDate, merchantName: merchantName, orderId: orderId, callbackUrl: callbackUrl)
        let request = Request(router: MeezaPaymentRouter.getBase64Image(paymentIntentParams: params))
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
    
    func getMessage(with amount: GDAmount, cusomerDetails: GDPICustomer, expiryDate: String, merchantName: String, orderId: String?, callbackUrl: String?, completion: @escaping MessageCompletionHandler) {
        
        let params = QRParams(amount: amount, customer: cusomerDetails, expiryDate: expiryDate, merchantName: merchantName, orderId: orderId, callbackUrl: callbackUrl)
        let request = Request(router: MeezaPaymentRouter.getMessage(paymentIntentParams: params))
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
            
            let message =  String(decoding: data, as: UTF8.self)
            completion(message, error)
        }
    }
    
    func requestToPay(with receiverId: String, qrCodeMessage: String, orderId: String?, completion: @escaping RequestToPayCompletionHandler) {
        
        let params = RequestToPayParams(receiverId: receiverId, qrCodeMessage: qrCodeMessage, orderId: orderId)
        let request = Request(router: MeezaRouter.requestToPay(params: params))
        request.sendAsync { response, error in
            guard let res = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = res.data else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            let payResponse = GDRTPQRResponse().parse(json: data)
            guard let response = payResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            completion(response, error)
            
        }
    }
}
