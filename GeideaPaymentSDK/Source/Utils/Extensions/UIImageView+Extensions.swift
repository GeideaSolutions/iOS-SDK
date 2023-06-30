//
//  UIImageView+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 11/01/2021.
//

import Foundation
import UIKit

extension UIView {
    
    func withBorder(isVisible: Bool, radius: Int = 5, width: Int = 1, color: CGColor = UIColor.orangeHighlightColor.cgColor ){
        if isVisible {
            self.layer.borderColor = color
            self.layer.masksToBounds = false
            self.layer.borderWidth = CGFloat(width)
            self.layer.cornerRadius = CGFloat(radius)
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.masksToBounds = false
            self.layer.borderWidth = 0
            self.layer.cornerRadius = 0
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
           layer.masksToBounds = false
    }
        
        
}
