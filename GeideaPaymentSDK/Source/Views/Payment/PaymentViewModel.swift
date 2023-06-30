//
//  PaymentViewModel.swift
//  GeideaPaymentSampleSwift
//
//  Created by euvid on 13/10/2020.
//

import Foundation


//enum FlowType {
//    case initiatePayment
//    case authenticate
//    case webview
//    case pay
//    case CVV
//}

enum FlowType {
    case authenticatePayer
    case authenticate
    case webview
    case pay
    case initiatePayment
    case CVV
}


class PaymentViewModel: PayViewModel {
    var authenticateAction: ((AuthenticateParams, AuthenticateResponse)->())!
    var authenticateParams: AuthenticateParams
    var isHPP: Bool
    
    let paymentScreenTitle = "PAYMENT_SCREEN_TITLE".localized
    let webViewScreenTitle = "WEBVIEW_SCREEN_TITLE".localized
    

//    var flowType: FlowType = .authenticate {
//        didSet {
//            switch flowType {
//            case .authenticate:
//                authenticatePayment()
//            case .webview:
//                loadWebView()
//            case .pay:
//                pay(with: authenticateParams, threeDSecureId: threedSecureId, orderId: orderId )
//            case .initiatePayment:
//                intiatePayment()
//            case .CVV:
//                break
//            }
//        }
//    }
    
    var flowType: FlowType = .authenticate {
           didSet {
               switch flowType {
               case .authenticate:
                   authenticatePayment()
               case .webview:
                   loadWebView()
               case .pay:
                   pay(with: authenticateParams, threeDSecureId: threedSecureId, orderId: orderId)
               case .authenticatePayer:
                   authenticatePayerPayment()
               case .initiatePayment:
                   intiatePayment()
               case .CVV:
                   break
               }
           }
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
    
    var shouldShowWebView: Bool {
        return flowType == .webview
    }
    
    init(authenticateParams: AuthenticateParams,config: GDConfigResponse?, showReceipt: Bool, initializeRespone: GDInitiateAuthenticateResponse? = nil, isHpp: Bool, isNavController: Bool) {
        self.isHPP = isHpp
        self.authenticateParams = authenticateParams
        super.init(config: config, showReceipt: showReceipt, screenTitle: paymentScreenTitle, isNavController: isNavController)
        super.threedSecureId = initializeRespone?.threeDSecureId
        super.gatewayDecision = initializeRespone?.gatewayDecision
        super.orderId = initializeRespone?.orderId
    }
    
    func authenticatePayerPayment() {
    
        if gatewayDecision == nil && !isHPP {

               let initiateAuthentication = InitiateAuthenticateParams(amount: GDAmount(amount: authenticateParams.amount, currency: authenticateParams.currency), cardNumber: authenticateParams.paymentMethod.cardNumber, tokenizationDetails: GDTokenizationDetails(withCardOnFile: authenticateParams.cardOnFile, initiatedBy: authenticateParams.initiatedBy, agreementId: authenticateParams.agreementId, agreementType: authenticateParams.agreementType), paymentIntentId: authenticateParams.paymentIntentId, customerDetails:  GDCustomerDetails(withEmail: authenticateParams.customerEmail, andCallbackUrl: authenticateParams.callbackUrl, merchantReferenceId: authenticateParams.merchantReferenceId, shippingAddress: GDAddress(withCountryCode: authenticateParams.shippingAddress?.countryCode, andCity: authenticateParams.shippingAddress?.city, andStreet: authenticateParams.shippingAddress?.countryCode, andPostCode: authenticateParams.shippingAddress?.postcode) , billingAddress: GDAddress(withCountryCode: authenticateParams.billingAddress?.countryCode, andCity: authenticateParams.billingAddress?.city, andStreet: authenticateParams.billingAddress?.countryCode, andPostCode: authenticateParams.billingAddress?.postcode)), orderId: orderId, paymentMethods: authenticateParams.paymentMethods)
               
               AuthenticateManager().initiate(with: initiateAuthentication, completion: { response, error in
                   
                   guard let intiateResponse = response else {
                       GeideaPaymentAPI.shared.returnAction(nil, error)
                       return
                   }
                   self.orderId = intiateResponse.orderId
                   self.redirectHtml = intiateResponse.redirectHtml
                   self.gatewayDecision = intiateResponse.gatewayDecision
                   self.threedSecureId = intiateResponse.threeDSecureId
                   self.loadHiddenWebViewAction()
               })
           } else {
               if gatewayDecision  != "ContinueToPayWithNotEnrolledCard" {
                   authenticatePayer()
               } else {
                   if self.authenticateParams.orderId == nil {
                       self.authenticateParams.orderId = orderId
                   }
        
                   pay(with: authenticateParams, threeDSecureId: threedSecureId, orderId: self.authenticateParams.orderId)
               }
           }
       }

    
    func authenticatePayment() {
       
        if isAuthenticateParamsValid(authenticateParams: authenticateParams) {
            AuthenticateManager().authenticate(with: authenticateParams, completion: { [self] authenticateResponse, error in
                guard let authResponse = authenticateResponse else {
                    GeideaPaymentAPI.shared.returnAction(nil, error)
                    return
                }
                self.threedSecureId = authResponse.threeDSecureId
                self.orderId = authResponse.orderId
                self.authenticateAction(authenticateParams, authResponse)
            })
        }
    }
    
    func authenticatePayer() {
        if isAuthenticateParamsValid(authenticateParams: authenticateParams) {
            
            if self.authenticateParams.orderId == nil {
                self.authenticateParams.orderId = orderId
            }
            AuthenticateManager().authenticatePayer(with: authenticateParams, completion: { [self] authenticateResponse, error in
                guard let authResponse = authenticateResponse else {
                    GeideaPaymentAPI.shared.returnAction(nil, error)
                    return
                }
                self.orderId = authResponse.orderId
                self.threedSecureId = authResponse.threeDSecureId
                self.authenticateAction(authenticateParams, authResponse)
            })
        }
    }
    
    func intiatePayment() {

            let initiateAuthentication = InitiateAuthenticateParams(amount: GDAmount(amount: authenticateParams.amount, currency: authenticateParams.currency), cardNumber: authenticateParams.paymentMethod.cardNumber, tokenizationDetails: GDTokenizationDetails(withCardOnFile: authenticateParams.cardOnFile, initiatedBy: authenticateParams.initiatedBy, agreementId: authenticateParams.agreementId, agreementType: authenticateParams.agreementType), paymentIntentId: authenticateParams.paymentIntentId, customerDetails:  GDCustomerDetails(withEmail: authenticateParams.customerEmail, andCallbackUrl: authenticateParams.callbackUrl, merchantReferenceId: authenticateParams.merchantReferenceId, shippingAddress: GDAddress(withCountryCode: authenticateParams.shippingAddress?.countryCode, andCity: authenticateParams.shippingAddress?.city, andStreet: authenticateParams.shippingAddress?.countryCode, andPostCode: authenticateParams.shippingAddress?.postcode) , billingAddress: GDAddress(withCountryCode: authenticateParams.billingAddress?.countryCode, andCity: authenticateParams.billingAddress?.city, andStreet: authenticateParams.billingAddress?.countryCode, andPostCode: authenticateParams.billingAddress?.postcode)), orderId: authenticateParams.orderId, paymentMethods: authenticateParams.paymentMethods)
            
            AuthenticateManager().initiate(with: initiateAuthentication, completion: { response, error in
                
                self.threedSecureId = response?.threeDSecureId
                self.gatewayDecision = response?.gatewayDecision
                self.orderId = response?.orderId
                self.redirectHtml = response?.redirectHtml
                self.loadHiddenWebViewAction()
            })
    }
    
    func loadHiddednWebView(with redirectHtml: String) {
        datasourceRefreshAction()
    }
    
    func loadWebView() {
        datasourceRefreshAction()
    }
    
    
    func pay(with authenticateParams: AuthenticateParams, threeDSecureId: String?, orderId: String?) {
        
        datasourceRefreshAction()
        PayManager().pay(with: authenticateParams, threeDSecureId: threeDSecureId, orderId: orderId, completion: { orderResponse, error  in
            
            if self.showReceipt {
                self.receiptAction(orderResponse, error)
            } else {
                GeideaPaymentAPI.shared.returnAction(orderResponse,error)
            }
        })
    }
}

extension PaymentViewModel {
    func isAuthenticateParamsValid(authenticateParams: AuthenticateParams) -> Bool {
        guard authenticateParams.amount > 0 else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage))
            return false
        }
        
        guard authenticateParams.amount.decimalCount() <= 2 else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage))
            return false
        }
        
        guard !authenticateParams.currency.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E006.rawValue, code: GDErrorCodes.E006.description, detailedResponseMessage: GDErrorCodes.E006.detailedResponseMessage))
            return false
        }
        
        guard  authenticateParams.currency.isOnlyLetters, authenticateParams.currency.count == 3  else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E005.rawValue, code: GDErrorCodes.E005.description, detailedResponseMessage: GDErrorCodes.E005.detailedResponseMessage))
            return false
        }
        
        guard !authenticateParams.paymentMethod.cvv.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E008.rawValue, code: GDErrorCodes.E008.description, detailedResponseMessage: GDErrorCodes.E008.detailedResponseMessage))
            return false
        }
        
        guard authenticateParams.paymentMethod.cvv.isNumber && (authenticateParams.paymentMethod.cvv.count == 3 ||  authenticateParams.paymentMethod.cvv.count == 4) else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E007.rawValue, code: GDErrorCodes.E007.description, detailedResponseMessage: GDErrorCodes.E007.detailedResponseMessage))
            return false
        }
        
        guard !authenticateParams.paymentMethod.cardholderName.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E013.rawValue, code: GDErrorCodes.E013.description, detailedResponseMessage: GDErrorCodes.E013.detailedResponseMessage))
            return false
        }
        
        guard !authenticateParams.paymentMethod.cardNumber.isEmpty else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E014.rawValue, code: GDErrorCodes.E014.description, detailedResponseMessage: GDErrorCodes.E014.detailedResponseMessage))
            return false
        }
        
        guard authenticateParams.paymentMethod.expiryDate.month > 0 &&  authenticateParams.paymentMethod.expiryDate.month <= 12 else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E015.rawValue, code: GDErrorCodes.E015.description, detailedResponseMessage: GDErrorCodes.E015.detailedResponseMessage))
            return false
        }
        
        guard authenticateParams.paymentMethod.expiryDate.year > 0 &&  authenticateParams.paymentMethod.expiryDate.year <= 99 else {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E017.rawValue, code: GDErrorCodes.E017.description, detailedResponseMessage: GDErrorCodes.E017.detailedResponseMessage))
            return false
        }
        
        if let safeCallback = authenticateParams.callbackUrl {
            guard !safeCallback.isEmpty, safeCallback.isValidURL else {
                GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E009.rawValue, code: GDErrorCodes.E009.description, detailedResponseMessage: GDErrorCodes.E009.detailedResponseMessage))
                return false
            }
        }
        
        if let safeEmail = authenticateParams.customerEmail {
            guard safeEmail.isValidEmail else {
                GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E016.rawValue, code: GDErrorCodes.E016.description, detailedResponseMessage: GDErrorCodes.E016.detailedResponseMessage))
                return false
            }
        }
        
        if let safeBillingCountryCode = authenticateParams.billingAddress?.countryCode {
            guard safeBillingCountryCode.isOnlyLetters, safeBillingCountryCode.count == 3 else {
                GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E011.rawValue, code: GDErrorCodes.E011.description,  detailedResponseMessage: GDErrorCodes.E011.detailedResponseMessage))
                return false
            }
        }
        
        if let safeShippingCountryCode = authenticateParams.shippingAddress?.countryCode {
            guard safeShippingCountryCode.isOnlyLetters, safeShippingCountryCode.count == 3 else {
                GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: GDErrorCodes.E012.rawValue, code: GDErrorCodes.E012.description, detailedResponseMessage: GDErrorCodes.E012.detailedResponseMessage))
                return false
            }
        }
        
        return true
    }
}

fileprivate extension String {
    static let paymentScreenTitle = "PAYMENT_SCREEN_TITLE".localized
    static let webViewScreenTitle = "WEBVIEW_SCREEN_TITLE".localized
}

