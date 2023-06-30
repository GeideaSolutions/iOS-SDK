//
//  NSAttributeString+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 14.04.2022.
//

import Foundation

extension NSAttributedString {

    convenience init?(withLocalizedHTMLString: String, attributes: NSDictionary ) {

        guard let stringData = withLocalizedHTMLString.data(using: String.Encoding.utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html as Any,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        var attr = attributes

        try? self.init(data: stringData, options: options, documentAttributes:nil)
    }
}
