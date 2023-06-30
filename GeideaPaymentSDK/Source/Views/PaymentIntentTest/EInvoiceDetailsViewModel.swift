//
//  EInvoiceDetailsViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.11.2021.
//

import Foundation

class EInvoiceDetailsViewModel:ViewModel {
    var paymentIntentDetails: GDPaymentIntentDetails
    var isUpdate: Bool
   
    
    
    init(paymentIntentDetails: GDPaymentIntentDetails, isUpdate: Bool) {
        self.paymentIntentDetails = paymentIntentDetails
        self.isUpdate = isUpdate
        super.init(screenTitle: .paymentScreenTitle,isNavController: false)
    }
}

fileprivate extension String {
    static let paymentScreenTitle = "EInvoice_SCREEN_TITLE".localized
}
