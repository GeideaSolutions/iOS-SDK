//
//  CardPaymentViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 13/06/23.
//

import UIKit

class CardPaymentViewController: UIViewController {
    
    lazy var paymentDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Details"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var amount: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the amount",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var currency: UILabel = {
        let label = UILabel()
        label.text = "Currency"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var currencyValueLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.selectedCurrency
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    var radioButtonArray = [RadioButton]()
    var sdkArray = [UIButton]()
    var firstRadioButton = RadioButton.init()
    var secondRadioButton = RadioButton.init()
    var heightConstraint: NSLayoutConstraint?
    lazy var cardDetailsView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var cardNumberTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Card Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var expiryMonthTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Exp. Month",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var expiryYearTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Exp. year",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var cvvTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "CVV/CAVV",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var cardHolderNameField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Card Holder Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pay", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var viewModel: ConfigurationPresentable!
    var orderId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Card Payment"
        setupUI()
        amountTextField.text = "1100"
        viewModel.saveAmount(amount: amountTextField.text)
        bindData()
    }
    
}
