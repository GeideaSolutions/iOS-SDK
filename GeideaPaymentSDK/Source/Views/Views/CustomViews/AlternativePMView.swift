//
//  AlternativePMView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 04.10.2022.
//

import UIKit


enum AlterantiveType {
    case ALL
    case QR
    case VALU
    case SHARY
    case SOUHOOLA
    case NONE

}


class AlternativePMView: UIView {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var showAllView: UILabel!
    @IBOutlet weak var alternativeView: UIView!
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var pmLabel: UILabel!
    
    @IBOutlet weak var showAllLabel: UILabel!
    
    var type: AlterantiveType = .QR

    
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
        
        cellView.withBorder(isVisible: true, radius: 20, width: 1, color: UIColor.gray.cgColor)

    }
    
    func configurePMView() {
        switch type {
        case .QR:
            configureQR()
        case .ALL:
            configureAll()
        case .VALU:
            configureValu()
        case .SOUHOOLA:
            configureSouhoola()
        case .SHARY:
            configureShahry()
        case .NONE:
            break
        }
    }
    
    func configureAll() {
        showAllLabel.text = "PAYMENT_SELECTION_SHOW_ALL".localized
        self.showAllLabel.isHidden = false
        self.alternativeView.isHidden = true
    }
    
    func configureQR() {
        self.showAllLabel.isHidden = true
        self.alternativeView.isHidden = false
        self.pmLabel.text = "PAYMENT_SELECTION_QR_CODE".localized
        
        if let image =  UIImage(named: "meeza_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil) {
            self.logoImage =  Utils.getImageView(with: image,width: 40)
        }
      
    
    }
    
    func configureValu() {
        self.showAllLabel.isHidden = true
        self.alternativeView.isHidden = false
        self.pmLabel.text = "PAYMENT_SELECTION_BNPL".localized
        self.logoImage.image =  UIImage(named: "valU_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
    
    }
    
    func configureShahry() {
        self.showAllLabel.isHidden = true
        self.alternativeView.isHidden = false
        self.pmLabel.text = "PAYMENT_SELECTION_BNPL".localized
        self.logoImage.image =  UIImage(named: "shahry_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
    }
    
    func configureSouhoola() {
        self.showAllLabel.isHidden = true
        self.alternativeView.isHidden = false
        self.pmLabel.text = "PAYMENT_SELECTION_BNPL".localized 
        switch GlobalConfig.shared.language {
        case .arabic:
            self.logoImage.image = UIImage(named: "souhoola_logo", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        default:
            self.logoImage.image = UIImage(named: "souhoola_logo_en", in: Bundle(identifier: "net.geidea.GeideaPaymentSDK"), compatibleWith: nil)
        }
    }
    
}
