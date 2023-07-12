//
//  UiView+Extensions.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 10/12/2020.
//

import UIKit

extension UIView {

var heightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .height && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var widthConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .width && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}
    
    func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }

        return view
    }

}


extension UIView {
    public func fillSuperViewSafeArea(edges: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let superview = superview else {
            fatalError("No super view present")
        }
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: edges.left).isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -edges.right).isActive = true
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: edges.top).isActive = true
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -edges.bottom).isActive = true
    }

    func anchors(top: NSLayoutYAxisAnchor? = nil, topConstants: CGFloat = 0.0, leading: NSLayoutXAxisAnchor? = nil, leadingConstants: CGFloat = 0.0, bottom: NSLayoutYAxisAnchor? = nil, bottomConstants: CGFloat = 0.0, trailing: NSLayoutXAxisAnchor? = nil, trailingConstants: CGFloat = 0.0,
                 height: NSLayoutDimension? = nil, heightMultiplier:  CGFloat = 1.0, width: NSLayoutDimension? = nil, widthMultiplier: CGFloat = 1.0,
                 heightConstants: CGFloat = 0.0, widthConstants: CGFloat = 0.0, centerX: NSLayoutXAxisAnchor? = nil, centerXConstants: CGFloat = 0.0, centerY: NSLayoutYAxisAnchor? = nil, centerYConstants: CGFloat = 0.0 ) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstants).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: leadingConstants).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomConstants).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: trailingConstants).isActive = true
        }
        if heightConstants > 0 {
            heightAnchor.constraint(equalToConstant: heightConstants).isActive = true
        }
        if widthConstants > 0 {
            widthAnchor.constraint(equalToConstant: widthConstants).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: centerXConstants).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: centerYConstants).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier).isActive = true
        }
    }
    func addSubviews(views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
