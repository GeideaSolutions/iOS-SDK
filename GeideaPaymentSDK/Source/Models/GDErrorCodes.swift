//
//  GDErrorCodes.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 10/11/2020.
//

import Foundation
enum GDErrorCodes: String {
    case E001 = "Missing public key"
    case E002 = "Missing password"
    case E003 = "Invalid amount"
    case E004 = "Missing amount"
    case E005 = "Invalid currency"
    case E006 = "Missing currency"
    case E007 = "Invalid CVV"
    case E008 = "Missing CVV"
    case E009 = "Invalid callback URL"
    case E010 = "Your payment has timed out"
    case E011 = "Invalid billing country code"
    case E012 = "Invalid shipping country code"
    case E013 = "Missing Card holder name"
    case E014 = "Missing card number"
    case E015 = "Invalid expiryMonth"
    case E016 = "Invalid email address"
    case E017 = "Invalid expiryYear"
    case E018 = "Invalid billing address"
    case E019 = "Invalid shipping address"
    case E020 = "Invalid paymentIntent phone number"
    case E021 = "Invalid PaymentIntent"
    case E022 = "Invalid Meeza digital id / Egypt phone number"
    case E023 = "Missing phone number"
    case E024 = "Invalid Payment Methods"
    case E025 = "Apple Pay not avialable on simulator"
    case E026 = "QR Payment Expired"
    case E027 = "QR Payment Failed"
    case E028 = "QR Payment Incomplete"
    case E029 = "Only digits allowed for Phone number / Meeza digital Id"
    case E030 = "Only digits and punctuation allowed for amount"
    case E031 = "Invalid BNPL Items"
    case E032 = "Invalid EGP Currency"
    case E033 = "Down payment limits violated"
    case E034 = "Pay with token not available"
    case E035 = "Config not available"
    case E036 = "Financed Amount must be pozitive"
    case E037 = "Missing Phone number / Meeza digital Id"
    case E068 = "Missing order items"
    
    var description: String {
        get {
            switch self {
            case .E001:
                return "001"
            case .E002:
                return "002"
            case .E003:
                return "003"
            case .E004:
                return "004"
            case .E005:
                return "005"
            case .E006:
                return "006"
            case .E007:
                return "007"
            case .E009:
                return "009"
            case .E010:
                return "010"
            case .E011:
                return "011"
            case .E012:
                return "012"
            case .E013:
                return "013"
            case .E014:
                return "014"
            case .E015:
                return "015"
            case .E016:
                return "016"
            case .E008:
                return "008"
            case .E017:
                return "017"
            case .E018:
                return "018"
            case .E019:
                return "019"
            case .E020:
                return "020"
            case .E021:
                return "021"
            case .E022:
                return "022"
            case .E023:
                return "023"
            case .E024:
                return "024"
            case .E025:
                return "025"
            case .E026:
                return "026"
            case .E027:
                return "027"
            case .E028:
                return "028"
            case .E029:
                return "029"
            case .E030:
                return "030"
            case .E031:
                return "031"
            case .E032:
                return "032"
            case .E033:
                return "033"
            case .E034:
                return "034"
            case .E035:
                return "035"
            case .E036:
                return "036"
            case .E068:
                return "068"
            case .E037:
                return "037"
            }
            
        }
    }
    
    var detailedResponseMessage: String {
        get {
            switch self {
            case .E001:
                return ""
            case .E002:
                return ""
            case .E003:
                return "Invalid amount: Amount must have maximum 2 decimals"
            case .E004:
                return "Invalid amount: Amount must be positive"
            case .E005:
                return "Invalid currency: Currency must have exactly 3 letters"
            case .E006:
                return ""
            case .E007:
                return "Invalid CVV: CVV Must have 3 or 4 digits"
            case .E008:
                return ""
            case .E009:
                return "Invalid callback URL: Callback must be a valid https URL format"
            case .E010:
                return "PAYMENT_TIMEOUT".localized
            case .E011:
                return "Invalid billing country code: Country Code must have exactly 3 letters and supported"
            case .E012:
                return "Invalid shipping country code: Country Code must have exactly 3 letters and supported"
            case .E013:
                return ""
            case .E014:
                return ""
            case .E015:
                return "Invalid expiry month: Must be a digit from 1 to 12"
            case .E016:
                return "Invalid email address: Email address must be valid"
            case .E017:
                return "Invalid expiry year: Must be a digit from 1 to 99"
            case .E018:
                return "Invalid billing address: All fields must have maximum 255 characters"
            case .E019:
                return "Invalid shipping address: All fields must have maximum 255 characters"
            case .E020:
                return "Invalid Phone number: Must be a valid Saudi Arabia number"
            case .E021:
                return "Invalid PaymentIntent: One of the fields email or phone number must be present"
            case .E022:
                return "Invalid Meeza digital id / Egypt phone number"
            case .E023:
                return "Missing phone number"
            case .E024:
                return "Invalid payment methods"
            case .E025:
                return "Apple Pay is not available on Simulator, try on device"
            case .E026:
                return "QR Payment Expired"
            case .E027:
                return "QR Payment Failed"
            case .E028:
                return "QR_FAILED_TITLE".localized
            case .E029:
                return "Only digits allowed for Phone number / Meeza digital Id"
            case .E030:
                return "Only digits allowed for amount"
            case .E031:
                return "GDBNPLItems price sum needs to be equal to order amount "
            case .E032:
                return "For Egypt installment the curency must be EGP"
            case .E033:
                return "DOWNPAYMENT_LIMITS_VIOLATED".localized
            case .E034:
                return "Pay with token is disabled"
            case .E035:
                return "Config is not available."
            case .E036:
                return "Down payment, To-U balance and Cashback amounts cannot exceed the total amount of the order. Please try to input different amounts and try again."
            case .E037:
                return "Customer phone number required for paying with Meeza Digital"
            case .E068:
                return "Missing order items"
            }
        }
    }
}
