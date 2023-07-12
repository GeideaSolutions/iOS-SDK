//
//  CardPaymentViewController+Actions.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 13/06/23.
//

import UIKit
import GeideaPaymentSDK

extension CardPaymentViewController {
    
    @objc func labelTapped(sender: UIButton) {
        radioButtonArray.forEach{
            $0.selected = false
        }
        sdkArray.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        for selectedLabel in sdkArray {
            if selectedLabel.isSelected {
                if let indexSelection = sdkArray.firstIndex(where: {$0 == selectedLabel})  {
                    radioButtonArray[indexSelection].selected = true
                }
            }
        }
        changeHeightOfCardDetails()
    }
    
    @objc func buttonOneTapped(sender: UITapGestureRecognizer){
        radioButtonArray.forEach{
            $0.selected = false
        }
        (sender.view as? RadioButton)?.selected = true
        changeHeightOfCardDetails()
    }
    
    func changeHeightOfCardDetails() {
        if firstRadioButton.selected {
            cardDetailsView.isHidden = true
            heightConstraint?.constant = 0
        }
        
        if secondRadioButton.selected {
            cardDetailsView.isHidden = false
            heightConstraint?.constant = 166
        }
    }
    
    @objc func payButtonClicked() {
        viewModel.saveAmount(amount: amountTextField.text)
        if firstRadioButton.selected {
            payWithSDk()
        }
        
        if secondRadioButton.selected {
            if !GeideaPaymentAPI.isCredentialsAvailable() {
                GeideaPaymentAPI.setCredentials(withMerchantKey: viewModel.key ?? "", andPassword: viewModel.password ?? "")
            }
            guard let amount = viewModel.amount else {
                displayAlert(title: "Error", message: "Please enter the amount")
                return
            }
            
            guard let safeExpiryMonth = Int(expiryMonthTextField.text ?? "") else {
                displayAlert(title: "Error", message: "Please enter Expiry Month")
                return
            }
            
            guard let safeExpiryYear = Int(expiryYearTextField.text ?? "") else {
                displayAlert(title: "Error", message: "Please enter Expiry Year")
                return
            }
            
            let cardDetails = GDCardDetails(withCardholderName: cardHolderNameField.text ?? "", andCardNumber:  cardNumberTextField.text ?? "", andCVV: cvvTextField.text ?? "", andExpiryMonth: safeExpiryMonth, andExpiryYear: safeExpiryYear)
            let tokenizationDetails = GDTokenizationDetails(withCardOnFile:  false, initiatedBy: nil, agreementId: "", agreementType: "")
            pay(amount: amount, cardDetails: cardDetails, tokenizationDetails: tokenizationDetails, paymentIntentId: nil, customerDetails: viewModel.customerDetails)
        }
        
    }
    
    func payWithSDk() {
        if !GeideaPaymentAPI.isCredentialsAvailable() {
            GeideaPaymentAPI.setCredentials(withMerchantKey: viewModel.key ?? "", andPassword: viewModel.password ?? "")
        }
        
        let applePayDetails = GDApplePayDetails(forMerchantIdentifier: "merchant.geidea.test.applepay", paymentMethods: nil, withCallbackUrl: viewModel.callBackUrl, andReferenceId:  viewModel.merchantID)
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: false, initiatedBy: viewModel.initiatedBy, agreementId: "", agreementType: "")
        let qrDetails = GDQRDetails(phoneNumber: nil)
        guard let amount = viewModel.amount else { return }
        GeideaPaymentAPI.payWithGeideaForm(theAmount: amount, showAddress: viewModel.showAddress ?? false, showEmail: viewModel.showEmail ?? false, showReceipt: viewModel.showReceipt ?? false, tokenizationDetails: tokenizationDetails, customerDetails: viewModel.customerDetails, applePayDetails: applePayDetails, config: viewModel.merchantConfig, paymentIntentId: "", qrDetails: qrDetails, cardPaymentMethods: nil, paymentSelectionMethods: nil, viewController: self, completion:{ response, error in
            DispatchQueue.main.async {
                
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: nil, paymentIntentId: "", tokenizationDetails: tokenizationDetails, customerDetails: self.viewModel.customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: nil, paymentIntentId: "", tokenizationDetails: tokenizationDetails, customerDetails: self.viewModel.customerDetails)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        guard let orderResponse = response else {
                            return
                        }
                        self.orderId = orderResponse.orderId
                        
                        if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                            let vc = SuccessViewController()
                            vc.delegate = self
                            vc.json = orderString
                            vc.isRefundVisible = true
                            self.present(vc, animated: true, completion: nil)
                        }
            
                    }
                }
            }
        })
    }
    
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func displayAlert(title: String, message: String, amount: GDAmount, cardDetails: GDCardDetails?, paymentIntentId: String?, tokenizationDetails: GDTokenizationDetails?, customerDetails: GDCustomerDetails? ) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "RETRY", style: .default, handler: {_ in
                DispatchQueue.main.async { [weak self] in
                    self?.payWithSDk()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func pay(amount: GDAmount, cardDetails: GDCardDetails, tokenizationDetails: GDTokenizationDetails?, paymentIntentId
                : String?, customerDetails: GDCustomerDetails?) {
        
        GeideaPaymentAPI.pay(theAmount: amount, withCardDetails: cardDetails, config: viewModel.merchantConfig, showReceipt: viewModel.showReceipt ?? false, andTokenizationDetails: tokenizationDetails, andPaymentIntentId: paymentIntentId,andCustomerDetails: customerDetails, paymentMethods: nil, navController: self, completion:{ response, error in
            DispatchQueue.main.async {
                
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message , amount: amount, cardDetails: cardDetails, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)" , amount: amount, cardDetails: cardDetails, paymentIntentId: paymentIntentId, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails)
                    }
                } else {
                    guard let orderResponse = response else {
                        return
                    }
                    self.orderId = orderResponse.orderId
                    if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        vc.delegate = self
                        vc.isRefundVisible = true
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        })
    }
}


extension CardPaymentViewController: RefundActionProtocol {
    func refundClicked() {
        guard let id = self.orderId else { return }
        refund(with: id)
    }
    
    func refund(with id: String) {
        GeideaPaymentAPI.refund(with: id, callbackUrl: viewModel.callBackUrl, navController: self, completion:{ response, error in
            if let err = error {
                if err.errors.isEmpty {
                    var message = ""
                    if err.responseCode.isEmpty {
                        message = "\n responseMessage: \(err.responseMessage)"
                        
                    } else if !err.orderId.isEmpty {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                    } else {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                    }
                    self.displayAlert(title: err.title,  message: message)
                    
                } else {
                    self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)")
                }
            } else {
                guard let orderResponse = response else {
                    return
                }
                
                if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                    let vc = SuccessViewController()
                    vc.isRefundVisible = false
                    vc.json = orderString
                    self.present(vc, animated: true, completion: nil)
                }
                self.orderId = nil
            }
        })
    }
}
