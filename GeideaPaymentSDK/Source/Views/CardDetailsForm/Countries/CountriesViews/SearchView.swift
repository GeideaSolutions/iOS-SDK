//
//  SearchView.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/01/2021.
//

import Foundation
import UIKit

class SearchView: UIView {

    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    func setupView() {
        let view = viewFromNibForClass()
        
        addSubview(view)
    }
    
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
}
