# iOS-SDK version 3.1
Major Changelog from version 2.0
 - Branding added based on your merchant config colors
 - 3DSV2 included for Token payments
 - BNPL installments providers included for Egypt merchants (vAlU, Shahry, Souhoola)
 - updated HPP form  
 
 


# iOS-SDK 
Geidea online gateway iOS mobile SDK solution

# Check Payment Gateway IOS SDK 3.0 Integration guide for all features
# Check SDK Samples for getting started

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

   @import GeideaPaymentSDK;
   
  Initialize Object:

 At your application start up (for example in the AppDelegate) or when a client hits Pay button on your app the SDK authentication must be done.
      1.    Check if the credentials are available on SDK secure storage 
      2.    Authenticate with SDK using setCredentials 
      3.    Get merchant configuration from Geidea server  
      4.    Set your default Language with SDK using setLanguage the SDK will be translated in English or Arabic. The function can be used any time your app switch the language
      5.   Store the configuration for future use


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
     
1.    Drag GeideaPaymentSDK.XCFramework to your Frameworks folder ( Preferred) 
     1. OR   Drag GeideaPaymentSDK.framework to your Frameworks folder )
2.    Add it your target: General -> Frameworks, Libraries and and Embedded Content. 
3.    Choose “Embed & Sign” option on Embed tab 
4.    If your application is Objective C app perform an additional step: Build settings -> Build Options -> Always Embed Swift Standard Libraries set YES
    
# SDK Functions please see the updated documentation
    
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
