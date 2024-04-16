//
//  GeideaPaymentAPI.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12/10/2020.
//

import Foundation
import UIKit
import PassKit


@objc public class GeideaPaymentAPI: NSObject {
    
    
    // MARK: - Type Properties
    
    /// Completion handler: internal use
    var returnAction: ((Codable?, GDErrorResponse?)->()) = {_,_ in }
    
    /// Singleton instance: internal use
    static let shared = GeideaPaymentAPI()
    
    /// Singleton private initializer: internal use
    private override init() {}
    
    /**
     Check if  login storage already available in SDK
     
     # Examples
     
     Add this to check if credentials are already stored in the SDK Secure storage
     
     ```swift
     if !GeideaPaymentAPI .isCredentialsAvailable() {
     GeideaPaymentAPI.setCredentials(withMerchantKey:  "publicKey", andPassword: "password")
     }
     ```
     
     ```objectiveC
     if (![GeideaPaymentAPI isCredentialsAvailable]) {
     [GeideaPaymentAPI setCredentialsWithMerchantKey: @"merchantPublicKey" andPassword: @"merchantPassword"];
     }
     ```
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func isCredentialsAvailable() -> Bool {
        guard let credentials = shared.getCredentials(), !credentials.0.isEmpty, !credentials.1.isEmpty else {
            return false
        }
        return true
    }
    
    /**
     Set login credentials / authenticate in SDK with merchat publicKey and password
     
     - Parameters:
     - merchantKey:String - The Geidea assigned merchantPublicKey. **Required**
     - password:String - The Geidea assigned password. **Required**
     
     # Examples
     
     Add this to check if credentials are already stored in the SDK Secure storage
     
     ```swift
     if !GeideaPaymentAPI .isCredentialsAvailable() {
     GeideaPaymentAPI.setCredentials(withMerchantKey:  "merchantKey", andPassword: "password")
     }
     ```
     
     ```objectiveC
     if (![GeideaPaymentAPI isCredentialsAvailable]) {
     [GeideaPaymentAPI setCredentialsWithMerchantKey: @"merchantPublicKey" andPassword: @"merchantPassword"];
     }
     ```
     - Attention: Be sure to authenticate your app with  SDK before continue with payment process  **pay**
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func setCredentials(withMerchantKey merchantKey: String, andPassword password: String) {
        shared.removeCredentials()
        shared.storeCredentials(merchantKey: merchantKey, password: password)
    }
    
    /**
     Starting the payment flow
     
     - Parameters:
     - amount: GDAmount - SDK GDAmount object  **Required**
     amount: Double **Required**
     currency: String **Required**
     - cardDetails: GDCardDetails - SDK GDCardDetails object  **Required**
     cardholderName: String **Required**
     cardNumber: String **Required**
     cvv: String **Required**
     expiryYear: Int **Required**
     expiryMonth: Int **Required**
     - tokenizationDetails: GDTokenizationDetails **Optional**
     cardOnFile: Bool **Optional** true for tokenization
     initiatedBy: String **Optional** Must be "Internet" if card On file true
     agreementID: String **Optional** Any value
     agreementType String **Optional** e.g "Recurring" , "installment" ,"Unscheduled" , etc
     - paymentIntentId: String  **Optional** PaymentIntent id for paying a PaymentIntent created before
     - customerDetails: GDCustomerDetails - SDK GDCustomerDetails object use for internal customer reference for customer info  . **Optional**
     customerEmail: String **Optional**
     callbackUrl: String **Optional**
     merchantReferenceId: String **Optional**
     paymentOperation: PaymentOperation **Optional**
     - shippingAddress: GDAddress **Optional**
     countryCode: String **Optional**
     city: String **Optional**
     street: String **Optional**
     postCode: String **Optional**
     - billingAddress: GDAddress **Optional**
     countryCode: String **Optional**
     city: String **Optional**
     street: String **Optional**
     postCode: String **Optional**
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     two options for starting the SDK:
     self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     navigationController type of: UINavigationController  the SDK will be pushed from customer app NavigationCotroller
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the payment flow
     
     ```swift
     let amount = GDAmount(amount: Double, currency: String)
     let cardDetails = GDCardDetails(withCardholderName: cardHolderName: String, andCardNumber:  cardNumber: String, andCVV: cvv: String, andExpiryMonth: expiryMonth: Int)
     let tokenizationDetails = GDTokenizationDetails(withCardOnFile:Bool (true if the card will be tokenized), initiatedBy:  "Internet" (can be null if cardOnFile false otherwise mandatory), agreementId: String, String)
     let shippingAddress = GDAddress(withCountryCode: shippingCountryCode: String, andCity: shippingCity: String, andStreet: shippingStreet: String, andPostCode: shippingPostalCode: String)
     let billingAddress = GDAddress(withCountryCode: billingCountryCode: String, andCity: billingCity: String, andStreet: billingStreet: String, andPostCode: billingPostalCode: String)
     let customerDetails = GDCustomerDetails(withEmail: email: String, andCallbackUrl: callback: String, merchantReferenceId: merchantRefid: String, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: .pay or .preAuthorize etc..)
     
     guard let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
     return
     }
     
     GeideaPaymentAPI.pay(theAmount: amount, withCardDetails: cardDetails, andTokenizationDetails: tokenizationDetails, andPaymentIntentId: paymentIntentId,andCustomerDetails: customerDetails, navController: **navVC** or **self**, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     // Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     // if orderResponse.detailedStatus == "Authorized" {
     // TODO: save order.orderId
     // }
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amunt doubleValue] currency: NSString *curency];
     
     GDCardDetails *cardDetails = [[GDCardDetails alloc] initWithCardholderName: NSString *cardHolderName andCardNumber: NSString *cardNumber andCVV: NSString *cvv andExpiryMonth: [expiryMonth integerValue] andExpiryYear: [expiryYear integerValue]];
     
     GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:Bool initiatedBy: NSString  agreementId:NSString agreementType:NSString];
     
     GDAddress *shippingAddress = [[GDAddress alloc] initWithCountryCode:NSString *shippingCountryCode andCity:_shippingCityTF.text andStreet:_shippingStreetTF.text andPostCode:_shippingPostCodeTF.text];
     
     GDAddress *billingAddress = [[GDAddress alloc] initWithCountryCode:_billingCountryCodeTF.text andCity:_billingCityTF.text andStreet:_billingStreetTF.text andPostCode:_billingPostCodeTF.text];
     
     GDCustomerDetails *customerDetails = [[GDCustomerDetails alloc] initWithEmail:_emailTF.text andCallbackUrl:_callbackUrlTF.text merchantReferenceId:_merchantRefIDTF.text shippingAddress:shippingAddress billingAddress:billingAddress paymentOperation: PaymentOperationPay];
     
     [GeideaPaymentAPI payWithTheAmount:amount withCardDetails:cardDetails  andTokenizationDetails: tokenizationDetails andPaymentIntentId: paymentIntentId andCustomerDetails:customerDetails dismissAction:NULL navController: **navVC** or **self** completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions (InitistedBy = "Merchant")
     // TODO: check  [order tokenId] != NULL
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     if ([[order detailedStatus] isEqual: @"Authorized"]) {
     TODO: save order.orderId
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDCardDetails, GDTokenizationDetails, GDCustomerDetails, GDAddress, GDOrderResponse, GDErrorResponse
     - Since: 1.0
     - Version: 1.0`
     */
    @objc public static func pay(theAmount amount: GDAmount, withCardDetails cardDetails: GDCardDetails, initializeResponse: GDInitiateAuthenticateResponse? = nil, config: GDConfigResponse?, isHPP: Bool = false, showReceipt: Bool, andTokenizationDetails tokenizationDetails: GDTokenizationDetails?, andPaymentIntentId paymentIntentId: String? = nil, andCustomerDetails customerDetails: GDCustomerDetails?, orderId:String? = nil, paymentMethods: [String]? = nil, sessionId: String? = nil,  dismissAction: ((GDCancelResponse?, GDErrorResponse?) -> Void)? = nil,navController: UIViewController, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Pay")
        
        let paymentCoordinator = PaymentCoordinator(with: navController, authenticateParams: AuthenticateParams(amount: amount, cardDetails: cardDetails,tokenizationDetails: tokenizationDetails, paymentIntentId: paymentIntentId, customerDetails: customerDetails, orderId: orderId, paymentMethods: paymentMethods, sessionId: sessionId), config: config, showReceipt: showReceipt, initializeResponse: initializeResponse, isHPP: isHPP, completion: { payResponse, error in
            completion(payResponse, error)
        })
        
        paymentCoordinator.dismissAction = dismissAction
        
        paymentCoordinator.start()
    }
    
    @objc public static func initiateAuthenticate(theAmount amount: GDAmount, withCardNumber cardNumber: String?, andTokenizationDetails tokenizationDetails: GDTokenizationDetails?, andPaymentIntentId paymentIntentId: String? = nil, andCustomerDetails customerDetails: GDCustomerDetails?, orderId:String? = nil, paymentMethods: [String]? = nil, dismissAction: ((GDCancelResponse?, GDErrorResponse?) -> Void)? = nil,navController: UIViewController, completion: @escaping (GDInitiateAuthenticateResponse?, GDErrorResponse?, _ sessionId: String?) -> Void) {
        
        logEvent("Initiate")
        
        let initiateAuthentication = InitiateAuthenticateParams(amount: amount, cardNumber: cardNumber, tokenizationDetails: tokenizationDetails, paymentIntentId: paymentIntentId, customerDetails: customerDetails, orderId: orderId, paymentMethods: paymentMethods, sessionId: nil)
        
        AuthenticateManager.createSession(with: initiateAuthentication) { response, request, error in
            guard let sessionId = response?.session.id else {
                completion(nil, error, nil)
                return
            }
            let req = InitiateAuthenticateParams(amount: amount, cardNumber: cardNumber, tokenizationDetails: tokenizationDetails, paymentIntentId: paymentIntentId, customerDetails: customerDetails, orderId: orderId, paymentMethods: paymentMethods, sessionId: response?.session.id)
            AuthenticateManager().initiate(with: req, completion: { response, error in
                completion(response, error, sessionId)
            })
        }
        
        
    }
    
    /**
     Starting the payment flow using Geidea Form including the Payment selection screen with available methods
     This available methods can be restricted by using the parameter paymentMethods
     - paymentMethods: [String]  **Optional** if null the Form will be configured from your  merchant config GDConfigResponse
     For example by using paymentMethods: ["visa"] the card payment will be restricted only on visa, other payment types will be restricted by the system
     Availble keywords: meezaDigital, visa, mastercard, mada, meeza
     
     - Card payment see - Parameters section
     - ApplePay payment  **Optional**
     You will need to add an extra paramater:
     - applePayDetails: GDApplePayDetails **Optional** to use this feature
     - QR payment  **Optional** Available in Egypt
     You will need to add some extra paramaters if you want to use this payment type
     - qrCustomerDetails:  GDPICustomer  **Required**
     - qrExpiryDate: String **Required** yyyy-MM-dd
     
     
     
     - Parameters:
     - amount: GDAmount - SDK GDAmount object  **Required**
     amount: Double **Required**
     currency: String **Required**
     - showAddress: Bool  **Required** true or false if you use your own addresses form
     - showEmail: Bool  **Required** true or false if you use your own email form
     - showReceipt: Bool  **Required** true or false.  set to true if you want a Receipt UI for Success or Failure. False if you want to made a branded Success /Failure scren
     - tokenizationDetails: GDTokenizationDetails **Optional**
     cardOnFile: Bool **≈** true for tokenization
     initiatedBy: String **Optional** Must be "Internet" if card On file true
     agreementID: String **Optional** mercha
     agreementType String **Optional** e.g "Recurring" , "installment" ,"Unscheduled" , etc
     - applePayDetails: GDApplePayDetails - SDK GDApplePayDetails **Optional** necessary if you want to use this feature
     - config: GDConfigResponse - SDK GDConfigResponse **Optional** if you provide your saved config, otherwise it will be refreshed inside the form
     - customerDetails: GDCustomerDetails - SDK GDCustomerDetails object use for internal customer reference for customer info . if you use it with showAddress and showEmail, form will be completed automatically with details provided **Optional**
     customerEmail: String **Optional**
     callbackUrl: String **Optional**
     merchantReferenceId: String **Optional**
     paymentOperation: PaymentOperation **Optional**
     - shippingAddress: GDAddress **Optional**
     countryCode: String **Optional**
     city: String **Optional**
     street: String **Optional**
     postCode: String **Optional**
     - billingAddress: GDAddress **Optional**
     countryCode: String **Optional**
     city: String **Optional**
     street: String **Optional**
     postCode: String **Optional**
     - paymentIntentId: String  **Optional** paymentIntentId id for paying a paymentIntent created before
     - qrCustomerDetails: GDPICustomer **Optional** QRCustomerDetails if you want to integrate meeza
     - qrExpiryDate: String **Optional** QRCustomerDetails if you want to integrate meeza with a custom expiryDate, default is on month
     - paymentMethods:  [String] **Optional** You can restrict paymentMethods with the values QR, visa, mastercard meeza, mada
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the payment flow
     
     ```swift
     let amount = GDAmount(amount: Double, currency: String)
     let tokenizationDetails = GDTokenizationDetails(withCardOnFile:Bool (true if the card will be tokenized), initiatedBy:  "Internet" (can be null if cardOnFile false otherwise mandatory), agreementId: String, agreementType: String)
     let applePayDetails = GDApplePayDetails(in: self, andButtonIn: applePayBtnView or null if use payment selection list, forMerchantIdentifier: "merchant.company. etc.", withCallbackUrl: String, andReferenceId: String)
     
     GeideaPaymentAPI.payWithGeideaForm(theAmount: amount, showAddress: Bool, showEmail: Bool, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePayDetails: applePayDetails, config: self.merchantConfig, paymentIntentIdId: paymentIntentIdId, navController: self, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     // Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     // if orderResponse.detailedStatus == "Authorized" {
     // TODO: save order.orderId
     // }
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amunt doubleValue] currency: NSString *curency];
     
     GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:Bool initiatedBy: NSString  agreementId:NSString agreementType:NSString];
     
     GDApplePayDetails *applePayDetails = [[GDApplePayDetails alloc] initIn:self andButtonIn:_applePayBtnView forMerchantIdentifier:@"merchant.etc" withCallbackUrl:String andReferenceId:String];
     
     
     [GeideaPaymentAPI payWithGeideaFormWithTheAmount:amount showAddress:Bool showEmail:Bool tokenizationDetails:tokenizationDetails customerDetails:NULL applePayDetails:applePayDetails config:self.config paymentIntentIdId: paymentIntentIdId navController: **self** completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions (InitistedBy = "Merchant")
     // TODO: check  [order tokenId] != NULL
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     if ([[order detailedStatus] isEqual: @"Authorized"]) {
     TODO: save order.orderId
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDApplePayDetails, GDTokenizationDetails,GDConfigResponse,  GDCustomerDetails, GDAddress, GDOrderResponse, GDErrorResponse, GDApplePayResponse
     - Since: 1.0
     - Version: 1.0
     */
    
    
    @objc public static func payWithGeideaForm(theAmount amount: GDAmount, showAddress: Bool, showEmail: Bool, showReceipt: Bool, tokenizationDetails: GDTokenizationDetails? = nil, customerDetails: GDCustomerDetails?, applePayDetails: GDApplePayDetails? = nil, config: GDConfigResponse?, paymentIntentId: String? = nil, qrDetails: GDQRDetails? = nil, bnplItems:[GDBNPLItem]? = nil, cardPaymentMethods: [String]? = nil, paymentSelectionMethods: [GDPaymentSelectionMetods]? = nil , viewController: UIViewController, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Pay With Geidea Form")
        
        if let amountError = shared.isAmountValid(authenticateParams: amount) {
            completion(nil, amountError)
            
            return
        }
        
        if let customerD = customerDetails {
            if let customerDetailsError = shared.isCustomerDetailsValid(authenticateParams: customerD) {
                completion(nil, customerDetailsError)
                return
            }
        }
        
        
        if let paymentMethodsError = shared.isPaymentMethodsValid(paymentMethods: cardPaymentMethods, config: config ) {
            completion(nil, paymentMethodsError)
            return
        }
        
        if let pms = paymentSelectionMethods {
            if let selectPaymentMethodsError = shared.isPaymentSelectionMethodsValid(paymentMetodsSelection: pms, config: config ) {
                completion(nil, selectPaymentMethodsError)
                return
            }
        }
        
        
        if viewController is UINavigationController {
            completion(nil, GDErrorResponse().withError(error: SDKErrorConstants.NAV_ERROR))
        }
        
        
        
        FormCoordinator(with: amount, showAddress: showAddress, showEmail: showEmail, showReceipt: showReceipt, andTokenizationDetails: tokenizationDetails, andCustomerDetails: customerDetails, andApplePayDetails: applePayDetails, andConfig: config, paymentIntentId: paymentIntentId, qrCustomerDetails: GDPICustomer(phoneNumber: qrDetails?.phoneNumber, andPhoneCountryCode: qrDetails?.phoneCountryCode,andEmail: qrDetails?.email, name: qrDetails?.name), qrExpiryDate: qrDetails?.qrExpiryDate, shahryItems: bnplItems,  cardPaymentMethods: cardPaymentMethods, paymentSelectionMethods: paymentSelectionMethods, viewController: viewController, completion: { orderResponse, error in
            completion(orderResponse, error)
        }).start()
        
        
    }
    
    /**
     Starting paying QR flow using Geidea Form
     
     - Parameters:
     - amount: GDAmount - SDK GDAmount object  **Required**
     amount: Double **Required**
     currency: String **Required**
     - customer: GDPaymentIntentCustomer  **Required**
     - expiryDate: Date **Required**
     - merchantPublicKey: String **Required**
     - showReceipt: Bool **Optional** true if you want to show Geidea receipt screen
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the pay QR with Geidea form
     
     ```swift
     let amount = GDAmount(amount: Double, currency: String)
     
     
     GeideaPaymentAPI.payQRWithGeideaForm(theAmount: amount, customer: GDPaymentIntentCustomer, expiryDate: Date, merchantPublicKey: String, showReceipt: Bool, navController: self, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     // Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     // if orderResponse.detailedStatus == "Authorized" {
     // TODO: save order.orderId
     // }
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amount doubleValue] currency: NSString *curency];
     
     
     
     [GeideaPaymentAPI payQRWithGeideaFormWithTheAmount:amount customer:GDPaymentIntentCustomer expiryDate:Date merchantPublicKey:String showReceipt:true navController: **self** completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions (InitistedBy = "Merchant")
     // TODO: check  [order tokenId] != NULL
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     if ([[order detailedStatus] isEqual: @"Authorized"]) {
     TODO: save order.orderId
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDApplePayDetails, GDTokenizationDetails,GDConfigResponse,  GDCustomerDetails, GDAddress, GDOrderResponse, GDErrorResponse, GDApplePayResponse
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func payQRWithGeideaForm(theAmount amount: GDAmount, qrDetails: GDQRDetails, config: GDConfigResponse?, showReceipt: Bool, orderId: String?, callbackUrl:String?, viewController: UIViewController, completion: @escaping (GDOrderResponse?,  GDErrorResponse?) -> Void) {
        
        logEvent("Pay QR With Geidea Form")
        
        if let amountError = shared.isAmountValid(authenticateParams: amount) {
            completion(nil, amountError)
            
            return
        }
        
        guard  let phoneNumber = qrDetails.phoneNumber, !phoneNumber.isEmpty else {
            completion(nil, GDErrorResponse().withCancelCode(responseMessage: GDErrorCodes.E037.rawValue, code: GDErrorCodes.E037.description, detailedResponseCode: GDErrorCodes.E037.description, detailedResponseMessage: GDErrorCodes.E037.detailedResponseMessage, orderId: ""))
            
            return
        }
        
        
        if let amountError = shared.isAmountValid(authenticateParams: amount) {
            completion(nil, amountError)
            
            return
        }
        
        PayQRCoordinator(with: amount, andQRDetials: qrDetails, config: config, orderId: orderId, callbackUrl: callbackUrl, showReceipt: showReceipt, viewController: viewController, completion: { orderResponse, error in
            
            completion(orderResponse, error)
            
        }).start()
        
    }
    
    
    /**
     Starting paying QR flow
     
     - Parameters:
     - amount: GDAmount - SDK GDAmount object  **Required**
     amount: Double **Required**
     currency: String **Required**
     - customer: GDPaymentIntentCustomer  **Required**
     - expiryDate: Date **Required**
     - merchantPublicKey: String **Required**
     - showReceipt: Bool **Optional** true if you want to show Geidea receipt screen
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the pay QR with Geidea form
     
     ```swift
     let amount = GDAmount(amount: Double, currency: String)
     
     
     GeideaPaymentAPI.payQR(theAmount: amount, customer: GDPaymentIntentCustomer, expiryDate: Date, showReceipt: Bool, merchantName: String, navController: self, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     // Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     // if orderResponse.detailedStatus == "Authorized" {
     // TODO: save order.orderId
     // }
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amount doubleValue] currency: NSString *curency];
     
     
     
     [GeideaPaymentAPI payQRWithGeideaFormWithTheAmount:amount customer:GDPaymentIntentCustomer expiryDate:Date, showReceipt:true merchantName:String navController: **self** completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions (InitistedBy = "Merchant")
     // TODO: check  [order tokenId] != NULL
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     if ([[order detailedStatus] isEqual: @"Authorized"]) {
     TODO: save order.orderId
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDApplePayDetails, GDTokenizationDetails,GDConfigResponse,  GDCustomerDetails, GDAddress, GDOrderResponse, GDErrorResponse, GDApplePayResponse
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func payQR(theAmount amount: GDAmount, qrDetails: GDQRDetails?, config: GDConfigResponse?, showReceipt: Bool, merchantName: String?, orderId: String?, callbackUrl: String?,viewController: UIViewController, completion: @escaping (GDOrderResponse?,  GDErrorResponse?) -> Void) {
        
        logEvent("Pay QR With Geidea Form")
        
        if let amountError = shared.isAmountValid(authenticateParams: amount) {
            completion(nil, amountError)
            
            return
        }
        
        if let amountError = shared.isAmountValid(authenticateParams: amount) {
            completion(nil, amountError)
            
            return
        }
        
        PayQRCoordinator(with: amount, andQRDetials: qrDetails, config: config, orderId: orderId, callbackUrl: callbackUrl, showReceipt: showReceipt, viewController: viewController, completion: {orderResponse, error in
            
            completion(orderResponse, error)
        }).start()
        
    }
    
    
    
    
    /**
     Starting the pay with token flow cardDetails already tokenized from Pay request
     
     - Parameters:
     - amount: GDAmount - SDK GDAmount object  **Required**
     amount: Double **Required**
     currency: String **Required**
     - tokenId: String **Required**
     - tokenizationDetails: GDTokenizationDetails **Required**
     initiatedBy: String **Optional** Internet or Merchant
     agreementID: String **Optional**
     agreementType String **Optional** e.g "Installment", "Recurring", etc
     - paymentIntentId: String  **Optional** paymentIntentId id for paying an paymentIntentId created before
     - customerDetails: GDCustomerDetails - SDK GDCustomerDetails object use for internal customer reference for customer info  . **Optional**
     - GDCustomerDetails:
     customerEmail: String **Optional**
     callbackUrl: String **Optional**
     merchantReferenceId: String **Optional**
     paymentOperation: PaymentOperation **Optional**
     - shippingAddress: GDAddress **Optional**
     - GDAddress:
     countryCode: String **Optional**
     city: String **Optional**
     street: String **Optional**
     postCode: String **Optional**
     - billingAddress: GDAddress **Optional**
     - GDAddress:
     countryCode: String **Optional**
     city: String **Optional**
     street: String **Optional**
     postCode: String **Optional**
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     two options for starting the SDK:
     self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - navigationController type of: UINavigationController  the SDK will be pushed from customer app NavigationCotroller
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the pay with token payment flow
     
     ```swift
     let amount = GDAmount(amount: Double, currency: String)
     let tokenizationDetails = GDTokenizationDetails(withCardOnFile: false, initiatedBy: "Internet " or "Merchant", agreementId: someString, agreementType: someString)
     let shippingAddress = GDAddress(withCountryCode: shippingCountryCode: String, andCity: shippingCity: String, andStreet: shippingStreet: String, andPostCode: shippingPostalCode: String)
     let billingAddress = GDAddress(withCountryCode: billingCountryCode: String, andCity: billingCity: String, andStreet: billingStreet: String, andPostCode: billingPostalCode: String)
     let customerDetails = GDCustomerDetails(withEmail: email: String, andCallbackUrl: callback: String, merchantReferenceId: merchantRefid: String, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: .pay or .preAuthorize etc..)
     
     guard let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
     return
     }
     
     GeideaPaymentAPI.payWithToken(theAmount: amount, withTokenId: tokenId, tokenizationDetails: tokenizationDetails, andpaymentIntentIdId: paymentIntentIdId or null, andCustomerDetails: customerDetails, navController: self, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     // Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     // if orderResponse.detailedStatus == "Authorized" {
     // TODO: save order.orderId
     // }
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amunt doubleValue] currency: NSString *curency];
     
     GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:[_cardOnFileSwitch isOn] initiatedBy:[_initiatedByBtn currentTitle] agreementId: @"someString" agreementType: @"someString"];
     
     GDAddress *shippingAddress = [[GDAddress alloc] initWithCountryCode:NSString *shippingCountryCode andCity:_shippingCityTF.text andStreet:_shippingStreetTF.text andPostCode:_shippingPostCodeTF.text];
     
     GDAddress *billingAddress = [[GDAddress alloc] initWithCountryCode:_billingCountryCodeTF.text andCity:_billingCityTF.text andStreet:_billingStreetTF.text andPostCode:_billingPostCodeTF.text];
     
     GDCustomerDetails *customerDetails = [[GDCustomerDetails alloc] initWithEmail:_emailTF.text andCallbackUrl:_callbackUrlTF.text merchantReferenceId:_merchantRefIDTF.text shippingAddress:shippingAddress billingAddress:billingAddress paymentOperation: PaymentOperationPay];
     
     [GeideaPaymentAPI payWithTokenWithTheAmount:amount withTokenId:@"token id from from pay API call response" tokenizationDetails:tokenizationDetails andpaymentIntentIdId: (paymentIntentIdId or null) andCustomerDetails:customerDetails navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     if ([[order detailedStatus] isEqual: @"Authorized"]) {
     TODO: save order.orderId
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDTokenizationDetails, GDCustomerDetails, GDAddress, GDOrderResponse, GDErrorResponse
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func payWithToken(theAmount amount: GDAmount, withTokenId token: String, tokenizationDetails: GDTokenizationDetails, config: GDConfigResponse?, showReceipt: Bool, andPaymentIntentId paymentIntentId:String? = nil, andCustomerDetails customerDetails: GDCustomerDetails?, navController: UIViewController, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Pay with Token Tapped", parameters: ["TOKEN":token])
        
        
        if let tokenError = shared.istokenizationValid(config: config) {
            completion(nil, tokenError)
            
            return
        }
        
        let payTokenParams = PayTokenParams(amount: amount, tokenId: token, paymentIntent: paymentIntentId,  initiatedBy: tokenizationDetails.initiatedBy,agreementId: tokenizationDetails.agreementId, agreementType: tokenizationDetails.agreementType, customerDetails: customerDetails)
        
        PayTokenCoordinator(with: navController, payTokenParams: payTokenParams, config: config,  showReceipt: showReceipt, completion: { payResponse, error in
            completion(payResponse, error)
        }).start()
    }
    
    /**
     Capture  flow
     
     - Parameters:
     - orderId: String from GDOrderResponse  (response from GeideaPaymentAPI.pay or  GeideaPaymentAPI.payWithToken)  **Required**
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     - two options for starting the SDK:
     - self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - navigationController type of: UINavigationController  the SDK will be pushed from customer app NavigationCotroller
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the payment flow
     
     ```swift
     guard let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
     return
     }
     
     GeideaPaymentAPI.capture(with: orderId, navController: **navVC** or **self**, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: remove OrderId and Capture button from UI
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     [GeideaPaymentAPI captureWith:self.orderId navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: remove OrderId and Capture button from UI
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDOrderResponse, GDErrorResponse
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func capture(with orderId: String, callbackUrl: String? = nil, navController: UIViewController, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Capture Tapped", parameters: ["OrderId":orderId])
        
        OperationCoordinator(with: navController, orderId: orderId, callbackURL: callbackUrl, operation: .capture, completion: { payResponse, error in
            completion(payResponse, error)
        }).start()
        
    }
    
    /**
     Refund  flow
     
     - Parameters:
     - orderId: String from GDOrderResponse  (response from GeideaPaymentAPI.pay or  GeideaPaymentAPI.payWithToken)orGeideaPaymentAPI.setupApplePay  **Required**
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     - two options for starting the SDK:
     - self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - navigationController type of: UINavigationController  the SDK will be pushed from customer app NavigationCotroller
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the refund flow
     
     ```swift
     guard let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController  else {
     return
     }
     
     GeideaPaymentAPI.refund(with: orderId, navController: **navVC** or **self**, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: remove OrderId and Refund button from UI
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     [GeideaPaymentAPI refundWith:self.orderId navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: remove OrderId and Refund button from UI
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDOrderResponse, GDErrorResponse
     - Since: 1.0
     - Version:10
     */
    
    @objc public static func refund(with orderId: String, callbackUrl: String? = nil, navController: UIViewController, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Refund", parameters:["OrderId": orderId])
        
        OperationCoordinator(with: navController, orderId: orderId, callbackURL: callbackUrl, operation: .refund, completion: { payResponse, error in
            completion(payResponse, error)
        }).start()
    }
    
    
    /**
     Starting getQRImage  flow
     
     - Parameters:
     - amount: GDAmount - SDK GDAmount object  **Required**
     amount: Double **Required**
     currency: String **Required**
     - customer: GDPaymentIntentCustomer  **Required**
     - expiryDate: Date **Required**
     - merchantPublicKey: String **Required**
     - showReceipt: Bool **Optional** true if you want to show Geidea receipt screen
     - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
     self type of : (UIViewController) the SDK will present modally from customer app UIViewController
     - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     Starting the pay QR with Geidea form
     
     ```swift
     let amount = GDAmount(amount: Double, currency: String)
     
     
     GeideaPaymentAPI.getQRImage(theAmount: amount, customer: GDPaymentIntentCustomer, expiryDate: Date, showReceipt: Bool, merchantName: String, navController: self, completion:{ response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     // Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     // if orderResponse.detailedStatus == "Authorized" {
     // TODO: save order.orderId
     // }
     }
     }
     })
     ```
     
     ```objectiveC
     UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amount doubleValue] currency: NSString *curency];
     
     
     
     [GeideaPaymentAPI getQRImage:amount customer:GDPaymentIntentCustomer expiryDate:Date, showReceipt:true merchantName:String navController: **self** completion:^(GDOrderResponse* order, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (order != NULL) {
     //TODO: display relevant fields from GDOrderResponse
     //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions (InitistedBy = "Merchant")
     // TODO: check  [order tokenId] != NULL
     //TODO: if paymentOperation is PaymentOperation.preAuthorize:
     Save order id in persistence for capturing the payment with // GeideaPaymentApi.capture
     if ([[order detailedStatus] isEqual: @"Authorized"]) {
     TODO: save order.orderId
     }
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDApplePayDetails, GDTokenizationDetails,GDConfigResponse,  GDCustomerDetails, GDAddress, GDOrderResponse, GDErrorResponse, GDApplePayResponse
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func getQRImage(with amount: GDAmount, qrDetails: GDQRDetails?, merchantName: String, orderId: String?, callbackUrl: String?, completion: @escaping (GDQRResponse?, GDErrorResponse?) -> Void) {
        
        QRMeezaPaymentManager().getQRBase64Image(with: GDAmount(amount: amount.amount, currency: amount.currency), cusomerDetails: GDPICustomer(phoneNumber: qrDetails?.phoneNumber, andPhoneCountryCode: "+20", name: qrDetails?.name), expiryDate: qrDetails?.qrExpiryDate, merchantName: merchantName, orderId: orderId, callbackUrl: callbackUrl, completion:  { qrResponse, error  in
            
            completion(qrResponse, error)
        })
    }
    
    @objc public static func requestToPay(withQRCodeMessage message: String, phoneNumber: String, orderId: String? = nil, completion: @escaping (GDRTPQRResponse?, GDErrorResponse?) -> Void) {
        
        if let phoneNumberError = shared.isEgyptPhoneNumberValid(phoneNumber: phoneNumber) {
            completion(nil, phoneNumberError)
            
            return
        }
        
        var sendPhoneNumber = phoneNumber
        
        if phoneNumber.hasPrefix("01"){
            sendPhoneNumber = "002\(phoneNumber)"
        } else if phoneNumber.hasPrefix("+201") {
            sendPhoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "00")
        } else if phoneNumber.hasPrefix("201") {
            sendPhoneNumber = "00\(phoneNumber)"
        }
        
        QRMeezaPaymentManager().requestToPay(with: sendPhoneNumber, qrCodeMessage: message, orderId: orderId, completion: { response, error  in
            
            if let err =  error {
                if !err.responseDescription.isEmpty {
                    err.responseMessage = err.responseDescription
                    err.detailedResponseMessage = err.responseDescription
                }
                completion(nil,err)
                return
            } else {
                completion(response,nil)
                
            }
        })
        
        
    }
    
    @objc public static func checkPaymentIntentStatus(with paymentIntentId: String, atEverySeconds seconds: Int, forMinutes minutes: Int, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) -> Timer{
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(seconds), repeats: true) { timer in
            PaymentIntentManager().getPaymentIntent(with: paymentIntentId, completion: { response, error in
                if let err =  error {
                    
                    timer.invalidate()
                    completion( nil,err)
                    
                    return
                } else {
                    
                    if response?.paymentIntent?.status != "Created" &&  response?.paymentIntent?.status != "Incomplete" {
                        timer.invalidate()
                        if response?.paymentIntent?.status == "Paid" {
                            if let orders = response?.paymentIntent?.orders, let order = orders.first, let orderId = order.orderId {
                                
                                GeideaPaymentAPI.getOrder(with: orderId, completion: { orderResponse, error in
                                    if let err =  error {
                                        completion(nil, err)
                                    } else {
                                        completion(orderResponse, nil)
                                    }
                                })
                            }
                        } else if response?.paymentIntent?.status == "Failed" {
                            let error = GDErrorResponse().withErrorCode(error: GDErrorCodes.E027.rawValue, code: GDErrorCodes.E027.description, detailedResponseMessage: GDErrorCodes.E027.detailedResponseMessage, orderId: response?.paymentIntent?.orders?.last?.orderId ?? "")
                            timer.invalidate()
                            completion(nil, error)
                        } else if response?.paymentIntent?.status == "Expired" {
                            let error = GDErrorResponse().withErrorCode(error: GDErrorCodes.E026.rawValue, code: GDErrorCodes.E026.description, detailedResponseMessage: GDErrorCodes.E026.detailedResponseMessage, orderId: response?.paymentIntent?.orders?.last?.orderId  ?? "")
                            completion(nil, error)
                        }
                    }  else if response?.paymentIntent?.status == "Incomplete" {
                        let error = GDErrorResponse().withErrorCode(error: GDErrorCodes.E028.rawValue, code: GDErrorCodes.E028.description, detailedResponseMessage: GDErrorCodes.E028.detailedResponseMessage, orderId: response?.paymentIntent?.orders?.last?.orderId ?? "")
                        completion(nil, error)
                    }
                }
            }
            )}
        return timer
    }
    
    @objc public static func cancel(with orderId: String, callbackUrl: String? = nil, navController: UIViewController, completion: @escaping (GDCancelResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Cancel", parameters:["OrderId": orderId])
        let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
        CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
            
            completion(nil, error)
        })
        
    }
    
    /**
     Starting the apple pay with flow
     
     - Parameters:
     - applePayDetails:GDApplePayDetails
     - hostViewController: your host ViewController
     - merchantIdentifier: String **Required** "merchant identifier from Apple account."
     - buttonView: UIView as a placeholder where apple Pay Button will be placed **Optional**
     - merchantRefId String **Optional**
     - callbackUrl: String **Optional**
     - amount: GDAmount - SDK GDAmount object  **Required**
     - amount: Double **Required**
     - currency: String **Required**
     - completion: (GDApplePayResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
     
     # Examples
     
     
     ```swift
     let amount = GDAmount(amount: safeAmount, currency: safeCurrency)
     let applePayDetails = GDApplePayDetails(in: self, andButtonIn: applePayBtnView, forMerchantIdentifier: "merchant.company. etc.", withCallbackUrl: String, andReferenceId: String)
     
     GeideaPaymentAPI.setupApplePay(forApplePayDetails: applePayDetails, with: amount, config: merchantConfig, completion: { response, error in
     DispatchQueue.main.async {
     
     if let err = error {
     if err.errors.isEmpty {
     var message = ""
     if err.responseCode.isEmpty {
     message = "\n responseMessage: \(err.responseMessage)"
     } else {
     message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage)"
     }
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     guard let orderResponse = response else {
     return
     }
     
     //TODO: display relevant fields from GDApplePayResponse
     }
     }
     })
     ```
     
     ```objectiveC
     
     GDAmount *amount = [[GDAmount alloc] initWithAmount: [amount doubleValue] currency: NSString *curency];
     
     GDApplePayDetails *applePayDetails = [[GDApplePayDetails alloc] initIn:self andButtonIn:_applePayBtnView forMerchantIdentifier:@"merchant.etc" withCallbackUrl:String andReferenceId:String];
     
     [GeideaPaymentAPI setupApplePayForApplePayDetails:applePayDetails with:amount config:GDConfigResponse completion:^(GDApplePayResponse* response, GDErrorResponse* error) {
     
     if (error != NULL) {
     if (!error.errors || !error.errors.count) {
     NSString *message;
     if ( [error.responseCode length] == 0) {
     message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
     } else {
     message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ ", error.responseCode , error.responseMessage];
     }
     
     //TODO: display relevant fields from GDErrorResponse
     } else {
     //TODO: display relevant fields from GDErrorResponse
     }
     
     } else {
     if (response != NULL) {
     //TODO: display relevant fields from GDApplePayResponse
     }
     }
     }];
     ```
     
     - SeeAlso: GDAmount, GDApplePayDetails, GDConfigResponse, GDApplePayResponse, GDErrorResponse
     - Since: 1.0
     - Version: 1.0
     */
    
    
    @objc public static func setupApplePay(forApplePayDetails applePayDetails: GDApplePayDetails, with amount: GDAmount, config: GDConfigResponse?, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("SETUP ApplePay")
        
        guard let hostViewController = applePayDetails.hostViewController else  {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.APPLE_PAY_HOST_ERROR))
            return
        }
        let controller: ApplePayViewController = ApplePayViewController()
        controller.amount = amount
        controller.applePayParams = applePayDetails
        controller.config = config
        controller.applePayCompletion = completion
        hostViewController.addChildViewController(controller)
        controller.didMove(toParentViewController: applePayDetails.hostViewController)
        
        guard let btnView = applePayDetails.buttonView else  {
            controller.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            applePayDetails.hostViewController?.view.addSubview(controller.view)
            return
        }
        
        controller.view.frame = btnView.bounds
        btnView.addSubview(controller.view)
        
    }
    
    
    /**
     Getting card scheme logo
     
     - Parameters:
     - cardType: CardType  **Required**
     
     # Examples
     
     getting the image
     ```swift
     cardSchemeLogoIV.image = GeideaPaymentAPI.getCardSchemeLogo(withCardNumber: cardNumber)
     
     or if you don't want detector
     
     cardSchemeLogoIV.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: cardType)
     ```
     
     ```objectiveC
     
     _cardSchemeLogoIV.image = [GeideaPaymentAPI getCardSchemeLogoWithCardNumber:cardNumber];
     
     or if you don't want detector
     
     _cardSchemeLogoIV.image  = [GeideaPaymentAPI getCardSchemeLogoWithCardType:CardTypeVisa]
     ```
     
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func getCardSchemeLogo(withCardType cardType: CardType ) -> UIImage? {
        
        logEvent("GET Card Logo", parameters: ["CARD TYPE": cardType.cardSchemeName])
        
        switch cardType {
        case .Visa:
            return UIImage(named: "visa", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        case .MasterCard:
            return UIImage(named: "mastercard", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        case .Mada:
            return UIImage(named: "mada", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        case .Amex:
            return UIImage(named: "amex", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        case .Meeza:
            return UIImage(named: "meeza", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        }
        
    }
    
    @objc public static func getCardSchemeLogo(withCardNumber cardNumber: String?) -> UIImage? {
        
        guard let safeCardNumber = cardNumber else{
            return nil
        }
        
        logEvent("GET Card Logo", parameters: ["CARD NUMBER": safeCardNumber])
        
        if  CardType.Mada.matchesRegex(regex: CardType.Mada.regex, text: safeCardNumber) {
            return UIImage(named: "mada", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        }
        
        if  CardType.Visa.matchesRegex(regex: CardType.Visa.regex, text: safeCardNumber) {
            return UIImage(named: "visa", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        }
        
        if  CardType.MasterCard.matchesRegex(regex: CardType.MasterCard.regex, text: cardNumber) {
            return UIImage(named: "mastercard", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        }
        
        if  CardType.Amex.matchesRegex(regex: CardType.Amex.regex, text: safeCardNumber) {
            return UIImage(named: "amex", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        }
        
        
        return nil
        
    }
    
    /**
     Create PaymentIntent
     
     - Parameters:
     - paymentIntentParams: GDPaymentIntentDetails  **Required**
     
     # Examples
     
     creating the PaymentIntent
     ```swift
     GeideaPaymentAPI.createPaymentIntent(with: paymentIntentParams, completion:{ response, error in
     if let paymentIntent = response?.paymentIntentId {
     // save paymentIntentId for future payment
     }
     
     })
     ```
     
     ```objectiveC
     [GeideaPaymentAPI createPaymentIntentWith:paymentIntentParams completion:^(GDPaymentIntentResponse* order, GDErrorResponse* error) {
     //Use response
     }];
     ```
     - SeeAlso: GDAmount, GDPaymentIntentDetails
     - Since: 1.0
     - Version: 1.0
     */
    
    
    @objc public static func createPaymentIntent(with paymentIntentParams: GDPaymentIntentDetails, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Create PaymentIntent")
        
        PaymentIntentManager().create(with: PaymentIntentParams(paymentIntentDetails: paymentIntentParams)) { (response, error) in
            completion(response, error)
        }
        
    }
    
    @objc public static func sendLinkBySMS(with paymentIntentId: String, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Create PaymentIntent")
        
        PaymentIntentManager().sendLinkBySMS(with: paymentIntentId) { (response, error) in
            completion(response, error)
        }
        
    }
    
    @objc public static func sendLinkByEmail(with paymentIntentId: String, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Create PaymentIntent")
        
        PaymentIntentManager().sendLinkByEmail(with: paymentIntentId) { (response, error) in
            completion(response, error)
        }
        
    }
    
    @objc public static func sendLinkByMultiple(with sendLinkMultipleDetails: GDSendLinkMultipleDetails, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Create PaymentIntent")
        
        PaymentIntentManager().sendLinkMultiple(with: SendLinkMultipleParams(sendDetails: sendLinkMultipleDetails)) { (response, error) in
            completion(response, error)
        }
        
    }
    
    /**
     Update PaymentIntent
     
     - Parameters:
     - paymentIntentParams: GDPaymentIntentDetails  **Required**
     
     # Examples
     
     updating  updatePaymentIntent
     ```swift
     GeideaPaymentAPI.updatePaymentWith(with: paymentIntentParams, completion:{ response, error in
     //Use response
     })
     })
     ```
     
     ```objectiveC
     [GeideaPaymentAPI updatePaymentWith:paymentIntentParams completion:^(GDPaymentIntentResponse* order, GDErrorResponse* error) {
     //Use response
     }];
     ```
     - SeeAlso: GDAmount, GDPaymentIntentDetails
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func updatePaymentIntent(with paymentIntentParams: GDPaymentIntentDetails, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Update PaymentIntent")
        
        PaymentIntentManager().update(with: PaymentIntentParams(paymentIntentDetails: paymentIntentParams)) { (response, error) in
            completion(response, error)
        }
    }
    
    /**
     Get getPaymentIntents
     
     - Parameters:
     - paymentIntentsParams: String  **Required**
     
     # Examples
     
     getting  getPaymentIntents
     ```swift
     GeideaPaymentAPI.getPaymentIntents(with: paymentIntentsParams, completion:{ response, error in
     //Use response
     })
     })
     ```
     
     ```objectiveC
     [GeideaPaymentAPI getPaymentIntentsWith:paymentIntentsParams completion:^(GDPaymentIntentResponse* response, GDErrorResponse* error) {
     //Use response
     }];
     ```
     - SeeAlso: GDAmount, GDPaymentIntentFilter
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func getPaymentIntents(with paymentIntentsParams: GDPaymentIntentFilter, completion: @escaping (GDPaymentIntentsResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get PaymentIntents")
        
        PaymentIntentManager().get(with: paymentIntentsParams, completion: { (response, error) in
            completion(response, error)
            
        })
        
        
    }
    
    /**
     Get GetPaymentIntent
     
     - Parameters:
     - paymentIntentId: String  **Required**
     
     # Examples
     
     getting  PaymentIntent
     ```swift
     GeideaPaymentAPI.getPaymentIntent(with: paymentIntentId, completion:{ response, error in
     //Use response
     })
     })
     ```
     
     ```objectiveC
     [GeideaPaymentAPI getPaymentIntentWith:paymentIntentId completion:^(GDPaymentIntentResponse* response, GDErrorResponse* error) {
     //Use response
     }];
     ```
     
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func getPaymentIntent(with paymentIntentId: String, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get PaymentIntent")
        
        PaymentIntentManager().getInvoice(with: paymentIntentId) { (response, error) in
            completion(response, error)
        }
    }
    
    /**
     Delete PaymentIntent
     
     - Parameters:
     - paymentIntentIdId: String  **Required**
     
     # Examples
     
     deleting  PaymentIntent
     ```swift
     GeideaPaymentAPI.deletePaymentIntent(with: paymentIntentId, completion:{ response, error in
     //Use response
     })
     })
     ```
     
     ```objectiveC
     [GeideaPaymentAPI deletePaymentIntenteWith:paymentIntentId completion:^(GDPaymentIntentResponse*   response, GDErrorResponse* error) {
     //Use response
     }];
     ```
     
     - Since: 1.0
     - Version: 1.0
     */
    
    @objc public static func deletePaymentIntent(with paymentIntentId: String, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Delete PaymentIntent")
        
        PaymentIntentManager().delete(with: paymentIntentId) { (response, error) in
            completion(response, error)
        }
    }
    
    @objc public static func getOrders(with orderParams: GDOrdersFilter?, completion: @escaping (GDOrdersResponse?, GDErrorResponse?) -> Void) {
        
        
        logEvent("Get Orders")
        
        OrdersManager().orders(with: orderParams, completion: {(response, error) in
            completion(response, error)
        })
        
    }
    
    @objc public static func getOrder(with orderId: String, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get Order By Id", parameters: ["ORDERID": orderId])
        
        OrdersManager().orderById(with: orderId, completion: {(response, error) in
            completion(response, error)
        })
        
    }
    
    @objc public static func getMerchantConfig(completion: @escaping (GDConfigResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Get Config")
        
        ConfigManager().getConfig( completion: { config, error in
            completion(config, error)
        })
    }
    
    @objc public static func getMerchantConfig(with productConfig: GDSDKMerchantConfig? = nil, completion: @escaping ([GDSDKMerchantConfigResponse]?, GDErrorResponse?) -> Void) {
        
        logEvent("Get Config")
        
        ConfigManager().getConfig(productMConfig: productConfig, completion: { config, error in
            completion(config, error)
        })
        
    }
    
    // MARK: Testing Public Methods
    
    /**
     Switch networking environment for testing purposes
     
     # Examples
     
     Add this to check if credentials are already stored in the SDK Secure storage
     
     ```swift
     GeideaPaymentAPI.setEnvironment(environment: Environment.dev)
     GeideaPaymentAPI.setEnvironment(environment: Environment.test)
     GeideaPaymentAPI.setEnvironment(environment: Environment.preprod)
     GeideaPaymentAPI.setEnvironment(environment: Environment.prod)
     ```
     
     ```objectiveC
     [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentDev];
     [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentTest];
     [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentPreprod];
     [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentProd];
     ```
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func setEnvironment(environment: Environment) {
        GlobalConfig.shared.environment = environment
    }
    
    /**
     Set language
     
     # Examples
     
     Add this to check if credentials are already stored in the SDK Secure storage
     
     ```swift
     GeideaPaymentAPI.setlanguage(language: Language.english)
     GeideaPaymentAPI.setlanguage(language: Language.arabic)
     ```
     
     ```objectiveC
     [GeideaPaymentAPI setLanguageWithLanguageLanguageEnglish];
     [GeideaPaymentAPI setLanguageWithLanguageLanguageArabic];
     ```
     - Since: 1.0
     - Version: 1.0
     */
    @objc public static func setlanguage(language: Language) {
        GlobalConfig.shared.language = language
        
        UserDefaults.standard.set([GlobalConfig.shared.language.name], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        // Update the language by swaping bundle
        Bundle.setLanguage(GlobalConfig.shared.language.name)
        
        switch GlobalConfig.shared.language {
        case .arabic:
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        default:
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @objc public static func removeCredentials() {
        shared.removeCredentials()
    }
    
    @objc public static func updateCredentials(withMerchantKey merchantKey: String, andPassword password: String) {
        guard let credentials = shared.getCredentials(), !credentials.0.isEmpty, !credentials.1.isEmpty else {
            shared.storeCredentials(merchantKey: merchantKey, password: password)
            return
        }
        
        if credentials.0 != merchantKey {
            shared.removeCredentials()
            shared.storeCredentials(merchantKey: merchantKey, password: password)
        }
    }
    
    
    @objc public static func startPaymentIntent(withPaymentIntentID paymentIntentId: String?, status: String?, type: String, currency: String?, viewController: UIViewController, completion: @escaping (GDPaymentIntentResponse?, GDErrorResponse?) -> Void) {
        
        PaymentIntentCoordinator(with: viewController, paymentIntentId: paymentIntentId, status: status, type: type, currency: currency) { (response, error) in
            completion(response, error)
        }.start()
        
    }
    
    @objc public static func payWithApplePay(withPKPayment pkPayment: PKPayment, callbackUrl : String? = nil, merchentRefId: String? = nil, completion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        
        logEvent("Pay Apple Pay")
        
        ApplePayManager().pay(with: pkPayment, callBackUrl: callbackUrl, merchantRefId: merchentRefId, completion: { applePayResponse, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let response = applePayResponse else {
                    completion(nil, error)
                    return
                }
                
                
                GeideaPaymentAPI.getOrder(with: response.orderId ?? "", completion:{ orderResponse, error in
                    
                    completion(orderResponse, error)
                    
                })
            }
        })
        
    }
    
    @objc public static func getModelString(order: GDOrderResponse) -> String? {
        
        do {
            let data = try JSONEncoder().encode(order)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any?] else {
                throw NSError()
            }
            let decimalData = try JSONSerialization.decimalData(withJSONObject: dictionary, options: .prettyPrinted)
            let stringJson = String(decoding: decimalData, as: UTF8.self)
            return stringJson
            
        } catch  {
            shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
        }
        return nil
        
    }
    
    @objc public static func getQRPaymentString(order: GDRTPQRResponse) -> String? {
        
        do {
            let data = try JSONEncoder().encode(order)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any?] else {
                throw NSError()
            }
            let decimalData = try JSONSerialization.decimalData(withJSONObject: dictionary, options: .prettyPrinted)
            let stringJson = String(decoding: decimalData, as: UTF8.self)
            return stringJson
            
        } catch  {
            shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
        }
        return nil
        
    }
    
    @objc public static func getConfigString(config: GDConfigResponse) -> String? {
        
        do {
            let data = try JSONEncoder().encode(config)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any?] else {
                throw NSError()
            }
            let decimalData = try JSONSerialization.decimalData(withJSONObject: dictionary, options: .prettyPrinted)
            let stringJson = String(decoding: decimalData, as: UTF8.self)
            return stringJson
            
        } catch  {
            shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
        }
        return nil
        
    }
    
    @objc public static func getMMSConfig(order: GDPaymentIntentResponse) -> String? {
        return nil
    }
    
    @objc public static func getPaymentIntentString(order: GDPaymentIntentResponse) -> String? {
        
        do {
            let data = try JSONEncoder().encode(order)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any?] else {
                throw NSError()
            }
            let decimalData = try JSONSerialization.decimalData(withJSONObject: dictionary, options: .prettyPrinted)
            let stringJson = String(decoding: decimalData, as: UTF8.self)
            return stringJson
            
        } catch  {
            shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
        }
        return nil
        
    }
    
    // MARK: Instance Methods
    
    func getCredentials() -> (String, String)? {
        let genericPwdQueryable = GenericPasswordQueryable(service: SecureStoreConstants.SERVICE)
        let secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)
        do {
            let password = try secureStoreWithGenericPwd.getValue(for: SecureStoreConstants.PASSWORD)
            let merchant = try secureStoreWithGenericPwd.getValue(for: SecureStoreConstants.MERCHANT_KEY)
            return ((merchant, password) as? (String, String))
        } catch {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.CREDENTIALS_STORE_ERROR))
        }
        
        return nil
    }
    
    private func storeCredentials(merchantKey: String, password: String) {
        
        let genericPwdQueryable = GenericPasswordQueryable(service: SecureStoreConstants.SERVICE)
        let secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)
        do {
            try secureStoreWithGenericPwd.setValue(password, for: SecureStoreConstants.PASSWORD)
            try secureStoreWithGenericPwd.setValue(merchantKey, for: SecureStoreConstants.MERCHANT_KEY)
        } catch {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.CREDENTIALS_RETREIVE_ERROR))
        }
    }
    
    private func removeCredentials() {
        let genericPwdQueryable = GenericPasswordQueryable(service: SecureStoreConstants.SERVICE)
        let secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)
        
        do {
            try secureStoreWithGenericPwd.removeAllValues()
        } catch {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.CREDENTIALS_REMOVE_ERROR))
        }
    }
    
    private func isPaymentIntentDetailsValid(paymentIntentDetails: GDPaymentIntentDetails) -> GDErrorResponse? {
        
        var isEmailPresent = false
        var isPhonePresent = false
        if let safeEmail = paymentIntentDetails.email, !safeEmail.isEmpty {
            isEmailPresent = true
            guard safeEmail.isValidEmail else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E016.rawValue, code: GDErrorCodes.E016.description, detailedResponseMessage: GDErrorCodes.E016.detailedResponseMessage)
            }
        }
        
        if let safePhone = paymentIntentDetails.phoneNumber, !safePhone.isEmpty {
            isPhonePresent = true
            
            guard safePhone.isValidPaymentIntentPhone else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E020.rawValue, code: GDErrorCodes.E020.description, detailedResponseMessage: GDErrorCodes.E020.detailedResponseMessage)
            }
            
        }
        
        if isEmailPresent || isPhonePresent {
            
        } else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E021.rawValue, code: GDErrorCodes.E021.description, detailedResponseMessage: GDErrorCodes.E021.detailedResponseMessage)
        }
        
        return nil
    }
    
    private func isCustomerDetailsValid(authenticateParams: GDCustomerDetails) -> GDErrorResponse? {
        
        if let safeCallback = authenticateParams.callbackUrl {
            guard !safeCallback.isEmpty, safeCallback.isValidURL else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E009.rawValue, code: GDErrorCodes.E009.description, detailedResponseMessage: GDErrorCodes.E009.detailedResponseMessage)
            }
        }
        
        if let safeEmail = authenticateParams.customerEmail {
            guard safeEmail.isValidEmail else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E016.rawValue, code: GDErrorCodes.E016.description, detailedResponseMessage: GDErrorCodes.E016.detailedResponseMessage)
            }
        }
        
        if let safeBillingCountryCode = authenticateParams.billingAddress?.countryCode {
            guard safeBillingCountryCode.isOnlyLetters, safeBillingCountryCode.count == 3 else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E011.rawValue, code: GDErrorCodes.E011.description,  detailedResponseMessage: GDErrorCodes.E011.detailedResponseMessage)
            }
        }
        
        if let shippingAddress = authenticateParams.shippingAddress {
            guard shippingAddress.street?.count ?? 0 < 255, shippingAddress.city?.count ?? 0 < 255, shippingAddress.postCode?.count ?? 0 < 255 else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E019.rawValue, code: GDErrorCodes.E019.description, detailedResponseMessage: GDErrorCodes.E019.detailedResponseMessage)
            }
        }
        
        if let billingAddressAddress = authenticateParams.billingAddress {
            guard billingAddressAddress.street?.count ?? 0 < 255, billingAddressAddress.city?.count ?? 0 < 255, billingAddressAddress.postCode?.count ?? 0 < 255   else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E018.rawValue, code: GDErrorCodes.E018.description, detailedResponseMessage: GDErrorCodes.E018.detailedResponseMessage)
            }
        }
        
        if let safeShippingCountryCode = authenticateParams.shippingAddress?.countryCode {
            guard safeShippingCountryCode.isOnlyLetters, safeShippingCountryCode.count == 3 else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E012.rawValue, code: GDErrorCodes.E012.description, detailedResponseMessage: GDErrorCodes.E012.detailedResponseMessage)
            }
        }
        
        
        return nil
    }
    
    private func isEgyptPhoneNumberValid(phoneNumber: String?) -> GDErrorResponse? {
        if let safePhoneNumber = phoneNumber, !safePhoneNumber.isEmpty {
            guard safePhoneNumber.isValidEgiptPhone else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E022.rawValue, code: GDErrorCodes.E022.description, detailedResponseMessage: GDErrorCodes.E022.detailedResponseMessage)
            }
            return nil
        } else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E023.rawValue, code: GDErrorCodes.E023.description, detailedResponseMessage: GDErrorCodes.E023.detailedResponseMessage)
        }
    }
    
    private func isPaymentSelectionMethodsValid(paymentMetodsSelection: [GDPaymentSelectionMetods], config: GDConfigResponse?) -> GDErrorResponse? {
        let paymentMethods = paymentMetodsSelection.map { $0.paymentMethods.map{ $0.lowercased()}}
        for pms in paymentMethods {
            let pm = pms
           
            if !pm.isEmpty {
                var validationPM: [String] = pm
                validationPM = validationPM.map {
                    $0.lowercased()
                }
                if  pm.contains("meezadigital".lowercased()) {
                    if config?.isMeezaQrEnabled ?? false {
                        validationPM = pm.filter { $0 != "meezaDigital".lowercased()}
                    } else {
                        return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage + " meezaDigital")
                        
                    }
                }
                
                if  pm.contains("valU".lowercased()) {
                    if config?.isValuBnplEnabled ?? false && pm.count == 1 {
                        validationPM = validationPM.filter { $0 != "valU".lowercased() }
                        
                    } else {
                        return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage)

                    }
                }

                if  pm.contains("shahry".lowercased()  ) {
                    if config?.isShahryCnpBnplEnabled ?? false && pm.count == 1 {
                        validationPM = validationPM.filter { $0 != "shahry".lowercased() }
                    } else {
                        return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage)

                    }
                }

                if  pm.contains("souhoola".lowercased() ) {
                    if config?.isSouhoolaCnpBnplEnabled ?? false && pm.count == 1 {
                        validationPM = validationPM.filter { $0 != "souhoola".lowercased() }
                        
                    } else {
                        return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage )

                    }
                }
                
                if !validationPM.isEmpty  {
                    if let configPM = config?.paymentMethods {
                        let lowerCasedArray = configPM.map {
                            $0.lowercased()
                        }

                        var contains = true
                        for item in validationPM {
                            if !lowerCasedArray.contains(item){
                                contains = false
                            }
                        }

                        guard contains else {
                            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage)
                        }
                    }
                }
                
            }
            
            
        }
        
       
        return nil
    }
    
    private func isPaymentMethodsValid(paymentMethods: [String]?, config: GDConfigResponse?) -> GDErrorResponse? {
        if let pm = paymentMethods, !pm.isEmpty {
            var validationPM: [String] = pm
            validationPM = validationPM.map {
                $0.lowercased()
            }
            if  pm.contains("meezaDigital".lowercased()) {
                if config?.isMeezaQrEnabled ?? false {
                    validationPM = pm.filter { $0 != "meezaDigital".lowercased()}
                } else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage + " meezaDigital")
                    
                }
            }
            
            if  pm.contains("valU".lowercased()) {
                if config?.isValuBnplEnabled ?? false {
                    validationPM = validationPM.filter { $0 != "valU".lowercased() }
                } else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage + " valU")

                }
            }

            if  pm.contains("shahry".lowercased()) {
                if config?.isShahryCnpBnplEnabled ?? false {
                    validationPM = validationPM.filter { $0 != "shahry".lowercased() }
                } else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage + " shahry")

                }
            }

            if  pm.contains("souhoola".lowercased()) {
                if config?.isShahryCnpBnplEnabled ?? false {
                    validationPM = validationPM.filter { $0 != "souhoola".lowercased() }
                } else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage + " souhoola")

                }
            }
            
            if let configPM = config?.paymentMethods {
                let lowerCasedArray = configPM.map {
                    $0.lowercased()
                }
                
                var contains = true
                for item in validationPM {
                    if !lowerCasedArray.contains(item){
                        contains = false
                    }
                }
                
                guard contains else {
                    return GDErrorResponse().withErrorCode(error: GDErrorCodes.E024.rawValue, code: GDErrorCodes.E024.description, detailedResponseMessage: GDErrorCodes.E024.detailedResponseMessage)
                }
            }
            
        }
        return nil
    }
    
    private func isAmountValid(authenticateParams: GDAmount) -> GDErrorResponse? {
        guard authenticateParams.amount > 0 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage)
        }
        
        guard authenticateParams.amount.decimalCount() <= 2 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage)
        }
        
        guard !authenticateParams.currency.isEmpty else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E006.rawValue, code: GDErrorCodes.E006.description, detailedResponseMessage: GDErrorCodes.E006.detailedResponseMessage)
        }
        
        guard  authenticateParams.currency.isOnlyLetters, authenticateParams.currency.count == 3  else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E005.rawValue, code: GDErrorCodes.E005.description, detailedResponseMessage: GDErrorCodes.E005.detailedResponseMessage)
        }
        
        return nil
    }
    
    private func istokenizationValid(config: GDConfigResponse?) -> GDErrorResponse? {
        
        guard let safeConfig = config else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E035.rawValue, code: GDErrorCodes.E035.description, detailedResponseMessage: GDErrorCodes.E035.detailedResponseMessage)
        }
        guard safeConfig.isTokenizationEnabled ?? false else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E034.rawValue, code: GDErrorCodes.E034.description, detailedResponseMessage: GDErrorCodes.E034.detailedResponseMessage)
        }
        
        return nil
    }
    
    
}


