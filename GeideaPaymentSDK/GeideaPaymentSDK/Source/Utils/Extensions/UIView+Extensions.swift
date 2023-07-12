//
//  UIView+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/01/2021.
//

import UIKit

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    
    func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }

        return view
    }
    
    func setCornerRadius(using corners: UIRectCorner, cornerRadius: CGSize) {
        let path = UIBezierPath(roundedRect: self.bounds,
                    byRoundingCorners: corners, cornerRadii: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
           switch location {
           case .bottom:
                addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
           case .top:
               addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
           }
       }

       func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
           self.layer.masksToBounds = false
           self.layer.shadowColor = color.cgColor
           self.layer.shadowOffset = offset
           self.layer.shadowOpacity = opacity
           self.layer.shadowRadius = radius
       }
    
}
