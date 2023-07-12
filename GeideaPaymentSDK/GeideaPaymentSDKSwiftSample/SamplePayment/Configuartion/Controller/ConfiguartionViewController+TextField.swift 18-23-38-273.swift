//
//  ConfiguartionViewController+TextField.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 12/06/23.
//

import UIKit


extension ConfiguartionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unfocusFields()
        return true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        unfocusFields()
    }
    
    private func unfocusFields() {
        inputs.forEach {
            $0.endEditing(true)
        }
    }
}
