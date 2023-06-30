//
//  PaymentIntentViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/02/2021.
//

import Foundation

class PaymentIntentViewModel:ViewModel {
    var paymentIntentId: String?
    var status: String?
    var type: String?
    var currency: String?
    var paymentIntents: [GDPaymentIntentDetailsResponse]?
    
    init(paymentId: String?, type: String?, status: String?, currency:String?) {
        self.paymentIntentId = paymentId
        self.status = status
        self.type  = type
        self.currency = currency
        super.init(screenTitle: .paymentScreenTitle,isNavController: false)
    }
    
}

fileprivate extension String {
    static let paymentScreenTitle = "EInvoice_SCREEN_TITLE".localized
}
