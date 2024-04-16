//
//  ChecView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 22.08.2022.
//

import UIKit

class RadialCircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

      
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI Setup
    override func prepareForInterfaceBuilder() {
          setupView()
      }

      func setupView() {
          backgroundColor = UIColor.clear
          self.backgroundColor = color
       
      }
    
    var color: UIColor = UIColor.borderDisabled {
        didSet {
            color.set()
            setNeedsDisplay()
        }
    }

      // MARK: - Properties
      @IBInspectable
    var enabledColor: UIColor = UIColor.buttonBlue {
          didSet {
              enabledColor.set()
              color = enabledColor
              setNeedsDisplay()
          }
      }
    
    @IBInspectable
    var disabledColor: UIColor = UIColor.borderDisabled {
        didSet {
            disabledColor.set()
            color = disabledColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isEnabled: Bool = false {
        didSet {
            enabled()
        }
    }
    

    func enabled(enabled: Bool = false, config: GDConfigResponse? = nil) {
        if let accentColor  = config?.branding?.accentColor {
            
            if enabled {
                enabledColor = UIColor(hex: accentColor) ?? .buttonBlue
            } else {
                color = disabledColor
            }
        } else {
            if enabled {
                color = enabledColor
            } else {
                color = disabledColor
            }
        }
        
        setNeedsDisplay()
        
    }
    
    public override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        if let context = UIGraphicsGetCurrentContext() {
            
            // Set the circle outerline-width
            context.setLineWidth(2.0);
            
            // Set the circle outerline-colour
            color.set()
            
            // Create Circle
            let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            let radius = (frame.size.width - 10)/2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
                
            // Draw
            context.strokePath()
        }
    }
    
}
