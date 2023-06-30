//
//  PaymentViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 20/10/2020.
//

import UIKit
import PassKit
import WebKit

class PaymentViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loadingIndicator: UIView!
    @IBOutlet weak var loadigStatus: UILabel!
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var viewModel: PayViewModel!
    
    init() {
        super.init(nibName: "PaymentViewController", bundle: Bundle(for: PaymentViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupComponents() {
        viewModel.datasourceRefreshAction = refreshComponents
        viewModel.receiptAction  = { response, err in
            self.showReceipt(order: response as? GDOrderResponse, error: err)
        }
        if let vm = viewModel as? PaymentViewModel {
            vm.loadHiddenWebViewAction = loadHiddenWebView
        }
        
        if let vm = viewModel as? PaymentTokenViewModel {
            vm.loadHiddenWebViewAction = loadHiddenWebView
        }
      
        refreshComponents()
    }
    
    private func refreshComponents() {
        localizeStrings()
        if let vm = viewModel as? PaymentViewModel {
            webViewContainer.isHidden = !vm.shouldShowWebView
        } else if let vm = viewModel as? PaymentTokenViewModel {
            webViewContainer.isHidden = !vm.shouldShowWebView
        } else{
            webViewContainer.isHidden = true
        }
        
        
        
        headerView.isHidden = viewModel.isNavController
        headerViewHeightConstant.constant = viewModel.headerViewConstant
        
    }
    
    func showReceipt(order: GDOrderResponse?, error: GDErrorResponse?) {
        let vc = PaymentFactory.makeReceiptViewController()

        vc.viewModel = PaymentFactory.makeReceiptViewModel(withOrderResponse:
                                                            order, withError: error, receiptFlow: .CARD, config: viewModel.config, completion: { response, error in
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  [weak self] in
                    GeideaPaymentAPI.shared.returnAction(order, error)
                    self?.dismiss(animated: true, completion: nil)
                }
           
        })
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func loadHiddenWebView() {
        let configuration = WKWebViewConfiguration()
        let webV  = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), configuration: configuration)
        
        if let vm = viewModel as? PaymentViewModel {
            webV.loadHTMLString(vm.redirectHtml ?? "", baseURL: nil)
            view.addSubview(webV)
            
            if vm.gatewayDecision  != "ContinueToPayWithNotEnrolledCard" {
                vm.authenticatePayer()
            } else {
                vm.pay(with: vm.authenticateParams, threeDSecureId: vm.threedSecureId, orderId: vm.orderId)
            }
            
        }

        if let vm = viewModel as? PaymentTokenViewModel {
            
            webV.loadHTMLString(vm.redirectHtml ?? "", baseURL: nil)
        
            view.addSubview(webV)

            if vm.gatewayDecision  != "ContinueToPayWithNotEnrolledCard" {
                vm.authenticatePayer()
            } else {
                vm.pay(with: vm.payTokenParams, threeDSecureId: vm.threedSecureId, orderId: vm.orderId)
            }
        }
    }
    
    
    override func localizeStrings() {
        title = viewModel.screenTitle
        titleLabel.text = viewModel.screenTitle
        loadigStatus.text = viewModel.screenTitle
    }
    
    func loadWebView(vc: WebviewViewController) {
        embed(vc, inView: webViewContainer)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        if let orderId = viewModel.orderId, let action = viewModel.dismissAction {
            action(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "PAYMENT_CANCELLED".localized, orderId: orderId))
            
        } else if let orderId = viewModel.orderId  {
            let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
            CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
            
            })
            
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "PAYMENT_CANCELLED".localized, orderId: orderId))
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
