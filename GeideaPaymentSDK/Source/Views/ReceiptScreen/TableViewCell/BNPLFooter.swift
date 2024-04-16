//
//  BNPLFooter.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 21.03.2022.
//

import UIKit

class BNPLFooter: UIView {
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
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
        
        callLabel.text = "VALU_FOOTER_CALL".localized
    }
}
