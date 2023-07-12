//
//  CardPaymentViewController+UI.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 13/06/23.
//

import UIKit

extension CardPaymentViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        let guide = view.safeAreaLayoutGuide
        view.addSubview(paymentDetailsLabel)
        paymentDetailsLabel.anchors(top: guide.topAnchor,
                            topConstants: 24,
                            centerX: view.centerXAnchor)
        
        view.addSubviews(views: [amount, amountTextField, currency, currencyValueLabel])
        
        amount.anchors(top: paymentDetailsLabel.bottomAnchor,
                       topConstants: 24,
                       leading: guide.leadingAnchor,
                       leadingConstants: 24,
                       widthConstants: 64)
        amountTextField.anchors(top: paymentDetailsLabel.bottomAnchor,
                                  topConstants: 16,
                                  leading: amount.trailingAnchor,
                                  leadingConstants: 24,
                                  trailing: guide.trailingAnchor,
                                  trailingConstants: -24,
                                  heightConstants: 34)
        currency.anchors(top: amountTextField.bottomAnchor,
                         topConstants: 16,
                         leading: guide.leadingAnchor,
                         leadingConstants: 24)
        currencyValueLabel.anchors(leading: amountTextField.leadingAnchor,
                                   centerY: currency.centerYAnchor)
        setupOptionsUI()
        setupCardDetailsUI()
        setupPayButton()
    }
    
    func setupOptionsUI() {
        
        var tapOneGesture = UITapGestureRecognizer()
        var tapTwoGesture = UITapGestureRecognizer()
        
        var firstLabelTitle : UIButton!
        var seconTitleLabel : UIButton!
        
        view.addSubview(firstRadioButton)
        firstRadioButton.selected = true
        firstRadioButton.anchors(top: currency.bottomAnchor,
                                 topConstants: 36,
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
        view.addSubview(firstLabelTitle)
        firstLabelTitle.setTitleColor(.black, for: .normal)
        firstLabelTitle.setTitle("Giedea SDK",for: .normal)
        firstLabelTitle.titleLabel?.font =  UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        firstLabelTitle.anchors(leading: firstRadioButton.trailingAnchor,
                                leadingConstants: 16,
                                centerY: firstRadioButton.centerYAnchor)
        firstLabelTitle.layoutIfNeeded()
        sdkArray.append(firstLabelTitle)
        firstLabelTitle.addTarget(self, action: #selector(labelTapped(sender:)), for: .touchUpInside)
        firstLabelTitle.adjustsImageWhenHighlighted = false
        
        
        tapTwoGesture = UITapGestureRecognizer.init(target: self, action: #selector(buttonOneTapped(sender:)))
        
        view.addSubview(secondRadioButton)
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
        view.addSubview(seconTitleLabel)
        seconTitleLabel.backgroundColor = .white
        seconTitleLabel.setTitleColor(.black, for: .normal)
        seconTitleLabel.setTitle("Merchant PCI-DSS",for: .normal)
        seconTitleLabel.titleLabel?.font =  UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        seconTitleLabel.anchors(leading: secondRadioButton.trailingAnchor,
                                leadingConstants: 16,
                                centerY: secondRadioButton.centerYAnchor)
        seconTitleLabel.layoutIfNeeded()
        sdkArray.append(seconTitleLabel)
        seconTitleLabel.addTarget(self, action: #selector(labelTapped(sender:)), for: .touchUpInside)
        seconTitleLabel.adjustsImageWhenHighlighted = false
    }
    
    func setupCardDetailsUI() {
        view.addSubview(cardDetailsView)
        cardDetailsView.anchors(top: secondRadioButton.bottomAnchor,
                                topConstants: 24,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor)
        heightConstraint = cardDetailsView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        cardDetailsView.addSubviews(views: [cardNumberTextField,
                                            expiryMonthTextField,
                                            expiryYearTextField,
                                            cvvTextField,
                                            cardHolderNameField])
        cardNumberTextField.anchors(top: cardDetailsView.topAnchor,
                                  topConstants: 0,
                                  leading: cardDetailsView.leadingAnchor,
                                  leadingConstants: 24,
                                  trailing: cardDetailsView.trailingAnchor,
                                  trailingConstants: -24,
                                  heightConstants: 34)
        let width = CGFloat((UIScreen.main.bounds.width - 72) / 3)
        expiryMonthTextField.anchors(top: cardNumberTextField.bottomAnchor,
                                     topConstants: 16,
                                     leading: cardDetailsView.leadingAnchor,
                                     leadingConstants: 24,
                                     heightConstants: 34,
                                     widthConstants: width)
        expiryYearTextField.anchors(top: cardNumberTextField.bottomAnchor,
                                     topConstants: 16,
                                     leading: expiryMonthTextField.trailingAnchor,
                                     heightConstants: 34,
                                     widthConstants: width)
        cvvTextField.anchors(top: cardNumberTextField.bottomAnchor,
                             topConstants: 16,
                             leading: expiryYearTextField.trailingAnchor,
                             leadingConstants: 24,
                             heightConstants: 34,
                             widthConstants: width)
        cardHolderNameField.anchors(top: cvvTextField.bottomAnchor,
                                  topConstants: 16,
                                  leading: cardDetailsView.leadingAnchor,
                                  leadingConstants: 24,
                                  trailing: cardDetailsView.trailingAnchor,
                                  trailingConstants: -24,
                                  heightConstants: 34)
    }
    
    func setupPayButton() {
        view.addSubview(payButton)
        payButton.anchors(top: cardDetailsView.bottomAnchor,
                                 topConstants: 0,
                                 heightConstants: 34,
                                 widthConstants: 72,
                                 centerX: view.centerXAnchor)
    }
    
}
