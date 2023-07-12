//
//  ApplePayViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 03/12/2020.
//

import UIKit
import PassKit

class ApplePayViewController: BaseViewController {
    
    @IBOutlet weak var applePayBtnView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var amount: GDAmount?
    var applePayParams: GDApplePayDetails?
    var applePayCompletion: ((GDOrderResponse?, GDErrorResponse?)->())!
    var config: GDConfigResponse?
    var requiredShippingContactFields:Set<PKContactField>?
    var requiredBillingContactFields:Set<PKContactField>?
    var paymentMethods: [String]?
    var completionAction: ((String?)->())!
    var showButton: Bool = true

    
    init() {
        super.init(nibName: "ApplePayViewController", bundle: Bundle(for: ApplePayViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showButton = applePayParams?.buttonView != nil
        setupApplePay()
    }
    
    private func setupApplePay() {
        
        guard let safeConfig = config else {
            self.applePayBtnView.isHidden = true
            ConfigManager().getConfig(completion: { config, error in
                guard let safeConfig = config  else {
                    self.applePayCompletion(nil, error)
                    return
                }
                self.config = safeConfig
                self.setupApplePay()
            })
            return
        }
        self.applePayBtnView.isHidden = false
        self.loadingIndicator.isHidden = false
        
        if safeConfig.applePay?.isApplePayMobileEnabled ?? false {
            if PKPaymentAuthorizationViewController.canMakePayments() {
                
                if showButton {
                    let applePayButton = PKPaymentButton(paymentButtonType: PKPaymentButtonType.buy, paymentButtonStyle: .black)
                    applePayButton.translatesAutoresizingMaskIntoConstraints = false
                    applePayButton.addTarget(self, action: #selector(self.tapOnApplePay), for: UIControl.Event.touchUpInside)
                    if #available(iOS 12.0, *) {
                        applePayButton.layer.cornerRadius = 20
                    }
                    self.applePayBtnView?.addSubview(applePayButton)
                    applePayButton.heightAnchor.constraint(equalTo: self.applePayBtnView.heightAnchor, constant: 13).isActive = true
                    applePayButton.leadingAnchor.constraint(equalTo: self.applePayBtnView.leadingAnchor, constant: 0).isActive = true
                    applePayButton.trailingAnchor.constraint(equalTo: self.applePayBtnView.trailingAnchor, constant: 0).isActive = true
                    applePayButton.topAnchor.constraint(equalTo: self.applePayBtnView.topAnchor, constant: 0).isActive = true
                } else {
                    tapOnApplePay()
                }
       
            } else {
                self.loadingIndicator.isHidden = true
                self.applePayBtnView.isHidden = true
            }
        } else {
            self.loadingIndicator.isHidden = true
            self.applePayBtnView.isHidden = true
        }
        
    }
    
    @objc func tapOnApplePay() {
        
        guard let currency = amount?.currency, let amount = amount?.amount, let config = self.config, let identifier = applePayParams?.merchantIdentifier, var paymentMethods = config.paymentMethods else {
            return
        }
        
        var networks = [PKPaymentNetwork]()
        
        if let pm = self.paymentMethods {
            paymentMethods = pm
        }
        
        if paymentMethods.contains("visa".lowercased()) {
            networks.append(.visa)
        }
        if paymentMethods.contains("mastercard") {
            networks.append(.masterCard)
        }
        if paymentMethods.contains("mada") {
            if #available(iOS 12.1.1, *) {
                networks.append(.mada)
            } else {
                // Fallback on earlier versions
            }
        }
        if paymentMethods.contains("amex") {
            networks.append(.amex)
        }
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.supportedNetworks = networks
        paymentRequest.countryCode = config.merchantCountryTwoLetterCode ?? "SAR"
        paymentRequest.currencyCode = currency
        paymentRequest.merchantCapabilities = .capability3DS
        if let reqBillingFields = requiredBillingContactFields {
            paymentRequest.requiredBillingContactFields = reqBillingFields
        }
        if let reqShippingFields = requiredShippingContactFields {
            paymentRequest.requiredShippingContactFields = reqShippingFields
        }
    
        paymentRequest.merchantIdentifier = identifier
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: config.merchantName ?? "", amount: NSDecimalNumber(value: amount))]
        paymentRequest.merchantIdentifier = identifier
       
        if let safeDisplayName = applePayParams?.merchantDisplayName, !safeDisplayName.isEmpty {
            paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: safeDisplayName, amount: NSDecimalNumber(value: amount))]
        } else {
            paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: config.merchantName ?? "", amount: NSDecimalNumber(value: amount))]
        }
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        applePayController?.delegate = self
        guard let appplePayVC = applePayController else {
            
            self.applePayCompletion(nil, GDErrorResponse().withErrorCode(error: "ApplePay Authorization failed", code: "-1", detailedResponseMessage: "One of the values submitted are not supported. e.g. Currency must be 3 letters and supported"))
            
            return
        }
        
        self.present(appplePayVC, animated: true, completion: nil)
    }
    
}

extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate {    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        sendOurBeckendToProcessPayment(payment: payment) { orderResonse, error in
            completion(PKPaymentAuthorizationResult(status: error != nil ? .failure : .success, errors: [NSError(domain: "geidea", code: 12, userInfo: nil)]))
            self.applePayCompletion(orderResonse, error)
        }
    }
    
    func sendOurBeckendToProcessPayment(payment: PKPayment,  paymentCompletion: @escaping (GDOrderResponse?, GDErrorResponse?) -> Void) {
        if payment.token.transactionIdentifier == "Simulated Identifier" {
            paymentCompletion(nil, GDErrorResponse().withErrorCode(error: "ApplePay on simulator", code: "-1", detailedResponseMessage: "ApplePay needs a real device wallet for processing the payment"))
        } else {
            ApplePayManager().pay(with: payment, callBackUrl: applePayParams?.callBackUrl, merchantRefId: applePayParams?.merchantRefId, completion: { applePayResponse, error  in
                if error != nil {
                    paymentCompletion(nil, error)
                }  else {
                    guard let response = applePayResponse else {
                        paymentCompletion(nil, error)
                        return
                    }

                    GeideaPaymentAPI.getOrder(with: response.orderId ?? "", completion:{ orderResponse, error in
                        
                        paymentCompletion(orderResponse, error)
                        
                    })
                }
            })
            
        }
    }
        
}
