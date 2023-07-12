//
//  PayTokenViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16/12/2020.
//


import Foundation


class PaymentTokenViewModel: PayViewModel {
    
    var action: ((PayTokenParams, AuthenticateResponse)->())!
    var payTokenParams: PayTokenParams
    let paymentScreenTitle = "PAYMENT_SCREEN_TITLE".localized
    let webViewScreenTitle = "WEBVIEW_SCREEN_TITLE".localized
    
    init(payTokenParms: PayTokenParams, config: GDConfigResponse?, showReceipt: Bool, isNavController: Bool) {
        self.payTokenParams = payTokenParms
        super.init(config: config, showReceipt: showReceipt, screenTitle: .paymentScreenTitle, isNavController: isNavController)
    }
    
    var flowType: FlowType = .authenticate {
        didSet {
            switch flowType {
            case .webview:
                loadWebView()
            case .pay:
                pay(with: payTokenParams, threeDSecureId: threedSecureId, orderId: orderId )
            case .initiatePayment:
                initiatePayment()
            case .authenticate:
                break
            case .CVV:
                showCVVScreen()
            case .authenticatePayer:
                break
            }
        }
    }
    
    func initiatePayment() {
        
        let customerDetails = GDCustomerDetails(withEmail: payTokenParams.customerEmail, andCallbackUrl: payTokenParams.callbackUrl, merchantReferenceId: payTokenParams.merchantReferenceId, shippingAddress: GDAddress(withCountryCode: payTokenParams.shippingAddress?.countryCode, andCity: payTokenParams.shippingAddress?.city, andStreet: payTokenParams.shippingAddress?.city, andPostCode: payTokenParams.shippingAddress?.postcode), billingAddress: GDAddress(withCountryCode: payTokenParams.billingAddress?.countryCode, andCity: payTokenParams.billingAddress?.city, andStreet: payTokenParams.billingAddress?.city, andPostCode: payTokenParams.billingAddress?.postcode))
        let initiateAuthentication = InitiateAuthenticateTokenParams(amount: GDAmount(amount: payTokenParams.amount, currency: payTokenParams.currency), tokenId: payTokenParams.tokenId, tokenizationDetails: GDTokenizationDetails(withCardOnFile: false, initiatedBy: payTokenParams.initiatedBy, agreementId: payTokenParams.agreementId, agreementType: payTokenParams.agreementType, subscriptionId: payTokenParams.subscriptionId), customerDetails: customerDetails)
        
        PayTokenManager().initiateToken(with: initiateAuthentication, completion: { response, error in
            guard let intiateResponse = response else {
                GeideaPaymentAPI.shared.returnAction(nil, error)
                return
            }
            
            self.threedSecureId = intiateResponse.threeDSecureId
            self.gatewayDecision = intiateResponse.gatewayDecision
            self.orderId = intiateResponse.orderId
            self.redirectHtml = intiateResponse.redirectHtml
            self.loadHiddenWebViewAction()
            
            
        })
        
    }
    
    func showCVVScreen() {
        
        PayTokenManager().getToken(with: payTokenParams.tokenId, completion: { response, error in
            
            if let res = response {
                let cvvVC = PaymentFactory.makeCVVViewController()
                cvvVC.viewModel = CVVViewModel(tokenResponse: res, config: self.config, isNavController: false, completion: {response in
                    
                })
                
            }
            
            
            
        })
        
    }
    
    func authenticatePayer() {
        
        let customerDetails = GDCustomerDetails(withEmail: payTokenParams.customerEmail, andCallbackUrl: payTokenParams.callbackUrl, merchantReferenceId: payTokenParams.merchantReferenceId, shippingAddress: GDAddress(withCountryCode: payTokenParams.shippingAddress?.countryCode, andCity: payTokenParams.shippingAddress?.city, andStreet: payTokenParams.shippingAddress?.countryCode, andPostCode: payTokenParams.shippingAddress?.postcode), billingAddress: GDAddress(withCountryCode: payTokenParams.billingAddress?.countryCode, andCity: payTokenParams.billingAddress?.city, andStreet: payTokenParams.billingAddress?.countryCode, andPostCode: payTokenParams.billingAddress?.postcode), paymentOperation: PaymentOperation.pay)
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: true, initiatedBy: payTokenParams.initiatedBy, agreementId: payTokenParams.agreementId, agreementType: payTokenParams.agreementType, subscriptionId: payTokenParams.subscriptionId)
        let authenticateParams = AuthenticateTokenPayerParams(amount: GDAmount(amount: payTokenParams.amount, currency: payTokenParams.currency), tokenId: payTokenParams.tokenId, tokenizationDetails: tokenizationDetails, paymentIntentId: payTokenParams.paymentIntentId, customerDetails: customerDetails, orderId: self.orderId)
        PayTokenManager().authenticateToken(with: authenticateParams, completion: { [self] authenticateResponse, error in
            guard let authResponse = authenticateResponse else {
                GeideaPaymentAPI.shared.returnAction(nil, error)
                return
            }
            self.authenticateResponse = authenticateResponse
            self.orderId = authResponse.orderId
            self.action(payTokenParams, authResponse)
        })
    }
    
    override var screenTitle: String {
        get {
            switch flowType {
            case .authenticate: do {
                return paymentScreenTitle
            }
            case .webview: do {
                return webViewScreenTitle
            }
            case .pay: do {
                return paymentScreenTitle
            }
            case .initiatePayment:
                return paymentScreenTitle
            case .CVV:
                return paymentScreenTitle
            case .authenticatePayer:
                return paymentScreenTitle
            }
        }
        set {
            super.screenTitle = newValue
        }
        
    }
    
    func loadHiddednWebView(with redirectHtml: String) {
        datasourceRefreshAction()
    }
    
    func loadWebView() {
        datasourceRefreshAction()
    }
    
    var shouldShowWebView: Bool {
        return flowType == .webview
    }
    
    func pay(with payTokenParms: PayTokenParams, threeDSecureId: String?, orderId: String?) {
        var payTokenP = payTokenParms
        payTokenP.threeDSecureId = threeDSecureId
        payTokenP.orderId = orderId
        
        //        datasourceRefreshAction()
        
        PayTokenManager().pay(with: payTokenP, completion: { orderResponse, error  in
            
            if self.showReceipt {
                self.receiptAction(orderResponse, error)
            } else {
                GeideaPaymentAPI.shared.returnAction(orderResponse,error)
            }
            
        })
    }
}

fileprivate extension String {
    static let paymentScreenTitle = "PAYMENT_SCREEN_TITLE".localized
}

