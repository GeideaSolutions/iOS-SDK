//
//  UIActivityIndicatorView+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.10.2022.
//

import UIKit

extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        activityIndicatorViewStyle = .whiteLarge
        self.color = color
    }
}
