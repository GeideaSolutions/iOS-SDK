//
//  CancelAlertViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 27.09.2022.
//

import UIKit

protocol CancelTapDelegate {
    func didOkBtnTapped(error: GDErrorResponse?)
}

class CancelAlertViewController: BaseViewController {
 
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertMessage: UILabel!
     
    @IBOutlet weak var okBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    var cancelDelegate: CancelTapDelegate?
    var viewModel: ViewModel?
    var config: GDConfigResponse?
    
    
    init() {
        super.init(nibName: "CancelAlertViewController", bundle: Bundle(for: CancelAlertViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    override func localizeStrings() {
        okBtn.setTitle("OK_BUTTON".localized, for: .normal)
        cancelBtn.setTitle("CANCEL_BUTTON".localized, for: .normal)
        alertMessage.text = "CANCEL_PAYMENT".localized
    }
    func setupViews() {
        localizeStrings()
   }
    
    override func viewWillAppear(_ animated: Bool) {
        if okBtn != nil {
            setBranding(config: self.config)
        }
    }
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()

           // Call the roundCorners() func right there.
        self.alertView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft], radius: 30)
       }
    
    func setBranding(config: GDConfigResponse?) {
//        if let accessTextColor = config?.branding?.accentTextColor {
            okBtn.enabled(isEnabled: true, config: config)
            cancelBtn.applyBrandingCancel(config: config)
//        }
    }

  
    @IBAction func okBtnTapped(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            if let orderId = self?.viewModel?.orderId, !orderId.isEmpty {
                logEvent("Cancelled By User \(orderId)")
                self?.okBtn.showLoading()
                let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
                CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                    self?.okBtn.hideLoading()
                    self?.cancelDelegate?.didOkBtnTapped( error: error)
                    self?.dismiss(animated: true)
                })
            } else {
                
                self?.cancelDelegate?.didOkBtnTapped( error: GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "Cancelled by user", orderId: ""))
                self?.dismiss(animated: true)
                
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
