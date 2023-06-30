//
//  PaymentIntentManager.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 17/02/2021.
//

import Foundation

class PaymentIntentManager {
    
    typealias PaymentIntentCompletionHandler = (GDPaymentIntentResponse?, GDErrorResponse?) -> Void
    typealias PaymentIntentsCompletionHandler = (GDPaymentIntentsResponse?, GDErrorResponse?) -> Void
    
    func create(with paymentIntentParams: PaymentIntentParams, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.create(paymentIntentParams: paymentIntentParams))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func update(with paymentIntentParams: PaymentIntentParams, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.update(paymentIntentParams: paymentIntentParams))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func getInvoice(with paymentIntentId: String, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.getInvoice(paymentIntentId: paymentIntentId))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func getPaymentIntent(with paymentIntentId: String, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.getPaymentIntent(paymentIntentId: paymentIntentId))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func get(with paymentIntentFilter: GDPaymentIntentFilter, completion: @escaping PaymentIntentsCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.getAll(paymentIntentFilter: paymentIntentFilter))
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
            let configResponse = GDPaymentIntentsResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }

    
    func delete(with paymentIntentId: String, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.delete(paymentIntentId: paymentIntentId))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func sendLinkByEmail(with paymentIntentId: String, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.sendLinkByEmail(paymentIntentId: paymentIntentId))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func sendLinkBySMS(with paymentIntentId: String, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.sendLinkBySMS(paymentIntentId: paymentIntentId))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
    
    func sendLinkMultiple(with sendLinkMultipleDetails: SendLinkMultipleParams, completion: @escaping PaymentIntentCompletionHandler) {
        let request = Request(router: PaymentIntentRouter.sendLinkByMultiple(sendLinkMultipleDetails:  sendLinkMultipleDetails))
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
            let configResponse = GDPaymentIntentResponse().parse(json: data)
            guard let response = configResponse else {
                completion( nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
                return
            }
            
            completion(response, error)
        }
    }
}
