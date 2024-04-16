//
//  SelectPaymentMethodView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 17.10.2022.
//

import UIKit

class SelectPaymentMethodView: PaymentMethodsView {
    
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var circleView: RadialCircleView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bnplLogo: UIImageView!
    @IBOutlet weak var cardSchemeLogos: UIStackView!
   
    
    var paymentMethods: [String]?
  
    
  override  var paymentMethod: PaymentTypeStatus? {
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
     
        borderView.withBorder(isVisible: true, radius: 8, width: 2,color: UIColor.borderDisabled.cgColor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        borderView.addGestureRecognizer(tap)
        
        

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {

        guard let safeSelected = paymentMethod?.onSelected else {
            return
        }
        selected = true
        safeSelected(paymentMethod)
    }
    

    func setSelected(isSelected: Bool) {
        
        circleView.enabled(enabled: selected, config: paymentMethod?.config)
        if selected {
            borderView.withBorder(isVisible: true, radius: 8, width: 2,color: circleView.enabledColor.cgColor)
        } else {
            borderView.withBorder(isVisible: true, radius: 8, width: 2,color: UIColor.borderDisabled.cgColor)
        }
        
    }
    
    func configurePaymentMethod() {
        
        title.text = paymentMethod?.item.label
        
        if let logos = paymentMethod?.logos {
            for logo in logos {
                cardSchemeLogos.addArrangedSubview(Utils.getImageView(with: logo,width: 27))
            }
        }
    }
    
    
}
