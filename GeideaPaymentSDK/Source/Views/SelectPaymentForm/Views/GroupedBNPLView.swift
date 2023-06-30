//
//  GroupedBNPLView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.10.2022.
//

import UIKit

class GroupedBNPLView: PaymentMethodsView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var circleView: RadialCircleView!
    @IBOutlet weak var logosSV: UIStackView!
    
    override var paymentMethod: PaymentTypeStatus? {
        didSet {
            configurePaymentMethod()
        }
    }
    
    override var selected: Bool  {
        didSet {
            setSelected(isSelected: selected)
        }
    }
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        containerView.addGestureRecognizer(tap)
        
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let safePaymentMethod = paymentMethod {
            selected = true
            safePaymentMethod.onSelected(safePaymentMethod)
        }
       
    }
    
    func setSelected(isSelected: Bool) {
        circleView.enabled(enabled: selected, config: paymentMethod?.config)
    }
    
    func configurePaymentMethod() {
        
        title.text = paymentMethod?.item.label
        
        if let logos = paymentMethod?.logos {
            for logo in logos {
                logosSV.addArrangedSubview(Utils.getImageView(with: logo,width:50))
            }
        }
      
    }
    
}
