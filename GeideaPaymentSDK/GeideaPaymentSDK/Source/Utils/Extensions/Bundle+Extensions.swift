//
//  Bundle+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27.08.2021.
//

import Foundation


var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {

  override func localizedString(forKey key: String,
                              value: String?,
                              table tableName: String?) -> String {

    guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
        let bundle = Bundle(path: path) else {
        return super.localizedString(forKey: key, value: value, table: tableName)
    }

    return bundle.localizedString(forKey: key, value: value, table: tableName)
  }
}

extension Bundle {

  class func setLanguage(_ language: String) {
    defer {
        object_setClass(Bundle(identifier: "net.geidea.GeideaPaymentSDK"), AnyLanguageBundle.self)
    }
    objc_setAssociatedObject(Bundle(identifier: "net.geidea.GeideaPaymentSDK")!, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
