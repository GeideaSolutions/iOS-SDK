//
//  DemoLandingPageViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 07/06/23.
//

import UIKit


class DemoLandingPageViewController: UIViewController {
    
    lazy var configuartionView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var configLabel: UILabel = {
        let label = UILabel()
        label.text = "Configuration"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var cardPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Card Payment (Geidea SDK, Merchant PCI-DSS)"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var cardPaymentView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    let viewModel = ConfigurationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }
    
    @objc func cardViewTapped() {
        let viewController = CardPaymentViewController()
        if !viewModel.checkConfiguartionDetailsAvailability() {
            displayAlert(title: "Error", message: "Please set up the configuration!!")
            return
        }
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func configuartionTapped() {
        let rootVC = ConfiguartionViewController()
        rootVC.viewModel =  viewModel
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}


extension DemoLandingPageViewController {
    func setUpUI() {
        view.addSubviews(views: [configuartionView, cardPaymentView])
        
        let width = CGFloat(UIScreen.main.bounds.width - 72)/2
        
        configuartionView.anchors(leading: view.leadingAnchor,
                                  leadingConstants: 24,
                                  heightConstants: width,
                                  widthConstants: width,
                                  centerY: view.centerYAnchor)
        cardPaymentView.anchors(leading: configuartionView.trailingAnchor,
                                leadingConstants: 24,
                                heightConstants: width,
                                widthConstants: width,
                                centerY: view.centerYAnchor)
        
        configuartionView.addSubview(configLabel)
        configLabel.anchors(leading: configuartionView.leadingAnchor,
                            leadingConstants: 16,
                            trailing: configuartionView.trailingAnchor,
                            trailingConstants: -16,
                            centerY: configuartionView.centerYAnchor)
        
        cardPaymentView.addSubview(cardPaymentLabel)
        cardPaymentLabel.anchors(leading: cardPaymentView.leadingAnchor,
                            leadingConstants: 16,
                            trailing: cardPaymentView.trailingAnchor,
                            trailingConstants: -16,
                            centerY: cardPaymentView.centerYAnchor)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(configuartionTapped))
        configuartionView.addGestureRecognizer(tapGesture)
        
        let tapCardGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
        cardPaymentView.addGestureRecognizer(tapCardGesture)
    }
}
