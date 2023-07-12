//
//  ConfigurationViewModel.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 13/06/23.
//

import Foundation
import GeideaPaymentSDK

protocol ConfigurationPresentable {
    func updateCredentials(key: String?, password: String?)
    func saveAmount(amount: String?)
    var amount: GDAmount? { get set }
    var merchantID: String? { get set }
    var initiatedBy: String? { get set }
    var merchantConfig: GDConfigResponse? { get set }
    var callBackUrl: String? { get set }
    var customerDetails: GDCustomerDetails? { get set }
    var showAddress: Bool? { get set }
    var showEmail: Bool? { get set }
    var showReceipt: Bool? { get set }
    var key: String? { get set }
    var password: String? { get set }
    var selectedCurrency: String? { get set }
    func refreshConfig()
}

class ConfigurationViewModel: ConfigurationPresentable {
    var merchantConfig: GDConfigResponse?
    var amount: GDAmount?
    var callBackUrl: String?
    var customerDetails: GDCustomerDetails?
    var key: String?
    var password: String?
    var merchantID: String?
    var initiatedBy: String?
    var showAddress: Bool? = false
    var showEmail: Bool? = false
    var showReceipt: Bool? = false
    var selectedCurrency: String?
    func updateCredentials(key: String?, password: String?) {
        guard let publicKey = key, let password = password, !publicKey.isEmpty, !password.isEmpty else {
            return
        }
        self.key = key
        self.password = password
        GeideaPaymentAPI.updateCredentials(withMerchantKey: publicKey, andPassword: password)
        refreshConfig()
    }
    
    func saveAmount(amount: String?) {
        guard let safeAmount = Double(amount ?? "") else {
            return
        }
        let amount = GDAmount(amount: safeAmount, currency: selectedCurrency ?? "SAR")
        self.amount = amount
    }
    
    func saveCustomerDetails(customer: GDCustomerDetails) {
        self.customerDetails = customer
    }
    
    func refreshConfig() {
        GeideaPaymentAPI.getMerchantConfig(completion:{ response, error in
            guard let config = response else {
                self.merchantConfig = nil
                return
            }
            self.merchantConfig = config
        })
    }
    
    func checkConfiguartionDetailsAvailability() -> Bool {
        if customerDetails == nil {
            return false
        }
        return true
    }
    
}
