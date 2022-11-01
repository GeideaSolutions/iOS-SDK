//
//  PMView.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Eugen Vidolman on 24.10.2022.
//

import UIKit

class PMView: UIView {
    
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var paymentOptions: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        let view = viewFromNibForClass()
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
}
