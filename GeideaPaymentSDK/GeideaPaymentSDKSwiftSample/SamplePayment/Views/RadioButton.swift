//
//  RadioButton.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 12/06/23.
//

import UIKit

class RadioButton: UIView{
    
    let shapeLayer = CAShapeLayer.init()
    let innerShape = CAShapeLayer.init()
    var selected: Bool!{
        didSet{
            if selected{
                innerShape.fillColor = UIColor.systemBlue.cgColor
                shapeLayer.strokeColor = UIColor.systemBlue.cgColor
            } else {
                innerShape.fillColor = UIColor.lightGray.cgColor
                shapeLayer.strokeColor = UIColor.black.cgColor
            }
        }
    }
    
    
    
    
    func initViews(){
        let circlePath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = selected ? UIColor.systemBlue.cgColor : UIColor.black.cgColor
        shapeLayer.lineWidth = 5.0
        
        self.layer.addSublayer(shapeLayer)
        
        
        let innerCirclePath = UIBezierPath.init(roundedRect: CGRect.init(x: 10, y: 10, width: 10, height: 10), cornerRadius: 5)
        innerShape.path = circlePath.cgPath
        innerShape.fillColor = selected ? UIColor.systemBlue.cgColor : UIColor.lightGray.cgColor
        innerShape.strokeColor = UIColor.white.cgColor
        innerShape.lineWidth = 3.0
        
        self.layer.addSublayer(innerShape)
        
    }
    
    func initConstraints(){
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initViews()
        
    }
}

