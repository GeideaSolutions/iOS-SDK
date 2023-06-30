//
//  RequestToPayViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 20.07.2021.
//

import UIKit

public struct PhoneConstants {
    static let EGYPT_PREFIX = "002"
}

class RequestToPayViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var errorSnackView: UIView!
    @IBOutlet weak var errorCodeLabel: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var meezaTF: RoundedTextField!
    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var xBtn: UIButton!
    @IBOutlet weak var sendBtn: RoundedButton!
    
    var viewModel: RequestToPayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
    }
    
    func setupViews() {
        meezaTF.delegate = self
        sendBtn.enabled(isEnabled: true, config: viewModel.config)
        cancelBtn.applyBrandingCancel(config: viewModel.config)
        setBranding()
    }
    
    override func localizeStrings() {
        meezaTF.placeholder = viewModel?.requestTextPlaceholder
        titleLabel.text = viewModel?.requestAlertTitle
        sendBtn.setTitle(viewModel?.requestButonTitle, for: .normal)
        cancelBtn.setTitle(viewModel?.cancelButton, for: .normal)
        
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: viewModel.config)
        sendBtn.enabled(isEnabled: true, config: viewModel.config)
    }
    
    func requestToPay() {
        loadingIndicator.isHidden = false
        self.sendBtn.setTitle("", for: .normal)

        if let safeMessage = viewModel?.qrCodeMessage {
            
            let phoneNumber = self.meezaTF.text!
            GeideaPaymentAPI.requestToPay(withQRCodeMessage: safeMessage, phoneNumber: phoneNumber, completion: { response, error  in
                
                if let err = error {
                    self.loadingIndicator.isHidden = true
                    self.dismiss(animated: false, completion: nil)
                    
                    self.viewModel.completion(nil,err)
                    return
                } else {
                    guard let res = response  else {
                        self.loadingIndicator.isHidden = true
                        return
                    }
                    
                    self.loadingIndicator.isHidden = true
                    self.dismiss(animated: false, completion: nil)
                    self.viewModel.completion(res,nil)
                }
                
            })
        }
    }
    
    func showSnackBar(with error: GDErrorResponse) {
        errorCodeLabel.text = error.responseCode.isEmpty ? String(error.status): error.responseCode
        if !error.errors.isEmpty {
            errorMessage.text = "\(error.errors)"
        } else {
            errorMessage.text = error.detailedResponseMessage.isEmpty ? error.responseMessage : error.detailedResponseMessage
        }
        
        self.errorSnackView.isHidden = false
        
        self.errorSnackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.errorSnackView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
            self.errorSnackView.isHidden = true
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
                
                errorSnackView.transform = .identity
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [self]() -> Void in
                    errorSnackView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { [self](finished: Bool) -> Void in
                    errorSnackView.isHidden = true
                })
            } else {
                interactiveTransition.cancel()
            }
            
        case .cancelled, .failed:
            interactiveTransition.cancel()
            
        default:break
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Call the roundCorners() func right there.
        self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft], radius: 30)
    }
    
    init() {
        super.init(nibName: "RequestToPayViewController", bundle: Bundle(for:  RequestToPayViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let error = viewModel.isPhoneNumberValid(phoneNumber: meezaTF.text)
        if let err = error{
            showSnackBar(with: err)
        } else {
            requestToPay()
        }
       
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func xBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RequestToPayViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == meezaTF ) {
            self.viewModel.merchantPhoneNumber = meezaTF.text
            return true
        }
        
        return true
    }
}
