//
//  UITextField+Extensions.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Eugen Vidolman on 21.06.2022.
//

import UIKit

extension UITextField {

    

    func addDoneButtonToKeyboard(myAction: Selector?, target: Any?, text: String) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
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
