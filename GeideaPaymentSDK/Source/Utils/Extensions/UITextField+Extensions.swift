//
//  UITextField+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 08/01/2021.
//

import Foundation
import UIKit

extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if GlobalConfig.shared.language == .arabic {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        }
    }
    
    // add image to textfield
    func withImage(image: UIImage){
        
        // this is the view I want to see on the rightView
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        
        // declare how much padding I want to have
        let padding: CGFloat = 20
        
        // create the view that would act as the padding
        let rightView = UIView(frame: CGRect(
                                x: 0, y: 0, // keep this as 0, 0
                                width: imageView.frame.width + padding, // add the padding
                                height: imageView.frame.height))
        let leftView = UIView(frame: CGRect(
                                x: 0, y: 0, // keep this as 0, 0
                                width: padding + imageView.frame.width, // add the padding
                                height: imageView.frame.height))
        
        
        // set the rightView UIView as the textField's rightView
        
        
        if GlobalConfig.shared.language == .arabic {
            self.leftViewMode = .always
            
            self.leftView = rightView
            leftView.addSubview(imageView)
            
        } else {
            rightView.addSubview(imageView)
            self.rightViewMode = .always
            self.rightView = rightView
        }
        
        
    }
    
    func addDoneButtonToKeyboard(myAction: Selector?, target: Any?, text: String) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.buttonBlue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: text,
                                         style: UIBarButtonItem.Style.plain,
                                         target: target,
                                         action: myAction)
        
        
        doneButton.tag = self.tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }
    
    func addForwardButtonToKeyboard(action: Selector?, target: Any?, canGoForward: Bool) {
        let button = UIBarButtonItem(image: UIImage(named: "keyboard_down_button"), style: .plain, target: target, action: action)
        button.isEnabled = canGoForward
        button.tag = self.tag
        addBackForwardButtonToKeyboard(button: button)
    }
    
    
    func addBackButtonToKeyboard(action: Selector?, target: Any?, canGoBack: Bool) {
        let button = UIBarButtonItem(image: UIImage(named: "keyboard_up_button"), style: .plain, target: target, action: action)
        button.isEnabled = canGoBack
        button.tag = self.tag
        addBackForwardButtonToKeyboard(button: button)
    }
    
    func addBackForwardButtonToKeyboard(button: UIBarButtonItem) {
        guard let toolBar = inputAccessoryView as? UIToolbar else {return}
        
        var currentItems = toolBar.items ?? []
        currentItems.insert(button, at: 0)
        
        toolBar.setItems(currentItems, animated: false)
    }
    
    func paddingLeft(inset: CGFloat){
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.leftViewMode = .always
        
    }
    
    func paddingRight(inset: CGFloat){
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
        self.rightViewMode = .always
    }
    
}

