# iOS-SDK
Geidea online gateway iOS mobile SDK solution

# Introduction 
The purpose of the iOS Software Development Kit (iOS SDK) Integration guide is to serve as a technical documentation for merchants that want to integrate with Geidea and want to use the Payment Gateway services with their systems. 
When merchants integrate with the iOS SDK they will be able to send parameters from their iOS App when a client is triggering a payment and visualize Geidea Payment SDK for their clients to use to process an online payment.

# Getting Started
SDK Requirements:
    Minimum iOS version: 11.0
 - Swift 4.0, 4.2, 5.X
 - Objective C  

For using iOS SDK in code remember to import the framework in your existing app code:

Example Swift:

    import GeideaPaymentSDK
   
Example Objective C:

    #import <GeideaPaymentSDK/GeideaPaymentSDK
   
  Initialize Object:

   At your application start up (for example in the AppDelegate) or when a client hits Pay button on your app the SDK authentication must be done.
   1.    Check if the credentials are available on SDK secure storage
   2.    Authenticate with SDK using setCredentials 
   3.    Get the merchant Config  and check the flags for available feautures provided in SDK based of your configuration

   The function GeideaPaymentApi.setCredentials() should have the following parameters:
   •    merchantKey: merchantID assigned to you by Geidea
   •    password: password assigned to you by Geidea

   Example Swift:
   
    if !GeideaPaymentApi.isCredentialsAvailable() {
        GeideaPaymentAPI.setCredentials(withMerchantKey: “merchantKey” andPassword: “password”)
    }

   Example Objective C:
    
    if (![GeideaPaymentAPI isCredentialsAvailable]) {
        [GeideaPaymentAPI setCredentialsWithMerchantKey: @"merchantKey" andPassword: @"password"];
    }
    
The function GeideaPaymentApi.getMerchantConfig:

Example Swift:
        
        GeideaPaymentAPI.getMerchantConfig(completion:{ response, error in
            guard let config = response else {
                self.merchantConfig = nil
                return
            }
       // TODO save config in persistence: self.merchantConfig = config
    })

Example Objective C:

    [GeideaPaymentAPI getMerchantConfigWithCompletion:^(GDConfigResponse* config, GDErrorResponse* error) {
        if (config != NULL) {
           TODO: save config in persistence for future use: self->_merchantConfig = config;

        }
    }];
    
# Build and Test

Connect iOS framework:
     To connect iOS framework to your iOS application you should:
     
1.    Drag GeideaPaymentSDK.framework to your Frameworks folder 
    1. OR    Drag GeideaPaymentSDK.XCFramework to your Frameworks folder (Swift App)
2.    Add it your target: General -> Frameworks, Libraries and and Embedded Content. 
3.    Choose “Embed & Sign” option on Embed tab 
4.    If your application is Objective C app perform an additional step: Build settings -> Build Options -> Always Embed Swift Standard Libraries set YES
    
# SDK Functions
    
 1. Start payment flow using GeideaPaymentApi.pay function. You also can use the GeideaPaymentApi.payWithGeideaForm in section 2.
    When the user clicked on the pay button from your application you can call the payment function: GeideaPaymentApi.pay with the above parameters described above
    
Initialize Payment flow using GeideaSDKPayment objects:
    The function GeideaPaymentApi.pay should have the following parameters:

-   amount: GDAmount - SDK GDAmount object  **Required**
     - amount: Double **Required**
     - currency: String **Required**
- cardDetails: GDCardDetails - SDK GDCardDetails object  **Required**
    - cardholderName: String **Required**
    - cardNumber: String **Required**
    -  cvv: String **Required**
    -   expiryYear: Int **Required**
    - expiryMonth: Int **Required**
- tokenizationDetails: GDTokenizationDetails **Optional**
    -  cardOnFile: Bool **Optional** true for tokenization
    -  initiatedBy: String **Optional** Must be "Internet" if card On file true
    -  agreementID: String **Optional** Any value
    -  agreementType String **Optional** e.g "Recurring" , "installment" ,"Unscheduled" , etc
- eInvoice: String  **Optional** EInvoice id for paying an EInvoice created before
- customerDetails: GDCustomerDetails - SDK GDCustomerDetails object use for internal customer reference for customer info  . **Optional**
    -  customerEmail: String **Optional**
    -  callbackUrl: String **Optional**
    -  merchantReferenceId: String **Optional**
    -  paymentOperation: PaymentOperation **Optional**
- shippingAddress: GDAddress **Optional**
    -  countryCode: String **Optional**
    -  city: String **Optional**
    -  street: String **Optional**
    -  postCode: String **Optional**
- billingAddress: GDAddress **Optional**
    -  countryCode: String **Optional**
    -  city: String **Optional**
    -  street: String **Optional**
    -  postCode: String **Optional**
- navController: UIViewController - Used for presenting SDK Payment flow. **Required**
    - two options for starting the SDK:
    -   self type of : (UIViewController) the SDK will present modally from customer app UIViewController
    -  navigationController type of: UINavigationController  the SDK will be pushed from customer app NavigationCotroller
- completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**

Example parameters Swift:     

    let amount = GDAmount(amount: 23.10, currency:  “SAR“))
    let cardDetails = GDCardDetails(withCardHolderName: “name”,  andCardNumber:  “4111111111111111“,  andCVV: “111”, andExpiryMonth: 12, andExpiryYear: 23))
    let tokenizationDetails = GDTokenizationDetails(withCardOnFile:Bool (true if the card will be tokenized), initiatedBy:  "Internet" (can be null if cardOnFile false otherwise mandatory), agreementId: String, String)
    let shippingAddress = GDAddress(withCountryCode: “some country Code ex: SAU”,  andCity: “some City“,  andStreet: “some street address”, andPostCode: “some postCode address”))
    let billingAddress = GDAddress(withCountryCode: “some country Code ex: SAU”,  andCity: “some City“,  andStreet: “some street address”, andPostCode: “some postCode address”))
    let customerDetails = GDCustomerDetails (withEmail: “valid email address”, andCallbaclUrl: “valid url “, merchantReferenceID: “your reference id”, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: .pay or .preAuthorize etc..))

Example parameters Objective C :

    GDAmount *amount = [[GDAmount alloc] initWithAmount: 23.10 currency: @”SAR”]
    GDCardDetails *cardDetails = [[GDCardDetails alloc] initWithCardholderName: @”name” andCardNumber: @“4111111111111111” andCVV: @”111”andExpiryMonth: 12 andExpiryYear: 23
    GDAddress *shippingAddress = [[GDAddress alloc] initWithCountryCode: @”some country Code ex: SAU” andCity:@”some City” andStreet: @”some address” andPostCode:@”some postalCode”;
    GDAddress *billingAddress = [[GDAddress alloc] initWithCountryCode: @”some country Code ex: SAU” andCity:@”some City” andStreet: @”some address” andPostCode:@”some postalCode”;
    GDCustomerDetails *customerDetails = [[GDCustomerDetails alloc] initWithEmail: @”valid email” andCallbackUrl: @”validURL” merchantReferenceId: @” your reference id” shippingAddress: shippingAddress billingAddress: billingAddress paymentOperation: PaymentOperationPay];
    

Example Swift:

    GeideaPaymentAPI.pay(theAmount: amount, withCardDetails: cardDetails, andTokenizationDetails: tokenizationDetails, andEInvoice: eInvoiceId, andCustomerDetails:  customerDetails, navController: self as UIViewController or navigationController as UINavigationController , completion: response, error in {
    DispatchQueue.main.async {
        If let err = error {
            If err.errors.isEmpty {
                 //TODO: display relevant fields from GDErrorResponse as title, responseMessage, responseCode, detailedResponseMessage, detailedResponseCode: String
                 } else {
     //TODO: display relevant fields from GDErrorResponse as title,  errors
     }
     } else {
        guard let orderResponse = response else {
            return
            }
            //TODO: Display relevant fields from GDOrderResponse
            //TODO: if cardOnFile is true save tokenId from GDOrderResponse in persistence and also agreementId and agreementType for subscriptions
            //TODO: if paymentOperation is PaymentOperation.preAuthorize:
            // Save order id in persistence for making future operations as capturing the payment with // GeideaPaymentApi.capture or Refund etc.. 
            // if orderResponse.detailedStatus == "Authorized" {
                 // TODO: save order.orderId
            // }
            }
          } 
    })


Example Objective C:

    [GeideaPaymentAPI payWithTheAmount:amount withCardDetails: cardDetails andTokenizationDetails: tokenizationDetails andEInvoice: eInvoiceId andCustomerDetails: customerDetails navController: self as UIViewController or navigationController as UINavigationController completion: ^(GDOrderResponse* order, GDErrorResponse* error)  {
         if (error != NULL) {
              if (!error.errors || !error.errors.count) {        
      //TODO: display relevant fields from GDErrorResponse as title, responseMessage, responseCode, detailedResponseMessage, detailedResponseCode: String          
      } else {
                      //TODO: display relevant fields from GDErrorResponse as title, errors
              }
         } else {
            /TODO: display relevant fields from GDOrderResponse
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
         
2. Starting the payment flow using Geidea Form
    When the user clicked on the pay button from your application you can call the payment function: GeideaPaymentApi.payWithGeideaForm with the parameters:
    
    - Parameters:
    - amount: GDAmount - SDK GDAmount object  **Required**
      - amount: Double **Required**
      - currency: String **Required**
    - showAddress: Bool  **Required** true or false if you use your own addresses form
    - showEmail: Bool  **Required** true or false if you use your own email form
    - tokenizationDetails: GDTokenizationDetails **Optional**
        - cardOnFile: Bool **Optional** true for tokenization
        - initiatedBy: String **Optional** Must be "Internet" if card On file true
        - agreementID: String **Optional** Any Value
        - agreementType String **Optional** e.g "Recurring" , "installment" ,"Unscheduled" , etc
    - applePayDetails: GDApplePayDetails - SDK GDApplePayDetails **Optional** necessary if you want to use this feature
    - config: GDConfigResponse - SDK GDConfigResponse **Optional** if you provide your saved config form will use it, otherwise a new network call will be requested inside the Form
    - customerDetails: GDCustomerDetails - SDK GDCustomerDetails object use for internal customer reference for customer info . if you use it with showAddress and showEmail, form will be completed automatically with details provided **Optional**
        -  customerEmail: String **Optional**
        -  callbackUrl: String **Optional**
        -  merchantReferenceId: String **Optional**
        -  paymentOperation: PaymentOperation **Optional**
        - shippingAddress: GDAddress **Optional**
            -   countryCode: String **Optional**
            -   city: String **Optional**
            -   street: String **Optional**
            -  postCode: String **Optional**
        - billingAddress: GDAddress **Optional**
            -  countryCode: String **Optional**
            -  city: String **Optional**
            -  street: String **Optional**
            -  postCode: String **Optional**
    - eInvoiceId: String  **Optional** EInvoice id for paying an EInvoice created before
    - navController: UIViewController - Used for presenting SDK Payment flow. **Required**
       self type of : (UIViewController) the SDK will present modally from customer app UIViewController
    - completion: (GDOrderResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**
    
    Example Swift:     
        
        let amount = GDAmount(amount: Double, currency: String)
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile:Bool (true if the card will be tokenized), initiatedBy:  "Internet" (can be null if cardOnFile false otherwise mandatory), agreementId: String, agreementType: String)
        let applePayDetails = GDApplePayDetails(in: self, andButtonIn: applePayBtnView, forMerchantIdentifier: "merchant.company. etc.", withCallbackUrl: String, andReferenceId: String)
        
        GeideaPaymentAPI.payWithGeideaForm(theAmount: amount, showAddress: Bool, showEmail: Bool, tokenizationDetails: tokenizationDetails, customerDetails: customerDetails, applePayDetails: applePayDetails, config: self.merchantConfig, eInvoiceId: eInvoiceId, navController: self, completion:{ response, error in
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
       
Example Objective C:     

    GDAmount *amount = [[GDAmount alloc] initWithAmount: [amunt doubleValue] currency: NSString *curency];
    GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:Bool initiatedBy: NSString  agreementId:NSString agreementType:NSString];
    GDApplePayDetails *applePayDetails = [[GDApplePayDetails alloc] initIn:self andButtonIn:_applePayBtnView forMerchantIdentifier:@"merchant.etc" withCallbackUrl:String andReferenceId:String];

    [GeideaPaymentAPI payWithGeideaFormWithTheAmount:amount showAddress:Bool showEmail:Bool tokenizationDetails:tokenizationDetails customerDetails:NULL applePayDetails:applePayDetails config:self.config eInvoiceId: eInvoiceId navController: **self** completion:^(GDOrderResponse* order, GDErrorResponse* error) {
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
        
3. Starting the tokenzation payment flow with a Token received from one of the above API calls
    You have to use the same parameters as above without cardDetails 
    
Example Swift:

        let amount = GDAmount(amount: Double, currency: String)
        let tokenizationDetails = GDTokenizationDetails(withCardOnFile: false, initiatedBy: "Internet " or "Merchant", agreementId: someString, agreementType: someString)
        let shippingAddress = GDAddress(withCountryCode: shippingCountryCode: String, andCity: shippingCity: String, andStreet: shippingStreet: String, andPostCode: shippingPostalCode: String)
        let billingAddress = GDAddress(withCountryCode: billingCountryCode: String, andCity: billingCity: String, andStreet: billingStreet: String, andPostCode: billingPostalCode: String)
        let customerDetails = GDCustomerDetails(withEmail: email: String, andCallbackUrl: callback: String, merchantReferenceId: merchantRefid: String, shippingAddress: shippingAddress, billingAddress: billingAddress, paymentOperation: .pay or .preAuthorize etc..)
        
        GeideaPaymentAPI.payWithToken(theAmount: amount, withTokenId: tokenId, tokenizationDetails: tokenizationDetails, andEInvoiceId: EInvoiceId or null, andCustomerDetails: customerDetails, navController: self, completion:{ response, error in
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

Example Objective C:
    
    GDAmount *amount = [[GDAmount alloc] initWithAmount: [amunt doubleValue] currency: NSString *curency];
    GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:[_cardOnFileSwitch isOn] initiatedBy:[_initiatedByBtn currentTitle] agreementId: @"someString" agreementType: @"someString"];
    GDAddress *shippingAddress = [[GDAddress alloc] initWithCountryCode:NSString *shippingCountryCode andCity:_shippingCityTF.text andStreet:_shippingStreetTF.text andPostCode:_shippingPostCodeTF.text];
    GDAddress *billingAddress = [[GDAddress alloc] initWithCountryCode:_billingCountryCodeTF.text andCity:_billingCityTF.text andStreet:_billingStreetTF.text andPostCode:_billingPostCodeTF.text];
    GDCustomerDetails *customerDetails = [[GDCustomerDetails alloc] initWithEmail:_emailTF.text andCallbackUrl:_callbackUrlTF.text merchantReferenceId:_merchantRefIDTF.text shippingAddress:shippingAddress billingAddress:billingAddress paymentOperation: PaymentOperationPay];
    
    [GeideaPaymentAPI payWithTokenWithTheAmount:amount withTokenId:@"token id from from pay API call response" tokenizationDetails:tokenizationDetails andEInvoiceId: (EInvoiceId or null) andCustomerDetails:customerDetails navController: navVC or self completion:^(GDOrderResponse* order, GDErrorResponse* error) {
    
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

4. Pay with Apple Pay using GeideaPaymentAPI.setupApplePay. This is included in the Geidea form if you provide the details
  
  Parameters:
- applePayDetails:GDApplePayDetails
    - merchantIdentifier: String **Required** "merchant identifier from Apple account."
    - hostViewController: your host ViewController (Required if you use your own form, unnecessary for Geidea Form)
    - buttonView: UIView as a placeholder where apple Pay Button will be placed  (Required if you use your own form, unnecessary for Geidea Form)
    -  merchantRefId String **Optional**
    - callbackUrl: String **Optional**
- amount: GDAmount - SDK GDAmount object  **Required**
    -  amount: Double **Required**
    -  currency: String **Required**
- completion: (GDApplePayResponse?, GDErrorResponse?)  -> Void - The completion handler for customer app returned from SDK **Required**

Example Swift:

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

Example Objective C:

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
    
    
5. Capture, Refund, Cancel API 
  
  Capuring an preAuthorized payment in the future

Example Swift
     
        GeideaPaymentAPI.capture(with: orderId, navController: **navVC** or **self**, completion:{ response, error in TODO: check for errors, display result })
        
Example Objective C
        
        [GeideaPaymentAPI captureWith:self.orderId navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) { TODO: check for errors, display result  }];
        
  Refunding a "Paid" or "Captured" payment in the future (Optional on Mobile)

Example Swift
     
        GeideaPaymentAPI.refund(with: orderId, navController: **navVC** or **self**, completion:{ response, error in TODO: check for errors, display result })
        
Example Objective C
        
        [GeideaPaymentAPI refundWith:self.orderId navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) { TODO: check for errors, display result  }];
        
Cancelling an "In Progress" payment in the future (Optional on Mobile)

Example Swift
     
        GeideaPaymentAPI.cancel(with: orderId, navController: **navVC** or **self**, completion:{ response, error in TODO: check for errors, display result })
        
Example Objective C
        
        [GeideaPaymentAPI cancelWith:self.orderId navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) { TODO: check for errors, display result  }];
        
        

6. Other Functions
     - getCardSchemeLogo with card Type  or Card number
        Example Swift: 
        
            cardSchemeLogoIV.image = GeideaPaymentAPI.getCardSchemeLogo(withCardNumber: cardNumber)
            cardSchemeLogoIV.image = GeideaPaymentAPI.getCardSchemeLogo(withCardType: cardType)
            
        Example Objective C:
        
            _cardSchemeLogoIV.image = [GeideaPaymentAPI getCardSchemeLogoWithCardNumber:cardNumber];
            _cardSchemeLogoIV.image  = [GeideaPaymentAPI getCardSchemeLogoWithCardType:CardTypeVisa]
     
     - Create, Delete, Get, Update EInvoice (Optional on Mobile) see Documentation
     - Get all orders, get Order by Id see Documentation
    
# SDK Response

SDK Responses from SDK Payment flow:
     In the completion object you will receive two objects one for Order response and another one for errors. Both objects must be checked for null.

•    GDErrorResponse (Nullable) SDK failure response
-    errors: [String: [String]] - is not empty when bad request is returned
-    status: Int is not empty when bad request is returned
-    title: String can be empty
-    traceId: String is not empty when bad request is returned
-    type: String is not empty when bad request is returned
-    responseCode: String is empty when bad request is returned
-    responseMessage: String is empty when bad request is returned
-    detailedResponseCode: String can be empty
-    detailedResponseMessage: String can be empty
-    orderId: String can be empty

•    GDOrderResponse fields examples (Nullable) please use to display any relevant information

    "order": {
       "createdDate": "2020-11-13T14:40:33.050Z",
        "createdBy": "string",
        "updatedDate": "2020-11-13T14:40:33.050Z",
        "updatedBy": "string",
        "orderId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "amount": 0,
        "currency": "string",
        "detailedStatus": "Initiated",
        "status": "InProgress",
        "threeDSecureId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "merchantId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "merchantPublicKey": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "parentOrderId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "merchantReferenceId": "string",
        "callbackUrl": "string",
        "customerEmail": "string",
        "billingAddress": {
           "countryCode": "string",
           "street": "string",
           "city": "string",
           "postCode": "string"
         },
         "shippingAddress": {
           "countryCode": "string",
           "street": "string",
           "city": "string",
           "postCode": "string"
         },
         "returnUrl": "string",
         "cardOnFile": true,
         "tokenId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
         "paymentMethod": {
           "type": "Card",
           "brand": "string",
           "cardholderName": "string",
           "maskedCardNumber": "string",
           "expiryDate": {
             "month": 0,
             "year": 0
           }
         },
         "totalAuthorizedAmount": 0,
         "totalCapturedAmount": 0,
         "totalRefundedAmount": 0,
         "transactions": [
           {
             "createdDate": "2020-11-13T14:40:33.050Z",
             "createdBy": "string",
             "updatedDate": "2020-11-13T14:40:33.050Z",
             "updatedBy": "string",
             "transactionId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
             "type": "Authentication",
             "status": "InProgress",
             "amount": 0,
             "currency": "string",
             "source": "Mobile",
             "authorizationCode": "string",
             "rrn": "string",
             "paymentMethod": {
               "type": "Card",
               "brand": "string",
               "cardholderName": "string",
               "maskedCardNumber": "string",
               "expiryDate": {
                 "month": 0,
                 "year": 0
               }
             },
             "codes": {
               "acquirerCode": "string",
               "acquirerMessage": "string",
               "responseCode": "string",
               "responseMessage": "string",
               "detailedResponseCode": "string",
               "detailedResponseMessage": "string"
             },
             "authenticationDetails": {
               "acsEci": "string",
               "authenticationToken": "string",
               "paResStatus": "string",
               "veResEnrolled": "string",
               "xid": "string",
               "accountAuthenticationValue": "string",
               "proofXml": "string"
             }
           }
         ]
       }





