//
//  GDMerchantDataResponse.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.10.2021.
//

import Foundation

@objcMembers public class GDMerchantDataResponse: NSObject, Codable {
    
   public var merchantDomain: String? = nil
   public var merchantLogoUrl: String? = nil
   public var isTest: Bool = false
    public var applePaymentProcessingCertificateExpiryDateNew: String? = nil
    public var applePaymentProcessingCertificate: String? = nil
    public var merchantName: String? = nil
    public var isApplePayMobileEnabled: Bool = false
    public var merchantNotificationEmail: String? = nil
    public var merchantGatewayKey: String? = nil
    public var cyberSourceSharedSecretKey: String? = nil
    public var gsdkMid: String? = nil
    public var applePaymentProcessingCertificateNew: String? = nil
    public var applePartnerInternalMerchantIdentifier: String? = nil
    public var cyberSourceMerchantId: String? = nil
    public var appleDeveloperId: String? = nil
    public var applePaymentProcessingCertificateExpiryDate: String? = nil
    public var cyberSourceApiIdentifier: String? = nil
    public var appleCertificatePrivateKey: String? = nil
    public var merchantCountry: String? = nil
    public var cyberSourceOrgUnitId: String? = nil
    public var mpgsMsoProvider: String? = nil
    public var gsdkSecretKey: String? = nil
    public var mpgsMerchantId: String? = nil
    public var customerNotificationFromEmail: String? = nil
    public var isTokenizationEnabled = false
    public var defaultPaymentOperation: String? = nil
    public var allowedInitiatedByValues: [String]?
    public var isApplePayWebEnabled: Bool = false
    public var cardBrandProviders: [GDCardBrandProvider]?
    
    public var isCallbackEnabled = false
    public var customerPaymentNotification = false
    public var isApplePayMobileCertificateAvailable = false
    public var merchantNameAr:String? = nil
    public var appleCsr:String? = nil
    public var cyberSourceMerchantKeyId:String? = nil
    public var isPaymentMethodSelectionEnabled = false
    public var apiPassword:String? = nil
    public var appleCertificatePrivateKeyNew:String? = nil
    public var currencies:[String]? = nil
    public var mpgsApiKey:String? = nil
    public var isTransactionReceiptEnabled = false
    public var merchantWebsite:String? = nil
    public var gsdkTid:String? = nil
    public var cyberSourceApiKey:String? = nil
    public var callbackUrl:String? = nil
    public var isMeezaDigitalEnabled = false
    public var useMpgsApiV60 = false
}
