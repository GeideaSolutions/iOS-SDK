//
//  UIColor+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12/01/2021.
//

import UIKit

extension UIColor {
    class var buttonBlue: UIColor {
           return UIColor(red: 51.0 / 255.0, green: 153.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var buttonBlueDisabled: UIColor {
           return UIColor(red: 153.0 / 255.0, green: 204.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
    
    class var borderDisabled: UIColor {
           return UIColor(red: 204 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    class var borderSelected: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 153.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.4)
    }
    
    class var borderCVV: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.06)
    }
    
    class var formLabelColor: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 59.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }
    
    class var formLabelErrorColor: UIColor {
        return UIColor(red: 0.94, green: 0.29, blue: 0.23, alpha: 1.00)
    }
    
    class var form506Color: UIColor {
        return UIColor(red: 80.0 / 255.0, green:96.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
    }
    
    class var orangeHighlightColor: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 77.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    
    class var sameShippingColor: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 153.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var notSameShippingColor: UIColor {
        return UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    }
    
    convenience init?(hex: String?) {
            let input: String! = (hex ?? "")
                .replacingOccurrences(of: "#", with: "")
                .uppercased()
            var alpha: CGFloat = 1.0
            var red: CGFloat = 0
            var blue: CGFloat = 0
            var green: CGFloat = 0
            switch (input.count) {
            case 3 /* #RGB */:
                red = Self.colorComponent(from: input, start: 0, length: 1)
                green = Self.colorComponent(from: input, start: 1, length: 1)
                blue = Self.colorComponent(from: input, start: 2, length: 1)
                break
            case 4 /* #ARGB */:
                alpha = Self.colorComponent(from: input, start: 0, length: 1)
                red = Self.colorComponent(from: input, start: 1, length: 1)
                green = Self.colorComponent(from: input, start: 2, length: 1)
                blue = Self.colorComponent(from: input, start: 3, length: 1)
                break
            case 6 /* #RRGGBB */:
                red = Self.colorComponent(from: input, start: 0, length: 2)
                green = Self.colorComponent(from: input, start: 2, length: 2)
                blue = Self.colorComponent(from: input, start: 4, length: 2)
                break
            case 8 /* #AARRGGBB */:
                alpha = Self.colorComponent(from: input, start: 0, length: 2)
                red = Self.colorComponent(from: input, start: 2, length: 2)
                green = Self.colorComponent(from: input, start: 4, length: 2)
                blue = Self.colorComponent(from: input, start: 6, length: 2)
                break
            default:
                NSException.raise(NSExceptionName("Invalid color value"), format: "Color value \"%@\" is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", arguments:getVaList([hex ?? ""]))
            }
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        static func colorComponent(from string: String!, start: Int, length: Int) -> CGFloat {
            let substring = (string as NSString)
                .substring(with: NSRange(location: start, length: length))
            let fullHex = length == 2 ? substring : "\(substring)\(substring)"
            var hexComponent: UInt64 = 0
            Scanner(string: fullHex)
                .scanHexInt64(&hexComponent)
            return CGFloat(Double(hexComponent) / 255.0)
        }
    
    
   
}
