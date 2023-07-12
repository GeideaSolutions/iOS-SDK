//
//  ConfiguartionViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 07/06/23.
//

import UIKit


class ConfiguartionViewController: UIViewController {
    
    lazy var configLabel: UILabel = {
        let label = UILabel()
        label.text = "Environment"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        UIScrollView()
    }()
    
    lazy var segment: UISegmentedControl = {
        var segmentList: [String] = ["Prod","Test"]
        let segment = UISegmentedControl(items: segmentList)
        segment.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            segment.selectedSegmentTintColor = .systemBlue
        } else {
            // Fallback on earlier versions
        }
        segment.selectedSegmentIndex = 1
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var credentialsView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var merchantKey: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Merchant Key",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var passwordKey: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "API Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var languageView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        return view
    }()
    
    var radioButtonArray = [RadioButton]()
    var languageArray = [UIButton]()
    var firstRadioButton = RadioButton.init()
    var secondRadioButton = RadioButton.init()
    lazy var paymentDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Details"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var currency: UILabel = {
        let label = UILabel()
        label.text = "Currency"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var currencyTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Add ISO Alpha-3 Code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var endPointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Endpoints"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var callBackUrlTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Call back URL",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var returnUrlTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Return URL",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    
    lazy var paymentOptionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Options"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var checkBoxArray = [CheckBox]()
    var paymentOptionsArray = [UIButton]()
    let firstCheckBox = CheckBox(tapGestureEnable: true)
    let secondCheckBox = CheckBox(tapGestureEnable: true)
    let thirdCheckBox = CheckBox(tapGestureEnable: true)
    
    lazy var merchantReferenceTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Merchant Reference ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, .paragraphStyle: paragraphStyle]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var initiatedTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Intiated By",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.backgroundColor = .lightGray
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var customerDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Customer Details"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var customerEmailTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Customer Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var billingAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Billing Address"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var billingStreetNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Street Name and Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var billingCityNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "City",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var billingPostCodeTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Post Code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var billingCountryTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Country",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    let billingCheckbox = CheckBox(tapGestureEnable: true)
    var sameBillingAndShippingTitle: UIButton!
    var inputs: [UITextField]!
    
    lazy var shippingAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping Address"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var shippingStreetNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Street Name and Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var shippingCityNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "City",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var shippingPostCodeTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Post Code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var shippingCountryTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "Country",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var saveConfigButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(saveConfigButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var viewModel: ConfigurationPresentable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Configuration"
        setupUI()
        scrollView.keyboardDismissMode = .onDrag
        inputs = [merchantKey, passwordKey, currencyTextField, callBackUrlTextField, returnUrlTextField, merchantReferenceTextField, customerEmailTextField, billingStreetNameTextField, billingCityNameTextField, billingPostCodeTextField, billingCountryTextField, shippingStreetNameTextField, shippingCityNameTextField, shippingPostCodeTextField, shippingCountryTextField]
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        setupDemoData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}
