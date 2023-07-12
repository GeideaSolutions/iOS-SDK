//
//  CardPaymentViewController+Bind.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 14/06/23.
//

import UIKit

extension CardPaymentViewController {
    func bindData() {
        cardNumberTextField.text = "5123456789012346"
        cardHolderNameField.text = "Stoyan Atanasov"
        expiryMonthTextField.text = "12"
        expiryYearTextField.text = "23"
        cvvTextField.text = "111"
    }
}
