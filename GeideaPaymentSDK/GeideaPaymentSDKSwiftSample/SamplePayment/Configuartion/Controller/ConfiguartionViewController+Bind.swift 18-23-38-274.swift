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
        merchantKey.text = "5d8eaed9-068e-4d1a-8d9e-75e5194adfbe"//"a087f4ca-9890-407b-9c2f-7630836cc020"
        passwordKey.text = "41ec06d8-fcb5-4618-96c6-af12e69d59ae"//"df0fc687-783b-4058-af63-9e876444b357"
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
