//
//  ViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/12/2020.
//

import Foundation
import UIKit

struct PaymentViewConstants {
    static let HEADER_HEIGHT = 64
}

class ViewModel {
    var datasourceRefreshAction: (()->())!
   
    var screenTitle: String
    var isNavController: Bool
    var orderId: String? = nil
    var dismissAction: ((GDCancelResponse?, GDErrorResponse?)->Void)?
    
    var headerViewConstant: CGFloat {
        return CGFloat(isNavController ? 0 : PaymentViewConstants.HEADER_HEIGHT)
    }

    var shouldShowHeader: Bool {
        return !isNavController
    }
    init(screenTitle: String, isNavController: Bool, orderId: String? = nil) {
        self.screenTitle = screenTitle
        self.isNavController = isNavController
        self.orderId = orderId
    }

}
