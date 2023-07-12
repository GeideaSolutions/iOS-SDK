//
//  ConfiguartionViewController+Bind.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 13/06/23.
//

import UIKit
import GeideaPaymentSDK

extension ConfiguartionViewController {
    
    func setupDemoData() {
        setupSegmentData()
        setUPcredentials()
        setupCurrency()
        setupCallbackUrl()
        setupDetails()
    }
    
    func setupSegmentData() {
        if segment.selectedSegmentIndex == 1 {
            GeideaPaymentAPI.setEnvironment(environment: Environment.test)
        } else {
            GeideaPaymentAPI.setEnvironment(environment: Environment.prod)
        }
        viewModel.refreshConfig()
    }
    
    func setUPcredentials() {
  
    }
    
    func setupCurrency() {
        currencyTextField.text = "SAR"
    }
    
    func setupCallbackUrl() {
        callBackUrlTextField.text = "https://api-test.gd-azure-dev.net/external-services/api/v1/callback/test123"
        viewModel.callBackUrl = callBackUrlTextField.text
    }
    
    func setupDetails() {
        customerEmailTextField.text = "somemail@end.com"
        merchantReferenceTextField.text = "1234"
        shippingCountryTextField.text = "GBR"
        shippingCityNameTextField.text = "London"
        shippingStreetNameTextField.text = "London 1, address"
        shippingPostCodeTextField.text = "12345"
        
        billingCountryTextField.text = "SAU"
        billingCityNameTextField.text = "Riadh"
        billingStreetNameTextField.text = "Riadh 1, address "
        billingPostCodeTextField.text = "123456"
        initiatedTextField.text = "Internet"
        let shippingAddress = GDAddress(withCountryCode: shippingCountryTextField.text, andCity: shippingCityNameTextField.text, andStreet: shippingStreetNameTextField.text, andPostCode: shippingPostCodeTextField.text)
        let billingAddress = GDAddress(withCountryCode: billingCountryTextField.text, andCity: billingCityNameTextField.text, andStreet: billingStreetNameTextField.text, andPostCode: billingPostCodeTextField.text)
        let customerDetails = GDCustomerDetails(withEmail: customerEmailTextField.text, andCallbackUrl: callBackUrlTextField.text, merchantReferenceId: merchantReferenceTextField.text, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: .NONE)
        viewModel.customerDetails = customerDetails
    }
}
