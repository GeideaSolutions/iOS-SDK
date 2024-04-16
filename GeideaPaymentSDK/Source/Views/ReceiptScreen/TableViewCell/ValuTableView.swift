//
//  ValuTableViewCell.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 17.03.2022.
//

import UIKit

class ValuTableView: UIView {

    @IBOutlet weak var callLABEL: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        callLABEL.text = "VALU_FOOTER_CALL".localized
        
        let view = viewFromNibForClass()
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
