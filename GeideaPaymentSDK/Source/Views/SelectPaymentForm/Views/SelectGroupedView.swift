//
//  SelectGroupedView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 18.10.2022.
//

import UIKit

class SelectGroupedView: PaymentMethodsView {
    
  
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logosView: UIStackView!
    @IBOutlet weak var expandIV: UIImageView!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var borderView: UIView!

    @IBOutlet weak var bnplsSV: UIStackView!
    @IBOutlet weak var bnplsView: UIView!
    
    private var paymentMethodsViews = [PaymentMethodsView]()
    
    var expanded: Bool = false {
        didSet {
            
            if expanded {
                expandIV.image = UIImage(named: "expandUP", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            } else {
                expandIV.image = UIImage(named: "expandDown", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
            }
        }
    }
    
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
    
    func setSelected(isSelected: Bool) {
        
        if !selected {
            for item in paymentMethodsViews {
                
                item.selected = false
            }
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
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
       expanded = !expanded
       bnplsView.isHidden = !expanded
    }
    
    func configurePaymentMethod() {
        bnplsView.isHidden = !expanded
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        headerView.addGestureRecognizer(tap)
        
        title.text = paymentMethod?.item.label
        
        if let logos = paymentMethod?.logos {
            for logo in logos {
                logosView.addArrangedSubview(Utils.getImageView(with: logo,width: 35))
            }
        }
        
        guard let items = paymentMethod?.groupedItems else {
           return
        }
        

        
        for item in items {
            let pm = GroupedBNPLView()
            pm.paymentMethod = item
            item.onSelected = { paymentType in
                
                if let safePM = self.paymentMethod {
                    safePM.onSelected(paymentType)
                    for pmView in self.paymentMethodsViews {
                        if pmView.paymentMethod != paymentType {
                            pmView.selected = false
                        } 
                    }
                }
            }
            
            bnplsSV.addArrangedSubview(pm)
            paymentMethodsViews.append(pm)
        }
        
    }

}
