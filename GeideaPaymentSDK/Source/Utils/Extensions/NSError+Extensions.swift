//
//  NSError+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 23/10/2020.
//

import Foundation

extension NSError {

    class func unexpectedError(debugMessage: String? = nil, code: Int = -1) -> NSError {
        let error = gdError("Unexpected Error", debugMessage: debugMessage, code: code)

        return error
    }

    class func gdError(_ message: String? = nil, debugMessage: String? = nil, code: Int = ErrorCodes.Unknown) -> NSError {
        var userInfo: [String: String] = [:]

        if message != nil {
            userInfo[GlobalConfig.GDErrorKey] = message
        }

        if debugMessage != nil {
            userInfo[GlobalConfig.GDErrorDebugKey] = debugMessage
        }

        let error = NSError(
            domain: GlobalConfig.ErrorDomain,
            code: code,
            userInfo: userInfo
        )

        return error
    }

    func message() -> String {
        guard let message = self.userInfo[GlobalConfig.GDErrorKey] as? String else {
            return "UnexpectedError"
        }

        return message
    }
    
}
