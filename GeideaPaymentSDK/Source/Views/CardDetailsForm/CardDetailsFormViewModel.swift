//
//  CardDetailsFromViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 06/01/2021.
//

import Foundation
import UIKit

class CardDetailsFormViewModel: ViewModel {
    var amount: GDAmount
    var cardDetails: GDCardDetails?
    var customerDetails: GDCustomerDetails?
    var config: GDConfigResponse?
    var applePay: GDApplePayDetails?
    var tokenizationDetails: GDTokenizationDetails?
    var paymentIntentId: String?
    var completion: PaymentFormCompletionHandler
    var applePayAction: ((GDOrderResponse?, GDErrorResponse?)->())?
    var configAction: ((GDConfigResponse?, GDErrorResponse?)->())?
    var showAddress: Bool
    var showEmail: Bool
    var showReceipt: Bool
    var initializeResponse: GDInitiateAuthenticateResponse?
    var lastError: GDErrorResponse?
    var paymentMethods: [String]?
    var isEmbedded: Bool = false
    var selectPaymentVM: SelectPaymentMethodViewModel?
    
    var shouldShowApplePay: Bool {
        if let safeConfig = config, applePay != nil {
            return safeConfig.applePay?.isApplePayMobileEnabled ?? false && safeConfig.applePay?.isApplePayMobileCertificateAvailable ?? false
        } else {
            return false
        }
    }
    
    let cardDetailsTitleString = "CARD_DETAILS_TITLE".localized
    let payCardTitleString = "PAY_CARD_TITLE".localized
    let cardNumberLengthInvalid = "CARD_NUMBER_INVALID_LENGTH".localized
    let cardNumberIncomplete = "CARD_NUMBER_INCOMPLETE".localized
    let cardNumberInvalid = "CARD_NUMBER_INVALID".localized
    let unsupportedCardBrand = "CARD_NUMBER_UNSUPPORTED".localized
    let streetNameInvalid = "STREET_INVALID_LENGTH".localized
    let cityNameInvalid = "CITY_INVALID_LENGTH".localized
    let postCodeNameInvalid = "POSTCODE_INVALID_LENGTH".localized
    let cardNameEmpty = "CARD_NAME_EMPTY".localized
    let cardNameInvalid = "CARD_NAME_INVALID".localized
    let emailInvalid = "EMAIL_INVALID".localized
    
    let dateInvalid = "DATE_INVALID".localized
    let dateExpired = "DATE_EXPIRED".localized
    let cvvInvalidLength = "CVV_INVALID_LENTH".localized
    let cvvInvalid = "CVV_INVALID".localized
    let cvvEmpty = "CVV_EMPTY".localized
    
    var formExpirationInterval: TimeInterval = 0
    
    var hasTimeout: Bool = false
    
    var shouldHideShippingAddress: Bool = true
    
    var cardDetailsTitle: String {
        return shouldShowApplePay ? cardDetailsTitleString : cardDetailsTitleString
    }
    
    var cardNumberTitle: String {
        return "CARD_NUMBER_TITLE".localized
    }
    
    var cardNameTitle: String {
        return "CARD_NAME_TITLE".localized
    }
    
    var expiryDateTitle: String {
        return "EXPIRY_DATE_TITLE".localized
    }
    
    var cvvTitle: String {
        return "CVV_TITLE".localized
    }
    
    var cvvPlaceholder: String {
        return "123"
    }
    
    var doneTitle: String {
        return  "DONE_BUTTON".localized
    }
    
    var nextTitle: String {
        return "NEXT_BUTTON".localized
    }
    
    var okButtonTitle: String {
        return "OK_BUTTON".localized
    }
    
    var cancelButtonTitle: String {
        return "CANCEL_BUTTON".localized
    }
    
    var cvvHintTitle: String {
        return "CVV_HINT".localized
    }
    
    var cancelPaymentTitle: String {
        return "CANCEL_PAYMENT".localized
    }
    
    var payTitle: String {
        return  "PAY_BUTTON".localized
    }
    
    var emailTitle: String {
        return "EMAIL".localized
    }
    
    var countryTitle: String {
        return "COUNTRY".localized
    }
    
    var cityTitle: String {
        return "CITY".localized
    }
    
    var streetNameTitle: String {
        return "STREET_NAME".localized
    }
    
    var postCodeTitle: String {
        return "POSTCODE".localized
    }
    
    var OrPayTitle: String {
        return "OR_PAY_CC".localized
    }

    var sameBillingTitle: String {
        return "SAME_BILLING_SHIPPING".localized
    }
            
    var billingAddressTitle: String {
        return "BILLING_ADDRESS".localized
    }
    
    var shippingAddressTitle: String {
        return "SHIPPING_ADDRESS".localized
    }

    var formTimeoutTitle: String {
        return "PAYMENT_TIMEOUT".localized
    }
    
    var cancelledByUserTitle: String {
        return "PAYMENT_CANCELLED".localized
    }
    
    var formUnsuccessful: String {
        return "PAYMENT_UNSUCCESSFUL".localized
    }
    
    init(amount: GDAmount, showAddress: Bool, showEmail: Bool, showReceipt: Bool, customerDetails: GDCustomerDetails?, tokenizationDetails: GDTokenizationDetails?, applePayDetails: GDApplePayDetails?, config: GDConfigResponse?, paymentIntent: String?, paymentMethods: [String]?, isEmbedded: Bool = false, isNavController: Bool, completion: @escaping PaymentFormCompletionHandler) {
        self.amount = amount
        self.applePay = applePayDetails
        self.customerDetails = customerDetails
        self.completion = completion
        self.config = config
        self.tokenizationDetails = tokenizationDetails
        self.showAddress = showAddress
        self.showEmail = showEmail
        self.paymentIntentId = paymentIntent
        self.paymentMethods = paymentMethods
        self.showReceipt = showReceipt
        self.isEmbedded = isEmbedded
        
        
        if let timeout = config?.hppDefaultTimeout {
            formExpirationInterval = TimeInterval(timeout) 
        }
        super.init(screenTitle: "", isNavController: isNavController)
        
    }
    
    var isAmountValidated: GDErrorResponse? {
        return isAmountValid(authenticateParams: amount)
    }
    
    var isCustomerDetailsValidated: GDErrorResponse? {
        if let customerD = customerDetails {
            return isCustomerDetailsValid(authenticateParams: customerD)
        }
        
        return nil
    }
    
    func setupUIWithConfig(buttonView: UIView, vc: UIViewController) {
        
        guard let safeConfig = config else {
            ConfigManager().getConfig(completion: { config, error in
                guard let safeConfig = config else {
                    if let action = self.configAction {
                        action(config,error)
                    }
                    
                    return
                }
                self.config = safeConfig
            })
            return
        }
        
        guard let applePayDetails = applePay else {
            return
        }
        applePayDetails.buttonView = buttonView
        applePayDetails.hostViewController = vc
        
        GeideaPaymentAPI.setupApplePay(forApplePayDetails: applePayDetails, with: amount, config: safeConfig, completion: { [self] response, error in
            
            guard let action = applePayAction else {
                return
            }
            action(response, error)
            
            
        })
        
    }
    
    func payButtonTitle() -> String {
        let formattedAmount = String(format: "%.2f", amount.amount)
        
        switch GlobalConfig.shared.language {
        case .arabic:
            return String(format: payTitle, amount.currency, formattedAmount)
        default:
            return String(format: payTitle, formattedAmount, amount.currency)
        }
        
    }
    
    func isVisa(cardNumber: String) -> Bool? {
        return CardType.Visa.matchesRegex(regex: CardType.Visa.regex, text: cardNumber)
    }
    
    func isMasterCard(cardNumber: String) -> Bool? {
        return CardType.MasterCard.matchesRegex(regex: CardType.MasterCard.regex, text: cardNumber)
    }
    
    func isAmex(cardNumber: String) -> Bool? {
        return CardType.Amex.matchesRegex(regex: CardType.Amex.regex, text: cardNumber)
    }
    
    func isMada(cardNumber: String) -> Bool? {
        return CardType.Mada.matchesRegex(regex: CardType.Mada.regex, text: cardNumber)
    }
    
    func isMeeza(cardNumber: String) -> Bool? {
        return CardType.Meeza.matchesRegex(regex: CardType.Meeza.regex, text: cardNumber)
    }
    
    func detetectValidCardSchemeName(cardNumber: String) -> String? {
        
        if isMada(cardNumber: cardNumber) ?? false {
            return "mada"
        } else if isMasterCard(cardNumber: cardNumber) ?? false {
            return "mastercard"
        }
        
        if isMada(cardNumber: cardNumber) ?? false {
            return "mada"
        } else if isVisa(cardNumber: cardNumber) ?? false {
            return "visa"
        }
        
        if isMeeza(cardNumber: cardNumber) ?? false {
            return "meeza"
        }
        
        if isAmex(cardNumber: cardNumber) ?? false {
            return "amex"
        }
        
        if isMasterCard(cardNumber: cardNumber) ?? false {
            return "mastercard"
        }
        
        if isVisa(cardNumber: cardNumber) ?? false {
            return "visa"
        }
        
        return nil
    }
    
    func cardNumberValidator(cardNumber: String) -> String?  {
        if let error = isCardNumberValid(cardNumber: cardNumber) {
            return error
        }
        return nil
    }
    
    func cardNameValidator(cardName: String) -> String? {
        if let error = isCardNameValid(cardName: cardName) {
            return error
        }
        return nil
    }
    
    
    func emailValidator(email: String) -> String? {
        if email.isEmpty {
            return nil
        }
        guard email.isValidEmail else {
            return emailInvalid
        }
        return nil
    }
    
    func streetValidator(street: String) -> String? {
        if let error = isStreetValid(street: street) {
            return error
        }
        return nil
    }
    
    func cityValidator(city: String) -> String? {
        if let error = isCityValid(city: city){
            return error
        }
        return nil
    }
    
    func postCodeValidator(postCode: String) -> String? {
        if let error = isPostCodeValid(postCode: postCode){
            return error
        }
        return nil
    }
    
    func expiryDateValidator(expiryDate: String) -> String? {
        if let error = isDateValid(expiryDate: expiryDate) {
            return error
        }
        return nil
    }
    
    func cvvValidator(cvv: String, cardNumber: String) -> String?  {
        if let error = isCvvValid(cvv: cvv, cardNumber: cardNumber) {
            return error
        }
        return nil
    }
    
    
    func getCardDetails(cardNumber: String, expiryDate: String, cvv: String, cardName: String) -> GDCardDetails? {
        let fullDate = expiryDate.components(separatedBy: "/")
        guard let month = Int(fullDate[0]) else { return nil }
        guard let year = Int(fullDate[1]) else { return nil }
        
        let safeCardNumber = cardNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil) 
        
        let cardDetails = GDCardDetails(withCardholderName: cardName, andCardNumber: safeCardNumber, andCVV: cvv, andExpiryMonth: month, andExpiryYear: year)
        return cardDetails
    }
    
    func getAddress(countryCode: String, streetNumber: String, city: String, postCode: String) -> GDAddress? {
        
        let address = GDAddress(withCountryCode: countryCode, andCity: city, andStreet: streetNumber, andPostCode: postCode)
        return address
    }
    
    func getCountryFromCountryCode(countryCode: String) -> String {
        if let country = config?.countries?.first(where: { $0.key3 == countryCode }) {
            
            switch GlobalConfig.shared.language {
            case .arabic:
                return country.nameAr ??   CountryConstants.SAUDI_ARABIA_AR
            default:
                return country.nameEn ??   CountryConstants.SAUDI_ARABIA_EN
            }
            
        }
        
        return GlobalConfig.shared.language == .english ? CountryConstants.SAUDI_ARABIA_EN : CountryConstants.SAUDI_ARABIA_AR
        
    }
    
    func isBillingAndShippingSame() -> Bool {
        if isAddressEmpty(address: customerDetails?.shippingAddress) {
            return true
        }
        let sameCountryCode = customerDetails?.billingAddress?.countryCode == customerDetails?.shippingAddress?.countryCode
        let sameCity = customerDetails?.billingAddress?.city == customerDetails?.shippingAddress?.city
        let sameStreet = customerDetails?.billingAddress?.street == customerDetails?.shippingAddress?.street
        let samePostCode = customerDetails?.billingAddress?.postCode == customerDetails?.shippingAddress?.postCode
        return sameCountryCode && sameCity && sameStreet && samePostCode
    }
    
    func isAddressEmpty(address: GDAddress?) -> Bool {
        return address?.countryCode == nil && address?.city == nil && address?.street == nil && address?.postCode == nil
    }
    
    func isPayButonValid(cardNumber: String, expiryDate: String, cvv: String, cardName: String) -> Bool {
        if isCardNumberValid(cardNumber: cardNumber) != nil {
            return false
        }
        
        if isDateValid(expiryDate: expiryDate)  != nil {
            return false
        }
        
        if isCvvValid(cvv: cvv, cardNumber: cardNumber) != nil {
            return false
        }
        
        if isCardNameValid(cardName: cardName) != nil {
            return false
        }
        
        return true
    }
    
    func isCardNumberValid(cardNumber: String) -> String? {
        if cardNumber.isEmpty || cardNumber.count < 15 {
            return cardNumberIncomplete
        }
        
        if !lengthCheck(cardNumber) {
            return cardNumberIncomplete
        } else {
            if !cardBrandCheck(cardNumber) {
                return unsupportedCardBrand
            }
            
            if !luhnCheck(cardNumber) {
                return cardNumberInvalid
            }
        }
        
        return nil
    }
    
    func isDateValid(expiryDate: String) -> String? {
        let fullDate = expiryDate.components(separatedBy: "/")
        let month = Int(fullDate[0])
        guard fullDate.count > 1 else {
            return dateInvalid
        }
        let year = Int(fullDate[1])
        
        guard let safeMonth = month, let safeYear = year, !expiryDate.isEmpty else  {
            return dateInvalid
        }
        
        if expiryDate.count != 5 {
            return dateInvalid
        } else if !dateCheck(month: safeMonth, year: safeYear)  {
            return dateInvalid
        } else if !expiryDateCheck(month: safeMonth, year: safeYear) {
            return dateExpired
        }
        
        return nil
    }
    
    func isCvvValid(cvv: String, cardNumber: String) -> String? {
        
        if cvv.isEmpty {
            return cvvEmpty
        }
            
        if isAmex(cardNumber: cardNumber) ?? false{
            if cvv.count != 4 {
                return cvvInvalidLength
            }
        } else if cvv.count != 3 {
            return cvvInvalidLength
        }
        
        if !cvv.isNumber {
            return cvvInvalid
        }
        
        return nil
    }
    
    func isCardNameValid(cardName: String) -> String? {
        let safeCardName = cardName.trimmingCharacters(in: .whitespaces)
        if safeCardName.isEmpty {
            return cardNameEmpty
        }
        
        if safeCardName.count <= 2 || !safeCardName.isValidCardName {
            return cardNameInvalid
        }
        
        return nil
    }
    
    func isStreetValid(street: String) -> String? {
        
        if street.count > 255  {
            return streetNameInvalid
        }
        
        return nil
    }
    
    func isCityValid(city: String) -> String? {
        
        if city.count > 255  {
            return cityNameInvalid
        }
        
        return nil
    }
    
    func isPostCodeValid(postCode: String) -> String? {
        
        if postCode.count > 255  {
            return postCodeNameInvalid
        }
        
        return nil
    }
    
    private func dateCheck(month: Int, year: Int) -> Bool {
        
        guard month > 0 && month <= 12 else {
            return false
        }
        
        guard year > 0 && year <= 99 else {
            return false
        }
        
        
        return true
    }
    
    private func expiryDateCheck(month: Int, year: Int) -> Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let sYear = Int("\(currentYear)".suffix(2))
        
        guard let currYear = sYear else {
            return false
        }
        
        if currYear > year || (currYear == year && currentMonth > month) {
            return false
        }
        
        return true
    }
    
    private func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1
                
                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    private func lengthCheck(_ number: String) -> Bool {
        if isAmex(cardNumber: number) ?? false && number.count != 15 {
            return false
        }
        if isVisa(cardNumber: number) ?? false && number.count != 16 {
            return false
        }
        
        if isMasterCard(cardNumber: number) ?? false && number.count != 16 {
            return false
        }
        
        if isMada(cardNumber: number) ?? false && number.count != 16 {
            return false
        }
        
        return true
    }
    
    private func cardBrandCheck(_ number: String) -> Bool {
        var supported = false
        if isAmex(cardNumber: number) ?? false {
            supported = true
        }
        if isVisa(cardNumber: number) ?? false {
            supported = true
        }
        
        if isMasterCard(cardNumber: number) ?? false {
            supported = true
        }
        
        if isMada(cardNumber: number) ?? false {
            supported = true
        }
        
        if isMeeza(cardNumber: number) ?? false {
            supported = true
        }
        
        return supported
    }
    
    
    func getAlternativePMDefault() -> AlterantiveType {
        
        guard let safeConfig = config else {
            return .NONE
        }
        
        if let safeSelectPaymentVM = selectPaymentVM, let paymentMethodsObject = safeSelectPaymentVM.paymentSelectionMethods {
            
            var types:[AlterantiveType] = []
            for pmsMethod  in paymentMethodsObject {
                let pm = pmsMethod.paymentMethods.first?.lowercased()
                if pm == "meezaDigital".lowercased() {
                    return .QR
                } else if safeSelectPaymentVM.getAvailableBNPLPaymentMethods().contains(pm ?? "") {
                    
                    switch pm {
                    case "valu":
                        types.append(.VALU)
                    case "souhoola":
                        types.append(.SOUHOOLA)
                    case "shahry":
                        types.append(.SHARY)
                    default: break
                    }
                }
            }
            
            if !types.isEmpty, let first = types.first {
                return first
            }

            return .NONE
        } else {
            if safeConfig.isMeezaQrEnabled {
                return .QR
            } else if safeConfig.isValuBnplEnabled {
                    return .VALU
            } else if safeConfig.isShahryCnpBnplEnabled {
                return .SHARY
            } else if safeConfig.isSouhoolaCnpBnplEnabled {
                return .SOUHOOLA
            } else {
                return .NONE
            }
        }
        
      
        
    }
    
    func getAlternativePMAll() -> AlterantiveType {
        
        guard let safeConfig = config else {
            return .NONE
        }
        
        
        let defaultPM = getAlternativePMDefault()
        var shouldShowAll = false
        
        if defaultPM == .VALU || defaultPM == .SHARY || defaultPM == .SOUHOOLA || defaultPM == .QR {
          
            if let  safeSelectPaymentVM = selectPaymentVM, let paymentMethodsObject = selectPaymentVM?.paymentSelectionMethods {
                
                for pmsMethod  in paymentMethodsObject {
                    let pm = pmsMethod.paymentMethods.first?.lowercased()
                    
                    if pm == "meezaDigital".lowercased() && defaultPM != .QR {
                        shouldShowAll = true
                    }
                    if safeSelectPaymentVM.getAvailableBNPLPaymentMethods().contains(pm ?? "") {
                        
                        switch pm {
                        case "valu":
                            if defaultPM != .VALU {
                                shouldShowAll = true
                            }
                        case "souhoola":
                            if defaultPM != .SOUHOOLA {
                                shouldShowAll = true
                            }
                        case "shahry":
                            if defaultPM != .SHARY {
                                shouldShowAll = true
                            }
                        default: break
                        }
                        
                    }
                }
                
            } else {
                if safeConfig.isMeezaQrEnabled && defaultPM != .QR  {
                    shouldShowAll = true
                }
                if safeConfig.isValuBnplEnabled && defaultPM != .VALU {
                    shouldShowAll = true
                }
                
                if safeConfig.isShahryCnpBnplEnabled && defaultPM != .SHARY {
                    shouldShowAll = true
                }
                if safeConfig.isSouhoolaCnpBnplEnabled && defaultPM != .SOUHOOLA{
                    shouldShowAll = true
                }
                
                
            }
            
            if shouldShowAll {
                return .ALL
            } else {
                return .NONE
            }
           
        }
        
        
        if safeConfig.isMeezaQrEnabled {
            return .QR
        } else if safeConfig.isValuBnplEnabled {
                return .VALU
        } else if safeConfig.isShahryCnpBnplEnabled {
            return .SHARY
        } else if safeConfig.isShahryCnpBnplEnabled {
            return .SOUHOOLA
        } else {
            return .NONE
        }
        
    }
    
    
    func getFilteredPaymentMethods() -> [String]? {
        var filtered: [String]?
        
            
        if let pm = paymentMethods  {
            filtered = pm
            
            if pm.contains("meezaDigital".lowercased())  {
                filtered = filtered?.filter { $0 != "meezaDigital".lowercased()}
            }
            
            if pm.contains("valu".lowercased()) {
                
                filtered = filtered?.filter { $0 != "valu".lowercased()}
            }
            
            if pm.contains("shahry".lowercased()) {
                filtered = filtered?.filter { $0 != "shahry".lowercased() }
            }
            
            if pm.contains("souhoola".lowercased()) {
                filtered = filtered?.filter { $0 != "souhoola".lowercased() }
            }
            
            return filtered
        }
        return nil
    }
    
}

extension CardDetailsFormViewModel {
    func isCustomerDetailsValid(authenticateParams: GDCustomerDetails) -> GDErrorResponse? {
        
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
        
        if let safeShippingCountryCode = authenticateParams.shippingAddress?.countryCode {
            guard safeShippingCountryCode.isOnlyLetters, safeShippingCountryCode.count == 3 else {
                return GDErrorResponse().withErrorCode(error: GDErrorCodes.E012.rawValue, code: GDErrorCodes.E012.description, detailedResponseMessage: GDErrorCodes.E012.detailedResponseMessage)
            }
        }
        
        return nil
    }
    
    func isAmountValid(authenticateParams: GDAmount) -> GDErrorResponse? {
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
}
