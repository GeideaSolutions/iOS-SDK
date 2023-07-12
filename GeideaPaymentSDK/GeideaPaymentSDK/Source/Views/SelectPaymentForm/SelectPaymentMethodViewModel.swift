//
//  SelectPaymentMethodViewModel.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 09.08.2021.
//

import UIKit

class PaymentTypeStatus: Equatable {
    
    var selected:Bool
    var item: PaymentItem
    var groupedItems: [PaymentTypeStatus]?
    var config: GDConfigResponse?
    var onSelected: ((PaymentTypeStatus?) -> Void)
    var logos: [UIImage]?
    var pm: [String]?
    
    init(_ item: PaymentItem,_ selected:Bool = false,  config: GDConfigResponse?,  logos:[UIImage]?, pm: [String]? = nil, groupedItems: [PaymentTypeStatus]? = nil, onSelected:  @escaping ((PaymentTypeStatus?) -> Void)) {
        self.item = item
        self.selected = selected
        self.groupedItems = groupedItems
        self.config = config
        self.onSelected = onSelected
        self.pm = pm
        self.logos = logos
        
        
    }
    
    static func == (lhs: PaymentTypeStatus, rhs: PaymentTypeStatus) -> Bool {
        return (lhs.item.paymentType == rhs.item.paymentType) && (lhs.pm == rhs.pm)
    }
    
}

class BNPLGroup {
    let providers: [PaymentTypeStatus]?
    
    init( providers: [PaymentTypeStatus]) {
        self.providers = providers
    }
}

class PaymentItem {
    let paymentType: PaymentType
    var label: String?
    
    init (paymentType: PaymentType, label: String?) {
        self.paymentType = paymentType
        self.label = label
        
        configurePaymentType()
    }
    
    
    func configurePaymentType() {
        if let name = label, !name.isEmpty {
            label = name
        } else {
            label = paymentType.paymentTypeName
        }
    }
}

struct PaymentMethodsMap {
  var paymentItem: PaymentItem?
  var cardSchemes: [String]? = []
  var pm: [String]? = []
  
  init() {}
}

class SelectPaymentMethodViewModel: ViewModel {
    
    var embedded = false
    var amount: GDAmount
    var customerDetails: GDCustomerDetails?
    var config: GDConfigResponse?
    var applePay: GDApplePayDetails?
    var tokenizationDetails: GDTokenizationDetails?
    var paymentIntentId: String?
    var qrCustomerDetails: GDPICustomer?
    var qrExpiryDate: String?
    var nextAction: ((PaymentType, UIViewController?)->())!
    var completion: FormCompletionHandler
    var applePayAction: ((GDOrderResponse?, GDErrorResponse?)->())?
    var configAction: ((GDConfigResponse?, GDErrorResponse?)->())?
    var paymentMethods: [String]?
    var showAddress: Bool
    var showEmail: Bool
    var showReceipt: Bool
    var showQRCode: Bool = false
    var showValu: Bool = true
    var showSouhoola: Bool = true
    var showShahry: Bool = true
    var showApplePay: Bool = false
    var showCard: Bool = false
    var bnplItems: [GDBNPLItem]?
    var paymentSelectionMethods: [GDPaymentSelectionMetods]?
    var paymentMethodsViews: [PaymentMethodsView] = []
    var meeezaPhoneNumber = ""
    
    var shouldShowApplePay: Bool {
        if let pm = paymentMethods {
            if !pm.isEmpty, let safeConfig = config, applePay != nil {
                return safeConfig.applePay?.isApplePayMobileEnabled ?? false && safeConfig.applePay?.isApplePayMobileCertificateAvailable ?? false
            } else {
                return false
            }
        } else {
            if let safeConfig = config, applePay != nil {
                return safeConfig.applePay?.isApplePayMobileEnabled ?? false && safeConfig.applePay?.isApplePayMobileCertificateAvailable ?? false
            } else {
                return false
            }
        }
        
    }
    
    var shouldShowPayQR: Bool {
        if let safeConfig = config {
            if paymentMethods != nil && safeConfig.isMeezaQrEnabled {
                return showQRCode
            } else {
                return safeConfig.isMeezaQrEnabled
            }
        }
        return false
    }
    
    // from User
    var shouldShowPayCard: Bool {
        if let pm = paymentMethods {
            return !pm.isEmpty
        } else {
            if let safeConfig = config, let pm = safeConfig.paymentMethods {
                return !pm.isEmpty
            } else {
                return false
            }
        }
    }
    
    var shouldShowBNPLValu: Bool {
        if let safeConfig = config {
            if paymentMethods != nil && safeConfig.isValuBnplEnabled {
                return showValu
            } else {
                return safeConfig.isValuBnplEnabled
            }
        }
        
        return false
    }
    
    var shouldShowBNPLShahry: Bool {
        if let safeConfig = config {
            if paymentMethods != nil && safeConfig.isShahryCnpBnplEnabled {
                return showShahry
            } else {
                return safeConfig.isShahryCnpBnplEnabled
            }
        }
        return false
    }
    
    var shouldShowBNPLSouhoola: Bool {
        if let safeConfig = config {
            if paymentMethods != nil && safeConfig.isSouhoolaCnpBnplEnabled {
                return showSouhoola
            } else {
                return safeConfig.isSouhoolaCnpBnplEnabled
            }
        }
        return false
    }
    
    var formExpirationInterval: TimeInterval = 0
    
    var hasTimeout: Bool = false
    
    var shouldHideShippingAddress: Bool = true
    
    var selectTitle: String {
        return "PAYMENT_SELECTION_TITLE".localized
    }
    
    var orTitle: String {
        return "PAYMENT_SELECTION_OR".localized
    }
    
    var nextButton: String {
        return "NEXT_BUTTON".localized
    }
    
    var cancelButton: String {
        return "CANCEL_BUTTON".localized
    }
    
    
    init(amount: GDAmount, showAddress: Bool, showEmail: Bool, showReceipt: Bool,customerDetails: GDCustomerDetails?, tokenizationDetails: GDTokenizationDetails?, applePayDetails: GDApplePayDetails?, config: GDConfigResponse?, paymentIntent: String?,  qrCustomerDetails: GDPICustomer?, qrExpiryDate: String?, shahryItems: [GDBNPLItem]?, paymentMethods: [String]?, paymentSelectionMethods: [GDPaymentSelectionMetods]?,isNavController: Bool, embedded: Bool = false, completion: @escaping FormCompletionHandler, nextAction:  @escaping NextHandler) {
        self.amount = amount
        self.applePay = applePayDetails
        self.customerDetails = customerDetails
        self.completion = completion
        self.config = config
        self.tokenizationDetails = tokenizationDetails
        self.showAddress = showAddress
        self.showEmail = showEmail
        self.showReceipt = showReceipt
        self.paymentIntentId = paymentIntent
        self.qrExpiryDate = qrExpiryDate
        self.qrCustomerDetails = qrCustomerDetails
        self.paymentMethods = paymentMethods
        self.paymentSelectionMethods = paymentSelectionMethods
        self.embedded = embedded
        
        var filtered: [String]?
        if let pm = paymentMethods {
            if pm.contains("meezaDigital".lowercased()) {
                showQRCode = true
                filtered = pm.filter { $0.lowercased() != "meezaDigital".lowercased() }
                self.paymentMethods = filtered
            }
            
            if pm.contains("valu".lowercased()) {
                self.showValu = true
                filtered = self.paymentMethods?.filter { $0.lowercased() != "valu" }
                self.paymentMethods = filtered
            } else {
                self.showValu = false
            }
            
            if pm.contains("shahry".lowercased()) {
                self.showShahry = true
                filtered = self.paymentMethods?.filter { $0.lowercased() != "shahry" }
                self.paymentMethods = filtered
            } else {
                self.showShahry = false
            }
            
            if pm.contains("souhoola".lowercased()) {
                self.showSouhoola = true
                filtered = self.paymentMethods?.filter { $0.lowercased() != "souhoola" }
                self.paymentMethods = filtered
            } else {
                showSouhoola = false
            }
        } else {
            self.paymentMethods = paymentMethods
        }
        self.bnplItems = shahryItems
        
        self.nextAction = nextAction
        
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
    
}

extension SelectPaymentMethodViewModel {
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
    
    func isBNPLValid(type: PaymentType?) -> GDErrorResponse? {
        switch type {
        case .ValU:
            if amount.amount < Double(config?.valUMinimumAmount ?? 0) {
                let minAmount = String(config?.valUMinimumAmount ?? 0)
                return GDErrorResponse().withCancelCode(responseMessage: String(format: "VALUE_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency), code: "", detailedResponseCode: "", detailedResponseMessage: String(format: "VALUE_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency) ,orderId: "")
                
            }
            return nil
        case .Souhoola:
            if let bnplItemsValid = self.areBNPLItemsValid(authenticateParams: self.amount, bnplItems: self.bnplItems) {
                
                return bnplItemsValid
                
            }
            if self.amount.amount < Double(self.config?.souhoolaMinimumAmount ?? 0) {
                let minAmount = String(self.config?.souhoolaMinimumAmount ?? 0)
                
                return GDErrorResponse().withCancelCode(responseMessage: String(format: "SOUHOOLA_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency), code: "", detailedResponseCode: "", detailedResponseMessage: String(format: "SOUHOOLA_INSTALLMENT_AMOUNT".localized, minAmount, self.amount.currency) ,orderId: "")
                
            }
            
            return nil
        case .Shahry:
            if let bnplItemsValid = self.areBNPLItemsValid(authenticateParams: self.amount, bnplItems: self.bnplItems) {
                
                return bnplItemsValid
                
            }
            
            return nil
        default: return nil
        }
    }
    
    private func areBNPLItemsValid(authenticateParams: GDAmount, bnplItems: [GDBNPLItem]?) -> GDErrorResponse? {
        
        
        guard  let items = bnplItems, !items.isEmpty else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E068.rawValue, code: GDErrorCodes.E068.description, detailedResponseMessage: GDErrorCodes.E068.detailedResponseMessage)
        }
        
        guard authenticateParams.amount > 0 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E004.rawValue, code: GDErrorCodes.E004.description, detailedResponseMessage: GDErrorCodes.E004.detailedResponseMessage)
        }
        
        guard authenticateParams.amount.decimalCount() <= 2 else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E003.rawValue, code: GDErrorCodes.E003.description, detailedResponseMessage: GDErrorCodes.E003.detailedResponseMessage)
        }
        
        guard !authenticateParams.currency.isEmpty else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E006.rawValue, code: GDErrorCodes.E006.description, detailedResponseMessage: GDErrorCodes.E006.detailedResponseMessage)
        }
        
        guard authenticateParams.currency == "EGP" else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E032.rawValue, code: GDErrorCodes.E032.description, detailedResponseMessage: GDErrorCodes.E032.detailedResponseMessage)
        }
        
        let sum = bnplItems?.lazy.map  { $0.price * Double ($0.count) }.reduce(0, +)
        
        guard authenticateParams.amount == sum else {
            return GDErrorResponse().withErrorCode(error: GDErrorCodes.E031.rawValue, code: GDErrorCodes.E031.description, detailedResponseMessage: GDErrorCodes.E031.detailedResponseMessage)
        }
        return nil
        
    }
    

    func getAvailableCardPaymentMethods() -> [String] {
        guard let configPMs = config?.paymentMethods else  {
            return []
        }
        
        return configPMs
    }
    
    func getAvailableBNPLPaymentMethods() -> [String] {
        var bnplPM: [String] = []
        
        if config?.isValuBnplEnabled ?? false {
            bnplPM.append("valu")
        }
        if config?.isSouhoolaCnpBnplEnabled ?? false {
            bnplPM.append("souhoola")
        }
        
        if config?.isShahryCnpBnplEnabled ?? false {
            bnplPM.append("shahry")
        }
        
        return bnplPM
    }
    
    func getAvailableMeezaDigitalPaymentMethods() -> [String] {
        var bnplPM: [String] = []
        
        if config?.isMeezaQrEnabled ?? false {
            bnplPM.append("valu")
        }
        if config?.isSouhoolaCnpBnplEnabled ?? false {
            bnplPM.append("souhoola")
        }
        
        if config?.isShahryCnpBnplEnabled ?? false {
            bnplPM.append("shahry")
        }
        
        return bnplPM
    }
    
    func isPaymentItemBNPL(item: PaymentItem) -> Bool {
        if item.paymentType == .ValU ||   item.paymentType == .Shahry ||  item.paymentType == .Souhoola {
            return true
        }
        
        return false
    }
    
    func nextBtnEnabled(selectedPM: PaymentTypeStatus? ) -> Bool{
        
        if selectedPM == nil {
            return false
        }
        
        if selectedPM?.item.paymentType == .QR {
            if meeezaPhoneNumber.isEmpty {
                return false
            }
            
        }
        
        return true
        
    }
 
}
