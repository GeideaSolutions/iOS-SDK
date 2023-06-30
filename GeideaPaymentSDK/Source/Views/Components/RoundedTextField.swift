//
//  RoundedTextField.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 08/01/2021.
//

import Foundation
import UIKit

@IBDesignable class RoundedTextField: UITextField
{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.paddingLeft(inset: 10)
        self.paddingRight(inset: 10)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 20, 0, 15))
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 15))
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 15))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        layer.masksToBounds = true
        
    }
    
}
