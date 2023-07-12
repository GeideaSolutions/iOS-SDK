//
//  RoundedView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 07.02.2022.
//

import Foundation

import Foundation
import UIKit

@IBDesignable class RoundedView: UIView {

    var metaDataString: String = ""
        
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
