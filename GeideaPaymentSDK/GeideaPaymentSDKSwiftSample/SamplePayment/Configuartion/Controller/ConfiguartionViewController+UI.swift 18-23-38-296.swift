//
//  ConfiguartionViewController+UI.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 12/06/23.
//

import UIKit

extension ConfiguartionViewController {
    
    func setupUI() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(configLabel)
        configLabel.anchors(top: guide.topAnchor,
                            topConstants: 24,
                            centerX: view.centerXAnchor)
        setupSegment()
        setupScrollView()
        setupCredentialsView()
        setupLanguageView()
        addPaymentDetailsView()
        setupEndpointsView()
        setupPaymentOptions()
        setUpMerchantReferenceID()
        setUPinitiatedByTextField()
        setUpCustomerDetails()
        setUpBillingDetails()
        setupCheckBoxForBilling()
        setUpShippingDetails()
        setUpSaveConfigButton()
    }
    
    func setupSegment() {
        view.addSubview(segment)
        segment.anchors(top: configLabel.bottomAnchor,
                        topConstants: 16,
                        leading: view.leadingAnchor,
                        leadingConstants: 16,
                        trailing: view.trailingAnchor,
                        trailingConstants: -16,
                        heightConstants: 32)
    }
    
    func setupScrollView() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.anchors(top: segment.bottomAnchor,
                           leading: guide.leadingAnchor,
                           bottom: guide.bottomAnchor,
                           trailing: guide.trailingAnchor)
    }
    
    func setupCredentialsView() {
        scrollView.addSubview(credentialsView)
        credentialsView.anchors(top: scrollView.topAnchor,
                                topConstants: 16,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                leadingConstants: 16,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                trailingConstants: -16,
                                heightConstants: 164)
        
        credentialsView.addSubviews(views: [merchantKey, passwordKey, saveButton, clearButton])
        merchantKey.anchors(top: credentialsView.topAnchor,
                            topConstants: 16,
                            leading: credentialsView.leadingAnchor,
                            leadingConstants: 16,
                            trailing: credentialsView.trailingAnchor,
                            trailingConstants: -16,
                            heightConstants: 34)
        passwordKey.anchors(top: merchantKey.bottomAnchor,
                            topConstants: 16,
                            leading: credentialsView.leadingAnchor,
                            leadingConstants: 16,
                            trailing: credentialsView.trailingAnchor,
                            trailingConstants: -16,
                            heightConstants: 34)
        let buttonWidth = (UIScreen.main.bounds.width - 72) / 2
        saveButton.anchors(top: passwordKey.bottomAnchor,
                           topConstants: 16,
                           leading: passwordKey.leadingAnchor,
                           widthConstants: buttonWidth)
        
        clearButton.anchors(top: passwordKey.bottomAnchor,
                            topConstants: 16,
                            trailing: passwordKey.trailingAnchor,
                            widthConstants: buttonWidth)
    }
    
    func setupLanguageView() {
        scrollView.addSubview(languageLabel)
        
        languageLabel.anchors(top: credentialsView.bottomAnchor,
                              topConstants: 8,
                              centerX: scrollView.centerXAnchor)
        
        var tapOneGesture = UITapGestureRecognizer()
        var tapTwoGesture = UITapGestureRecognizer()
        
        var firstLabelTitle : UIButton!
        var seconTitleLabel : UIButton!
        
        scrollView.addSubview(firstRadioButton)
        firstRadioButton.selected = true
        firstRadioButton.anchors(top: languageLabel.bottomAnchor,
                                 topConstants: 16,
                                 leading: view.safeAreaLayoutGuide.leadingAnchor,
                                 leadingConstants: 24,
                                 heightConstants: 12,
                                 widthConstants: 12)
        firstRadioButton.isUserInteractionEnabled = true
        firstRadioButton.layoutIfNeeded()
        radioButtonArray.append(firstRadioButton)
        tapOneGesture = UITapGestureRecognizer.init(target: self, action: #selector(buttonOneTapped(sender:)))
        firstRadioButton.addGestureRecognizer(tapOneGesture)
        
        firstLabelTitle = UIButton()
        scrollView.addSubview(firstLabelTitle)
        firstLabelTitle.setTitleColor(.black, for: .normal)
        firstLabelTitle.setTitle("English",for: .normal)
        firstLabelTitle.titleLabel?.font =  UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        firstLabelTitle.anchors(leading: firstRadioButton.trailingAnchor,
                                leadingConstants: 16,
                                centerY: firstRadioButton.centerYAnchor)
        firstLabelTitle.layoutIfNeeded()
        languageArray.append(firstLabelTitle)
        firstLabelTitle.addTarget(self, action: #selector(labelTapped(sender:)), for: .touchUpInside)
        firstLabelTitle.adjustsImageWhenHighlighted = false
        
        
        tapTwoGesture = UITapGestureRecognizer.init(target: self, action: #selector(buttonOneTapped(sender:)))
        
        scrollView.addSubview(secondRadioButton)
        secondRadioButton.selected = false
        
        secondRadioButton.anchors(top: firstRadioButton.bottomAnchor,
                                  topConstants: 16,
                                  leading: view.safeAreaLayoutGuide.leadingAnchor,
                                  leadingConstants: 24,
                                  heightConstants: 12,
                                  widthConstants: 12)
        secondRadioButton.isUserInteractionEnabled = true
        secondRadioButton.layoutIfNeeded()
        radioButtonArray.append(secondRadioButton)
        secondRadioButton.addGestureRecognizer(tapTwoGesture)
        
        seconTitleLabel = UIButton()
        scrollView.addSubview(seconTitleLabel)
        seconTitleLabel.backgroundColor = .white
        seconTitleLabel.setTitleColor(.black, for: .normal)
        seconTitleLabel.setTitle("Arabic",for: .normal)
        seconTitleLabel.titleLabel?.font =  UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        seconTitleLabel.anchors(leading: secondRadioButton.trailingAnchor,
                                leadingConstants: 16,
                                centerY: secondRadioButton.centerYAnchor)
        seconTitleLabel.layoutIfNeeded()
        languageArray.append(seconTitleLabel)
        seconTitleLabel.addTarget(self, action: #selector(labelTapped(sender:)), for: .touchUpInside)
        seconTitleLabel.adjustsImageWhenHighlighted = false
    }
    
    
    func addPaymentDetailsView() {
        scrollView.addSubviews(views: [paymentDetailsLabel, currency, currencyTextField])
        
        paymentDetailsLabel.anchors(top: secondRadioButton.bottomAnchor,
                                    topConstants: 16,
                                    centerX: scrollView.centerXAnchor)
        currency.anchors(top: paymentDetailsLabel.topAnchor,
                         topConstants: 38,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         leadingConstants: 24)
        currencyTextField.anchors(top: paymentDetailsLabel.bottomAnchor,
                                  topConstants: 16,
                                  leading: currency.trailingAnchor,
                                  leadingConstants: 24,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                  trailingConstants: -24,
                                  heightConstants: 34)
    }
    
    func setupEndpointsView() {
        scrollView.addSubviews(views: [endPointsLabel, callBackUrlTextField, returnUrlTextField])
        
        endPointsLabel.anchors(top: currencyTextField.bottomAnchor,
                               topConstants: 16,
                               centerX: scrollView.centerXAnchor)
        callBackUrlTextField.anchors(top: endPointsLabel.bottomAnchor,
                                     topConstants: 16,
                                     leading: view.safeAreaLayoutGuide.leadingAnchor,
                                     leadingConstants: 24,
                                     trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                     trailingConstants: -24,
                                     heightConstants: 34)
        returnUrlTextField.anchors(top: callBackUrlTextField.bottomAnchor,
                                   topConstants: 8,
                                   leading: view.safeAreaLayoutGuide.leadingAnchor,
                                   leadingConstants: 24,
                                   trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                   trailingConstants: -24,
                                   heightConstants: 34)
        
    }
    
    func setupPaymentOptions() {
        scrollView.addSubview(paymentOptionsLabel)
        
        paymentOptionsLabel.anchors(top: returnUrlTextField.bottomAnchor,
                                    topConstants: 16,
                                    centerX: scrollView.centerXAnchor)
        
        var tapOneGesture = UITapGestureRecognizer()
        var tapTwoGesture = UITapGestureRecognizer()
        var tapThreeGesture = UITapGestureRecognizer()
        var tapFourGesture = UITapGestureRecognizer()
        var tapFiveGesture = UITapGestureRecognizer()
        
        var firstLabelTitle : UIButton!
        var seconTitleLabel : UIButton!
        var thirdLabelTitle : UIButton!
        var fourTitleLabel : UIButton!
        var fifthLabelTitle : UIButton!
        
        scrollView.addSubview(firstCheckBox)
        firstCheckBox.anchors(top: paymentOptionsLabel.bottomAnchor,
                              topConstants: 16,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              leadingConstants: 24,
                              heightConstants: 16,
                              widthConstants: 16)
        firstCheckBox.selected = viewModel.showReceipt ?? false
        firstCheckBox.isUserInteractionEnabled = true
        checkBoxArray.append(firstCheckBox)
        tapOneGesture = UITapGestureRecognizer.init(target: self, action: #selector(checkBoxTapped(sender:)))
        firstCheckBox.addGestureRecognizer(tapOneGesture)
        
        firstLabelTitle = UIButton()
        firstLabelTitle.isSelected = false
        scrollView.addSubview(firstLabelTitle)
        firstLabelTitle.setTitleColor(.black, for: .normal)
        firstLabelTitle.setTitle("Show Receipt",for: .normal)
        firstLabelTitle.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        firstLabelTitle.anchors(leading: firstCheckBox.trailingAnchor,
                                leadingConstants: 16,
                                centerY: firstCheckBox.centerYAnchor)
        firstLabelTitle.layoutIfNeeded()
        paymentOptionsArray.append(firstLabelTitle)
        firstLabelTitle.addTarget(self, action: #selector(paymentlabelTapped(sender:)), for: .touchUpInside)
        firstLabelTitle.adjustsImageWhenHighlighted = false
        
        tapTwoGesture = UITapGestureRecognizer.init(target: self, action: #selector(checkBoxTapped(sender:)))
        
        scrollView.addSubview(secondCheckBox)
        secondCheckBox.anchors(leading: firstLabelTitle.trailingAnchor,
                               leadingConstants: 30,
                               heightConstants: 16,
                               widthConstants: 16,
                               centerY: firstCheckBox.centerYAnchor)
        secondCheckBox.selected = viewModel.showEmail ?? false
        secondCheckBox.isUserInteractionEnabled = true
        checkBoxArray.append(secondCheckBox)
        secondCheckBox.addGestureRecognizer(tapTwoGesture)
        
        seconTitleLabel = UIButton()
        seconTitleLabel.isSelected = false
        scrollView.addSubview(seconTitleLabel)
        seconTitleLabel.setTitleColor(.black, for: .normal)
        seconTitleLabel.setTitle("Show Email",for: .normal)
        seconTitleLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        seconTitleLabel.anchors(leading: secondCheckBox.trailingAnchor,
                                leadingConstants: 16,
                                centerY: secondCheckBox.centerYAnchor)
        seconTitleLabel.layoutIfNeeded()
        paymentOptionsArray.append(seconTitleLabel)
        seconTitleLabel.addTarget(self, action: #selector(paymentlabelTapped(sender:)), for: .touchUpInside)
        seconTitleLabel.adjustsImageWhenHighlighted = false
        
        scrollView.addSubview(thirdCheckBox)
        thirdCheckBox.anchors(top: firstCheckBox.bottomAnchor,
                              topConstants: 24,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              leadingConstants: 24,
                              heightConstants: 16,
                              widthConstants: 16)
        thirdCheckBox.selected = viewModel.showAddress ?? false
        thirdCheckBox.isUserInteractionEnabled = true
        checkBoxArray.append(thirdCheckBox)
        tapThreeGesture = UITapGestureRecognizer.init(target: self, action: #selector(checkBoxTapped(sender:)))
        thirdCheckBox.addGestureRecognizer(tapThreeGesture)
        
        thirdLabelTitle = UIButton()
        thirdLabelTitle.isSelected = false
        scrollView.addSubview(thirdLabelTitle)
        thirdLabelTitle.setTitleColor(.black, for: .normal)
        thirdLabelTitle.setTitle("Show Address",for: .normal)
        thirdLabelTitle.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        thirdLabelTitle.anchors(leading: thirdCheckBox.trailingAnchor,
                                leadingConstants: 16,
                                centerY: thirdCheckBox.centerYAnchor)
        thirdLabelTitle.layoutIfNeeded()
        paymentOptionsArray.append(thirdLabelTitle)
        thirdLabelTitle.addTarget(self, action: #selector(paymentlabelTapped(sender:)), for: .touchUpInside)
        thirdLabelTitle.adjustsImageWhenHighlighted = false
    }
    
    func setUpMerchantReferenceID() {
        scrollView.addSubview(merchantReferenceTextField)
        merchantReferenceTextField.anchors(top: thirdCheckBox.bottomAnchor,
                                   topConstants: 16,
                                   leading: view.safeAreaLayoutGuide.leadingAnchor,
                                   leadingConstants: 24,
                                   trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                   trailingConstants: -24,
                                   heightConstants: 34)
    }
    
    func setUPinitiatedByTextField() {
        scrollView.addSubview(initiatedTextField)
        var tapOneGesture = UITapGestureRecognizer()
        tapOneGesture = UITapGestureRecognizer.init(target: self, action: #selector(initiatedBy(sender:)))
        initiatedTextField.addGestureRecognizer(tapOneGesture)
        
        initiatedTextField.anchors(top: merchantReferenceTextField.bottomAnchor,
                                   topConstants: 16,
                                   leading: view.safeAreaLayoutGuide.leadingAnchor,
                                   leadingConstants: 24,
                                   trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                   trailingConstants: -24,
                                   heightConstants: 34)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gdArrow")
        initiatedTextField.addSubview(imageView)
        imageView.anchors(trailing: initiatedTextField.trailingAnchor,
                          trailingConstants: -8,
                          heightConstants: 12,
                          widthConstants: 12,
                          centerY: initiatedTextField.centerYAnchor)
    }
    
    func setUpCustomerDetails() {
        scrollView.addSubviews(views: [customerDetailsLabel,
                                       customerEmailTextField])
        customerDetailsLabel.anchors(top: initiatedTextField.bottomAnchor,
                                     topConstants: 24,
                                     centerX: scrollView.centerXAnchor)
        customerEmailTextField.anchors(top: customerDetailsLabel.bottomAnchor,
                                       topConstants: 16,
                                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                                       leadingConstants: 24,
                                       trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                       trailingConstants: -24,
                                       heightConstants: 34)
    }
    
    func setUpBillingDetails() {
        scrollView.addSubviews(views: [billingAddressLabel,
                                      billingStreetNameTextField,
                                      billingCityNameTextField,
                                      billingPostCodeTextField, billingCountryTextField])
        let width = CGFloat((UIScreen.main.bounds.width - 64 ) / 2)
        
        billingAddressLabel.anchors(top: customerEmailTextField.bottomAnchor,
                                     topConstants: 24,
                                     centerX: scrollView.centerXAnchor)
        billingStreetNameTextField.anchors(top: billingAddressLabel.bottomAnchor,
                                       topConstants: 16,
                                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                                       leadingConstants: 24,
                                       trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                       trailingConstants: -24,
                                       heightConstants: 34)
        billingCityNameTextField.anchors(top: billingStreetNameTextField.bottomAnchor,
                                       topConstants: 16,
                                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                                       leadingConstants: 24,
                                       trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                       trailingConstants: -24,
                                       heightConstants: 34)
        billingPostCodeTextField.anchors(top: billingCityNameTextField.bottomAnchor,
                                         topConstants: 16,
                                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                                         leadingConstants: 24,
                                         heightConstants: 34,
                                         widthConstants: width)
        billingCountryTextField.anchors(top: billingCityNameTextField.bottomAnchor,
                                         topConstants: 16,
                                         leading: billingPostCodeTextField.trailingAnchor,
                                         leadingConstants: 16,
                                         heightConstants: 34,
                                         widthConstants: width)
    }
    
    func setupCheckBoxForBilling() {
        var tapOneGesture = UITapGestureRecognizer()
        scrollView.addSubview(billingCheckbox)
        billingCheckbox.anchors(top: billingCountryTextField.bottomAnchor,
                              topConstants: 16,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              leadingConstants: 24,
                              heightConstants: 16,
                              widthConstants: 16)
        billingCheckbox.selected = false
        billingCheckbox.isUserInteractionEnabled = true
        tapOneGesture = UITapGestureRecognizer.init(target: self, action: #selector(billingCheckBoxTapped(sender:)))
        billingCheckbox.addGestureRecognizer(tapOneGesture)
        
        sameBillingAndShippingTitle = UIButton()
        sameBillingAndShippingTitle.isSelected = false
        scrollView.addSubview(sameBillingAndShippingTitle)
        sameBillingAndShippingTitle.setTitleColor(.black, for: .normal)
        sameBillingAndShippingTitle.setTitle("Shipping address same as Billing address",for: .normal)
        sameBillingAndShippingTitle.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        sameBillingAndShippingTitle.anchors(leading: billingCheckbox.trailingAnchor,
                                            leadingConstants: 16,
                                            centerY: billingCheckbox.centerYAnchor)
        sameBillingAndShippingTitle.layoutIfNeeded()
        sameBillingAndShippingTitle.titleLabel?.textAlignment = .left
        paymentOptionsArray.append(sameBillingAndShippingTitle)
        sameBillingAndShippingTitle.addTarget(self, action: #selector(billingButtonTapped(sender:)), for: .touchUpInside)
        sameBillingAndShippingTitle.adjustsImageWhenHighlighted = false
    }
    
    
    func setUpShippingDetails() {
        scrollView.addSubviews(views: [shippingAddressLabel,
                                       shippingStreetNameTextField,
                                       shippingCityNameTextField,
                                       shippingPostCodeTextField, shippingCountryTextField])
        let width = CGFloat((UIScreen.main.bounds.width - 64 ) / 2)
        
        shippingAddressLabel.anchors(top: billingCheckbox.bottomAnchor,
                                     topConstants: 24,
                                     centerX: scrollView.centerXAnchor)
        shippingStreetNameTextField.anchors(top: shippingAddressLabel.bottomAnchor,
                                       topConstants: 16,
                                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                                       leadingConstants: 24,
                                       trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                       trailingConstants: -24,
                                       heightConstants: 34)
        shippingCityNameTextField.anchors(top: shippingStreetNameTextField.bottomAnchor,
                                       topConstants: 16,
                                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                                       leadingConstants: 24,
                                       trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                       trailingConstants: -24,
                                       heightConstants: 34)
        shippingPostCodeTextField.anchors(top: shippingCityNameTextField.bottomAnchor,
                                         topConstants: 16,
                                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                                         leadingConstants: 24,
                                         heightConstants: 34,
                                         widthConstants: width)
        shippingCountryTextField.anchors(top: shippingCityNameTextField.bottomAnchor,
                                         topConstants: 16,
                                         leading: shippingPostCodeTextField.trailingAnchor,
                                         leadingConstants: 16,
                                         heightConstants: 34,
                                         widthConstants: width)
    }
    
    func setUpSaveConfigButton() {
        scrollView.addSubview(saveConfigButton)
        saveConfigButton.anchors(top: shippingCountryTextField.bottomAnchor,
                                 topConstants: 16,
                                 bottom: scrollView.bottomAnchor,
                                 bottomConstants: -36,
                                 heightConstants: 34,
                                 widthConstants: 72,
                                 centerX: scrollView.centerXAnchor)
    }
}
