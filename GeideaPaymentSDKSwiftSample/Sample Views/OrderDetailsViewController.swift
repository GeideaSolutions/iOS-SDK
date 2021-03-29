//
//  SuccessViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 03/11/2020.
//

import UIKit
import GeideaPaymentSDK

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var action: ((GDOrdersFilter)->())?
    var orderId: String?
    var callbackURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        getOrder()
        refundButton.isHidden = true
    }
    
    func getOrder() {
        
        guard  let order = orderId else {
            return
        }
        
        loadingView.isHidden = false
        GeideaPaymentAPI.getOrder(with: order, completion:{ [self] (response, error) in
            loadingView.isHidden = true
            if let err = error {
                if err.errors.isEmpty {
                    var message = ""
                    if err.responseCode.isEmpty {
                        message = "\n responseMessage: \(err.responseMessage)"
                        
                    } else if !err.orderId.isEmpty {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                    } else {
                        message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                    }
                    self.displayAlert(title: err.title,  message: message, isCancel: false)
                    
                } else {
                    self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)", isCancel: false)
                }
            } else if let safeResponse = response {
                self.orderId  = safeResponse.orderId
                refundButton.isHidden = false
                if safeResponse.status == "InProgress" {
                    refundButton.setTitle("Cancel", for: .normal)
                } else {
                    refundButton.setTitle("Refund", for: .normal)
                }
                refundButton.isHidden = false
                self.callbackURL   = safeResponse.callbackUrl
                textView.text = GeideaPaymentAPI.getModelString(order: safeResponse)
            }
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.setContentOffset(.zero, animated: false)
    }

    @IBAction func okTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func operationTapped(_ sender: Any) {
        guard  let order = orderId else {
            return
        }
        
        if refundButton.title(for: .normal) == "Cancel" {
            GeideaPaymentAPI.cancel(with: order, callbackUrl: callbackURL, navController: self, completion:{ [self] response, error in
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message, isCancel: true)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)", isCancel: true)
                    }
                }
            })
        } else {
            GeideaPaymentAPI.refund(with: order, callbackUrl: callbackURL, navController: self, completion:{ [self] response, error in
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title,  message: message, isCancel: false)
                        
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)", isCancel: false)
                    }
                } else {
                    guard let orderResponse = response else {
                        return
                    }
                    self.displayAlert(title: "SUCCES",  message: orderResponse.status ?? "", isCancel: false)
                    
                    self.textView.text = GeideaPaymentAPI.getModelString(order: orderResponse)

                    
                }
            })
        }
        
    }
    
    func displayAlert(title: String, message: String, isCancel: Bool) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
            if isCancel {
                let filter = GDOrdersFilter()
                filter.DetailedStatuses = ["Cancelled"]
                if let safeAction = self.action  {
                    safeAction(filter)
                }
                self.dismiss(animated: true, completion: nil)
            }
           
        }))
        
        self.present(alert, animated: true)
        
    }
}
