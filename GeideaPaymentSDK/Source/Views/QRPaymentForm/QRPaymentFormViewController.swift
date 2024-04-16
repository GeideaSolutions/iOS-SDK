//
//  QRPaymentFormViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 15.07.2021.
//

import UIKit

class QRPaymentFormViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var retryBtn: RoundedButton!
    @IBOutlet weak var expiredView: UIView!
    @IBOutlet weak var qrErrorLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var errorSnackBar: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scandAndPayView: UIView!
    @IBOutlet weak var qrCodeIV: UIImageView!
    
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantNameValue: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorCodeLabel:
    UILabel!
    @IBOutlet weak var scanAndPayLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var openNotifLabel: UILabel!
    @IBOutlet weak var refresLabel: UILabel!
    @IBOutlet weak var notReceivedLabel: UILabel!
    @IBOutlet weak var scanQrLabel: UILabel!
    
    var bnplVC: BNPLViewController!
    
    var viewModel: QRPaymentFormViewModel!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
     
        
    }
    
    func requestToPay() {
        loadingIndicator.isHidden = false
        
        if let safeMessage = viewModel?.qrCodeMessage {
            
            if var phoneNumber = viewModel.customerDetails?.phoneNumber {
                if !phoneNumber.starts(with: "0") {
                    phoneNumber = "0\(phoneNumber)"
                }
                GeideaPaymentAPI.requestToPay(withQRCodeMessage: safeMessage, phoneNumber: phoneNumber, completion: { response, error  in
                    
                    if let err = error {
                        if !err.responseDescription.isEmpty {
                            err.responseMessage = err.responseDescription
                            err.detailedResponseMessage = err.responseDescription
                        }
                        
                        if !self.viewModel.isEmbedded {
                            self.showSnackBar(with: err)
                        } else  {
                            self.bnplVC?.showSnackBar(with: err)
                        }
                        
                    } else {
                        if self.viewModel.isEmbedded {
                            self.viewModel.completion(nil, GDErrorResponse().withErrorCode(error:  "Approved, please wait for payment to complete", code: "0"))
                        }
                        self.showSnackBar(with: GDErrorResponse().withErrorCode(error:  "Approved, please wait for payment to complete", code: "0"))
                    }
                    
                })
            }
        }
        
    }
    
    func getQRImage() {
        timer?.invalidate()
        self.qrCodeView.isHidden = false
        self.expiredView.isHidden = true
        let qrDetails = GDQRDetails(phoneNumber: viewModel.customerDetails?.phoneNumber, email: viewModel.customerDetails?.email, name: viewModel.customerDetails?.name, expiryDate: viewModel.expiryDate)
        GeideaPaymentAPI.getQRImage(with: viewModel.amount,qrDetails: qrDetails, merchantName: viewModel.merchantName ?? "", orderId: viewModel.orderId, callbackUrl: viewModel.callbackUrl, completion:  { response, error  in
            if let err =  error {
                if self.viewModel.showReceipt {
                    self.showReceipt(order: nil, error: err)
                } else {
                    self.viewModel.completion(nil, err)
                    self.dismiss(animated: false, completion: nil)
                }
                return
            } else {
                
                if let image = response?.image?.convertBase64StringToImage() {
                    self.qrCodeIV.image =  UIImage(data: image)
                    
                    self.viewModel.qrCodeMessage = response?.message
                    self.requestToPay()
                    if let paymentIntentId = response?.paymentIntentId {
                        self.viewModel.paymentIntentId = paymentIntentId
                        
                        self.timer = GeideaPaymentAPI.checkPaymentIntentStatus(with: paymentIntentId, atEverySeconds: 3, forMinutes: 15, completion:  { response, error in
                            
                            if let err =  error {
                                
                                if err.responseCode == GDErrorCodes.E028.description {
                                    self.qrErrorLabel.isHidden = false
                                    self.qrErrorLabel.text = err.detailedResponseMessage
                                } else if err.responseCode == GDErrorCodes.E026.description {
                                    self.qrCodeView.isHidden = true
                                    self.expiredView.isHidden = false
                                } else {
                                    if self.viewModel.showReceipt {
                                        self.showReceipt(order: nil, error: err)
                                    } else {
                                        self.viewModel.completion(nil, err)
                                        self.dismiss(animated: false, completion: nil)
                                    }
                                }
                                
                                return
                            } else {
                                guard let orderResponse = response else {
                                    return
                                }
                                
                                if let bnplVM = self.bnplVC?.viewModel {
                                    switch bnplVM.provider {
                                    case.ValU, .Souhoola:
                                        self.viewModel.completion(orderResponse, nil)
                                        if !self.viewModel.isEmbedded{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    case .SHAHRY:
                                        self.viewModel.completion(orderResponse, nil)
                                        if !self.viewModel.isEmbedded{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    case .NONE:
                                        if self.viewModel.showReceipt{
                                            self.showReceipt(order: orderResponse, error: nil)
                                        } else {
                                            self.viewModel.completion(orderResponse, nil)
                                            if !self.viewModel.isEmbedded{
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                } else {
                                    if self.viewModel.showReceipt{
                                        self.showReceipt(order: orderResponse, error: nil)
                                    } else {
                                        self.viewModel.completion(orderResponse, nil)
                                        if !self.viewModel.isEmbedded{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                                
                            }
                        })
                    }
                    
                }
                
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bnpl = self.parent as? BNPLViewController {
            bnplVC = bnpl
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let safeTimer = self.timer {
            safeTimer.invalidate()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calculatePreferredSize()
        
    }
    
    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width, height: view.systemLayoutSizeFitting(UILayoutFittingExpandedSize).height)
        preferredContentSize = contentView.systemLayoutSizeFitting(targetSize)
    }
    
    func setupEmbeddedView() {
        headerView.isHidden = viewModel.isEmbedded
        logoView.isHidden = viewModel.isEmbedded
    }
    
    func showReceipt(order: GDOrderResponse?, error: GDErrorResponse?) {
        let vc = PaymentFactory.makeReceiptViewController()
        
        vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse:
                                                            order, withError: error, receiptFlow: .QR, config: viewModel.config, completion: { response, error in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewModel.completion(order, error)
                if !self.viewModel.isEmbedded{
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        })
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    func setupViews() {
        self.qrCodeView.isHidden = false
        self.expiredView.isHidden = true
        if let qrCode = viewModel.customerDetails?.qrCode {
            if let image = qrCode.convertBase64StringToImage() {
                self.qrCodeIV.image =  UIImage(data: image)
            }
            
            if let paymentIntentId = viewModel.customerDetails?.paymentIntentId {
                self.viewModel.paymentIntentId = paymentIntentId
                
                self.timer = GeideaPaymentAPI.checkPaymentIntentStatus(with: paymentIntentId, atEverySeconds: 3, forMinutes: 15, completion:  { response, error in
                    
                    if let err =  error {
                        
                        if err.responseCode == GDErrorCodes.E028.description {
                            self.qrErrorLabel.isHidden = false
                            self.qrErrorLabel.text = err.detailedResponseMessage
                        } else if err.responseCode == GDErrorCodes.E026.description {
                            self.qrCodeView.isHidden = true
                            self.expiredView.isHidden = false
                        } else {
                            if self.viewModel.showReceipt {
                                self.showReceipt(order: nil, error: err)
                            } else {
                                self.viewModel.completion(nil, err)
                                self.dismiss(animated: false, completion: nil)
                            }
                        }
                        
                        return
                    } else {
                        guard let orderResponse = response else {
                            return
                        }
                        
                        if let bnplVM = self.bnplVC?.viewModel {
                            switch bnplVM.provider {
                            case.ValU, .Souhoola:
                                self.viewModel.completion(orderResponse, nil)
                                if !self.viewModel.isEmbedded{
                                    self.dismiss(animated: true, completion: nil)
                                }
                            case .SHAHRY:
                                self.viewModel.completion(orderResponse, nil)
                                if !self.viewModel.isEmbedded{
                                    self.dismiss(animated: true, completion: nil)
                                }
                            case .NONE:
                                if self.viewModel.showReceipt{
                                    self.showReceipt(order: orderResponse, error: nil)
                                } else {
                                    self.viewModel.completion(orderResponse, nil)
                                    if !self.viewModel.isEmbedded{
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        } else {
                            if self.viewModel.showReceipt{
                                self.showReceipt(order: orderResponse, error: nil)
                            } else {
                                self.viewModel.completion(orderResponse, nil)
                                if !self.viewModel.isEmbedded{
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                        
                    }
                })
            }
        } else {
            getQRImage()
        }
      
        
        setBranding()
        
        self.loadingIndicator.startAnimating()
        
        errorSnackBar.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        amountLabel.setSubscriptCurrencyText(forAmount: viewModel.amount.amount)
        
        if viewModel.hasSafeArea {
            headerHeightConstraint.constant = 130
        } else {
            headerHeightConstraint.constant = 110
        }
        
        self.amountLabel.text = String(viewModel.amount.amount)
        self.currencyLabel.text = viewModel.amount.currency
        
        var merchantName = viewModel.config?.merchantName
        if GlobalConfig.shared.language == .arabic {
            merchantName = viewModel.config?.merchantNameAr
        }
        self.merchantNameValue.text = merchantName
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerImageView.addBottomRoundedEdgeIV(desiredCurve: 1.5)
        }
        setupEmbeddedView()
        
        localizeStrings()
    }
    
    func setBranding() {
        
        cancelBtn.applyBrandingCancel(config: viewModel.config)
        if let headerColor = viewModel.config?.branding?.headerColor {
            headerImageView.backgroundColor = UIColor(hex: headerColor)
            loadingIndicator.assignColor(UIColor(hex: headerColor) ?? UIColor.orangeHighlightColor)
        }
        
        if let logo = viewModel.config?.branding?.logoPublicUrl {
            logoIV.loadFrom(URLAddress: logo)
        }
        
        //        if let backgroundColor = viewModel.config?.branding?.backgroundColor {
        //            contentView.backgroundColor = UIColor(hex: backgroundColor)
        //        }
    }
    
    override func localizeStrings() {
        
        scanAndPayLabel.text = viewModel.mobileWalletTitle
        merchantName.text = viewModel.merchantNameTitle
        
        cancelBtn.setTitle(viewModel.cancelButton, for: .normal)
        waitingLabel.text = viewModel.waitingTitle
        openNotifLabel.text = viewModel.openNotifTitle
        refresLabel.text = viewModel.refreshTitle
        notReceivedLabel.text = viewModel.noNotifTitle
        scanQrLabel.text = viewModel.qrScanTitle
        
        
        
        //        requestPayDesctiption.text = viewModel.requestToPayDetails
        //        requestPayBtn.setTitle(viewModel.requestToPayButton, for: .normal)
        
    }
    
    func showSnackBar(with error: GDErrorResponse) {
        errorCodeLabel.text = error.responseCode.isEmpty ? String(error.status): error.responseCode
        if !error.errors.isEmpty {
            errorLabel.text = "\(error.errors)"
        } else if !error.responseDescription.isEmpty {
            errorLabel.text = error.responseDescription
        } else  {
            errorLabel.text = error.detailedResponseMessage.isEmpty ? error.responseMessage : error.detailedResponseMessage
        }
        
        self.errorSnackBar.isHidden = false
        
        self.errorSnackBar.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.errorSnackBar.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            self.errorSnackBar.isHidden = true
        }
    }
    
    @objc func handleDismiss(gesture: UIPanGestureRecognizer) {
        
        let interactiveTransition = UIPercentDrivenInteractiveTransition()
        let percent = max(gesture.translation(in: view).x, 0) / view.frame.width
        switch gesture.state {
            
        case .began:
            break
            
        case .changed:
            interactiveTransition.update(percent)
            
        case .ended:
            let velocity = gesture.velocity(in: view).x
            
            // Continue if drag more than 50% of screen width or velocity is higher than 1000
            if percent > 0.5 || velocity > 1000 {
                interactiveTransition.finish()
                
                errorSnackBar.transform = .identity
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [self]() -> Void in
                    errorSnackBar.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { [self](finished: Bool) -> Void in
                    errorSnackBar.isHidden = true
                })
            } else {
                interactiveTransition.cancel()
            }
            
        case .cancelled, .failed:
            interactiveTransition.cancel()
            
        default:break
            
        }
    }
    
    @IBAction func retryTapped(_ sender: Any) {
        getQRImage()
    }
    
    @IBAction func requestToPayTapped(_ sender: Any) {
        
        let vc = PaymentFactory.makeRequestToPayViewController()
        if let message = viewModel.qrCodeMessage {
            let vm = PaymentFactory.makeRequestToPayViewModel(withQRCodeMessage: message, config: viewModel.config, orderId: viewModel.orderId, completion: {response, error  in
                
                if let err =  error {
                    self.showSnackBar(with: err)
                    return
                } else {
                    if self.viewModel.isEmbedded {
                        self.viewModel.completion(nil, GDErrorResponse().withErrorCode(error:  "Approved, please wait for payment to complete", code: "0"))
                    }
                    self.showSnackBar(with: GDErrorResponse().withErrorCode(error:  "Approved, please wait for payment to complete", code: "0"))
                }
            })
            
            vc.viewModel = vm
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            present(vc, animated: true)
        }
        
        
    }
    
    func displayAlert(title: String, message: String) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true)
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        if let safeTimer = self.timer {
            safeTimer.invalidate()
        }
        displaySimpleCancelAlert()
        
    }
    
    func displaySimpleCancelAlert() {
        let vc = PaymentFactory.makeCancelAlertViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        vc.cancelDelegate = self
        vc.viewModel = viewModel
        vc.config = viewModel.config
        self.present(vc, animated: true)
        
    }
    
    
    init() {
        super.init(nibName: "QRPaymentFormViewController", bundle: Bundle(for:  QRPaymentFormViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias QRCancelTappedDelegate = QRPaymentFormViewController
extension QRCancelTappedDelegate:  CancelTapDelegate {
    
    func didOkBtnTapped(error: GDErrorResponse?) {
        
        if self.viewModel.isEmbedded {
            if let navController = self.navigationController {
                
                navController.popToRootViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else{
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                if let orderId = self?.viewModel.orderId, !orderId.isEmpty {
                    logEvent("Cancelled By User \(orderId)")
                    
                    if self?.viewModel.showReceipt ?? false  {
                        self?.showReceipt(order: nil, error: error)
                    } else {
                        self?.viewModel.completion(nil, error)
                        
                        if let navController = self?.navigationController {
                            
                            navController.popViewController(animated: true)
                            self?.dismiss(animated: true, completion: nil)
                        } else{
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    self?.viewModel.completion(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "Cancelled by user", orderId: ""))
                    self?.dismiss(animated: false, completion: nil)
                }
                
            }
        }
        
      
    }
    
    
}

