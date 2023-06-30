//
//  StepView.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 03.02.2022.
//

import UIKit

protocol BackBtnTapDelegate {
  func didBackBtnTapped()
}

class StepView: UIView {

    @IBOutlet var backBtnGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var stepView: ProgressView!
    @IBOutlet weak var stepCurrent: UILabel!
    @IBOutlet weak var stepTotal: UILabel!
    @IBOutlet weak var stepSeparator: UILabel!
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var slashView: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var view: UIView?
    
    var delegate: BackBtnTapDelegate?
    
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
        self.view = view
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        countView.semanticContentAttribute = .forceLeftToRight
    }
    
    func setupStepView(currentStep: Double = 1, total: Double = 3) {
        
        stepCurrent.text = String(Int(currentStep))
        stepTotal.text = String(Int(total))
        let angle: Double = Double(360 * (currentStep / total))
        stepView.animate(toAngle: Double(angle), duration: 0, completion: nil)
        
        switch GlobalConfig.shared.language {
        case .arabic:
            slashView.text = "\\"
        default:
            slashView.text = "/"
        }
        
        
    }
    
//    func setColor(color: UIColor) {
//        stepView.
//    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        delegate?.didBackBtnTapped()
    }
    
}
