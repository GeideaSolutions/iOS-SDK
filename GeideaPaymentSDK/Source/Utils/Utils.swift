//
//  Utils.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/10/2020.
//

import UIKit
import Foundation
import WebKit

public class Utils {
    
    static public func getPublicIPAddress() -> String {
        var publicIP = ""
        do {
            try publicIP = String(contentsOf: URL(string: "https://api.ipify.org/")!, encoding: String.Encoding.utf8)
            publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        catch {
            print("Error: \(error)")
        }
        return publicIP
    }
    
    static public func getBrowser() -> String {
        
        return WKWebView().value(forKey: "userAgent") as! String
//        return "Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
    }
    
    static public func getColorDepth() -> Int {
        
        return 32
    }
    
    static public func getTimezoneOffset() -> Int {
        let seconds = TimeZone.current.secondsFromGMT()
        let minutes = abs(seconds / 60)
        return minutes
    }
    
    static public func getScreenHeight() -> Int {
        return Int(UIScreen.screenHeight)
    }
    
    static public func getScreenWidth() -> Int {
        return Int(UIScreen.screenWidth)
    }
    
    static public func javaEnabled() -> Bool{
         return false
    }
    
    static public func javaScriptEnabled() -> Bool {
         return false
    }
    
    
    static public func getImageView(with image: UIImage, width: Double, height: Double = 0) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if width > 0 {
            imageView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        }
        
        if height > 0 {
            imageView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        }
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
}
