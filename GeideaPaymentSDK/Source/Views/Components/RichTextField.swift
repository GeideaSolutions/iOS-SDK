//
//  RichTextField.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.03.2022.
//

import UIKit

protocol RichTextFieldDelegate {
    func textFieldDidDelete(textField: RichTextField)
}
class RichTextField: UITextField {
  
    var richTFDelegate: RichTextFieldDelegate?
    
    override public func deleteBackward() {
        super.deleteBackward()
        richTFDelegate?.textFieldDidDelete(textField: self)
    }
}
