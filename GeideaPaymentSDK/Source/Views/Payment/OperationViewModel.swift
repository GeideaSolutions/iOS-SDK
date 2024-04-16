//
//  CaptureViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/12/2020.
//

import Foundation

enum Operation {
    case capture, refund
}
class OperationViewModel: PayViewModel {
    var callBackURL: String?
    init(orderId: String, callbackUrl: String?, operation: Operation, isNavController: Bool) {
        switch operation {
        case .capture:
            super.init(config: nil, showReceipt: true, screenTitle: .captureScreenTitle, isNavController: isNavController)
            
        case .refund:
            super.init(config: nil, showReceipt: true, screenTitle: .refundScreenTitle, isNavController: isNavController)
        }
        self.orderId = orderId
        self.callBackURL = callbackUrl
        
        switch operation {
        case .capture:
            capture(with: orderId)
        case .refund:
            refund(with: orderId)
        }
        
    }
    
    func capture(with orderId: String) {
        
        OperationsManager().capture(with: orderId, callbackUrl: self.callBackURL,  completion: { orderResponse, error  in
            GeideaPaymentAPI.shared.returnAction(orderResponse,error)
        })
        
    }
    
    func refund(with orderId: String) {
        
        OperationsManager().refund(with: orderId, callbackUrl: self.callBackURL,  completion: { orderResponse, error  in
            GeideaPaymentAPI.shared.returnAction(orderResponse,error)
        })
        
    }
    
}


fileprivate extension String {
    static let captureScreenTitle = "CAPTURE_SCREEN_TITLE".localized
    static let refundScreenTitle = "REFUND_SCREEN_TITLE".localized
}

