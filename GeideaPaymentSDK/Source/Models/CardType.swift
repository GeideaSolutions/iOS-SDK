//
//  CardType.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 11/01/2021.
//

import Foundation

@objc public enum CardType: Int {
    case Amex, Visa, MasterCard, Mada, Meeza

    static let allCards = [Amex, Visa, MasterCard, Mada]

    var cardSchemeName : String {
        switch self {
        case .Meeza:
            return "meeza"
        case .Mada:
           return "mada"
        case .Amex:
           return "amex"
        case .Visa:
           return "visa"
        case .MasterCard:
           return "mastercard"
        default:
           return ""
        }
    }

    public var regex : String {
        switch self {
        case .Meeza:
           return "^507803(?:2[5-9]|3[0-9]|4[0-4])"
        case .Amex:
           return "^3[47][0-9]{5,}$"
        case .Visa:
           return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
           return "^5[1-5][0-9]{14}|^(222[1-9]|22[3-9]\\d|2[3-6]\\d{2}|27[0-1]\\d|2720)[0-9]{12}$"
        case .Mada:
           return "^((((400861)|(409201)|(410685)|(417633)|(428331)|(428671-428673)|(431361)|(432328)|(440533)|(440647)|(440795)|(445564)|(446404)|(446672)|(455036)|(457865)|(458456)|(462220)|(468540-468543)|(484783)|(489317-489319)|(490980)|(493428)|(504300)|(508160)|(521076)|(527016)|(539931)|(557606)|(558848)|(585265)|(588845-588851)|(588982-588983)|(589005)|(589206)|(604906)|(605141)|(636120)|(422817-422819)|(968200-968299)|(439954)|(439956)|(419593)|(483010-483012)|(532013)|(531095)|(530906)|(455708)|(524514)|(529741)|(537767)|(535989)|(486094-486096)|(543357)|(401757)|(446393)|(434107)|(536023)|(407197)|(407395)|(529415)|(535825)|(543085)|(549760)|(437980))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
           return ""
        }
    }
    
    public func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
}
