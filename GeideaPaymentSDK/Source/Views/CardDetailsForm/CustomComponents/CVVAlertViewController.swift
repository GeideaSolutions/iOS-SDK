//
//  CVVAlertViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/01/2021.
//

import UIKit

class CVVAlertViewController: BaseViewController {
    @IBOutlet weak var alertVCView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerIV: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
  
    @IBOutlet weak var okBtn: RoundedButton!
    
    var config: GDConfigResponse?
    
    init() {
        super.init(nibName: "CVVAlertViewController", bundle: Bundle(for: CVVAlertViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if okBtn != nil {
            setBranding(config: self.config)
        }
    }
    
    func setBranding(config: GDConfigResponse?) {
        okBtn.enabled(isEnabled: true, config: config)
    }
    
     func setupViews() {
        self.headerView.withBorder(isVisible: true, radius: 35, width: 1)
        self.messageLabel.text = "CVV_HINT".localized
        self.okBtn.setTitle("OK_BUTTON".localized, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()

           // Call the roundCorners() func right there.
        self.alertVCView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft], radius: 30)
       }
    
    @IBAction func OKTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
