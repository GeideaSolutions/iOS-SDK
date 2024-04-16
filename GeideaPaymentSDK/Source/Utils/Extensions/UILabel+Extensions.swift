//
//  UILabel+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 20.07.2021.
//

import UIKit

extension UILabel {
   
    func setSubscriptCurrencyText(forAmount amount: Double) {
        let currencyText = String(amount).formattedAmountString(forAmount: amount)
        setAmountScriptText(currencyText, withSeparator: ".", scriptScaleFactor: 0.5, isSubscript: true)
    }

    func setSuperscriptCurrencyText(forAmount amount: Double) {
        let currencyText =  String(amount)
        setAmountScriptText(currencyText, withSeparator: ".", scriptScaleFactor: 0.7, isSubscript: false)
    }

    func setAmountScriptText(_ text: String,withSeparator separator: Character, scriptScaleFactor scaleFactor: CGFloat, isSubscript: Bool) {
        let font = self.font!
        let subscriptFont = font.withSize(font.pointSize * scaleFactor)
//        let subscriptOffset = (isSubscript ? -1 : 1) * font.pointSize * (1 - scaleFactor)
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font : font])

        if let separationIndex = text.index(of: separator)?.utf16Offset(in: text) {
            let decimalLength = text.count - separationIndex
            let subscriptRange = NSRange(location: separationIndex, length: decimalLength)
            attributedString.setAttributes([.font: subscriptFont],
                                           range: subscriptRange)
            self.attributedText = attributedString
        }
    }
    
}
