//
//  Strings+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 14/10/2020.
//

import Foundation

extension String {
    public var asURL: URL? {
        return URL(string: self) 
    }
    
    var localized: String {
           
    
        if let path = Bundle(identifier: "net.geidea.GeideaPaymentSDK")!.path(forResource: GlobalConfig.shared.language.name.lowercased(), ofType: "lproj"), let bundle = Bundle(path: path) {
                
                return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
            } else {
                return NSLocalizedString(self, bundle: Bundle(identifier: "net.geidea.GeideaPaymentSDK")!, comment: "")
            }
        
    }
    
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isNumeric: Bool {
         return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
    
    var isOnlyLetters: Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    var isValidURL: Bool {
        
        let callBackUrlRegex = "^https:\\/\\/([^#/,.!?@&:;\\s]{1,63}\\.){1,10}([\\w]{2,24}([^#,!@&:;\\s]*))$"
        let callBacktest = NSPredicate(format: "SELF MATCHES %@", callBackUrlRegex)
        return callBacktest.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidPaymentIntentPhone: Bool {
        return self.hasPrefix("+9665") && self.count == 13
    }
    
    var isValidEgiptPhone: Bool {
        if self.hasPrefix("01") && self.count == 11 {
            return true
        } else if self.hasPrefix("00201") && self.count == 14 {
            return true
        } else if self.hasPrefix("+201") && self.count == 13 {
            return true
        } else if self.hasPrefix("201") && self.count == 12 {
            return true
        } else if  self.count == 9 && self.isNumeric {
            return true
        }
        
        return false
    }
    
    var isValidEgiptPhonWOPrefix: Bool {
        if self.count >= 10 {
            if self.hasPrefix("01") {
                return true
            } else if self.hasPrefix("1") {
                return true
            } else {
                return false
            }
        } else{
            return true
        }
        
    }

    
    var isAlphanumeric: Bool {
            return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        }
        
    
    var isValidCardName: Bool {
        let regex = try! NSRegularExpression(pattern: "^([A-Z])([A-Z0-9 -.,]+)([A-Z0-9.,])$", options: .caseInsensitive)
                return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
           
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func formattedAmountString(forAmount amount: Double) -> String {
        return String(format: "%.2f", amount)
    }

    
    func modifyCreditCardString() -> String {
        let trimmedString = self.components(separatedBy: " ").joined()

             let arrOfCharacters = Array(trimmedString)
             var modifiedCreditCardString = ""

             if(arrOfCharacters.count > 0) {
                 for i in 0...arrOfCharacters.count-1 {
                     modifiedCreditCardString.append(arrOfCharacters[i])
                     if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                         modifiedCreditCardString.append(" ")
                     }
                 }
             }
             return modifiedCreditCardString
     }
    
    func modifyDateCardString() -> String {
        let trimmedString = self.components(separatedBy: "/").joined()

             let arrOfCharacters = Array(trimmedString)
             var modifiedCreditCardString = ""

             if(arrOfCharacters.count > 0) {
                 for i in 0...arrOfCharacters.count-1 {
                     modifiedCreditCardString.append(arrOfCharacters[i])
                     if((i+1) % 2 == 0 && i+1 != arrOfCharacters.count){
                         modifiedCreditCardString.append("/")
                     }
                 }
             }
             return modifiedCreditCardString
     }
    
    func convertBase64StringToImage() -> Data? {
        return Data.init(base64Encoded: self, options: .init(rawValue: 0))
    }
    
    var fixedArabicURL: String?  {
           return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics
               .union(CharacterSet.urlPathAllowed)
               .union(CharacterSet.urlHostAllowed))
    } 
}
