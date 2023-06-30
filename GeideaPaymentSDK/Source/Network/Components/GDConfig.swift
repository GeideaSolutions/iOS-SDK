//
//  GlobalConfig.swift
//  GeideaPaymentSampleSwift
//
//  Created by euvid on 13/10/2020.
//

import Foundation

@objc public enum LogLevel: Int {
    /// No log will be shown. Recommended for production environments.
    case none = 0
    
    /// Only warnings and errors. Recommended for develop environments.
    case error = 1
    
    /// Errors and relevant information. Recommended for test integrating.
    case info = 2
    
    /// Request and Responses to GeideaPaymentSDK's server will be displayed. Not recommended to use, only for debugging.
    case debug = 3
}



class GlobalConfig {

    static var shared = GlobalConfig()

    // MARK: Global Constants
    static let Host                   = GlobalConfig.shared.environment.baseUrlString
    static let ErrorDomain            = "net.geidea.GeideaPaymentSDK"
    static let GDErrorKey      = "GeideaPaymentSDKMessage"
    static let GDErrorDebugKey = "GeideaPaymentSDKDebugMessage"

    // MARK: Global Variables
    #if DEBUG
    var appStoreRelease = false
    var environment = Environment.prod
    #else
    var appStoreRelease = true
    var environment = Environment.prod
    #endif
    var logLevel: LogLevel   = .debug
    var language = Language.english

}
