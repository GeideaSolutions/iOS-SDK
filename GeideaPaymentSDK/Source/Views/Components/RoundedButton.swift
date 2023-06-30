//
//  RoundedButton.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 08/01/2021.
//

import Foundation
import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    private var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
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
    
    func enabled(isEnabled: Bool, config: GDConfigResponse?) {
        self.isEnabled = isEnabled
        if isEnabled {
            self.alpha = 1
            if let accentColor = config?.branding?.accentColor {
                
                self.backgroundColor = UIColor.init(hex: accentColor)
                
                if let accentTextColor = config?.branding?.accentTextColor {
                    self.setTitleColor(UIColor.init(hex: accentTextColor), for: .normal)
                }
            } else {
                self.backgroundColor = UIColor.buttonBlue
            }
                
        } else {
            if let accentColor = config?.branding?.accentColor {
                self.backgroundColor = UIColor.init(hex: accentColor)
                self.alpha = 0.5
                if let accentTextColor = config?.branding?.accentTextColor {
                    self.setTitleColor(UIColor.init(hex: accentTextColor), for: .normal)
                }
            } else { 
                self.backgroundColor = UIColor.buttonBlueDisabled
            }
        }
    }
    
    func applyBrandingCancel(config: GDConfigResponse?) {
        if let accentColor = config?.branding?.accentColor {
            if self.isEnabled {
                self.setTitleColor(.red, for: .normal)
                self.setTitleColor(UIColor.init(hex: accentColor), for: .normal)
            } else {
                self.setTitleColor(UIColor.init(hex: accentColor), for: .normal)
            }
            
        }
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        if (activityIndicator != nil) {
            activityIndicator.stopAnimating()
        }
        
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
