//
//  Log.swift
//  GeideaPaymentSampleSwift
//
//  Created by euvid on 13/10/2020.
//

import Foundation


func >= (levelA: LogLevel, levelB: LogLevel) -> Bool {
    return levelA.rawValue >= levelB.rawValue
}


func log(_ log: String) {
    guard !GlobalConfig.shared.appStoreRelease else { return }
    print("GeideaPaymentSDK :: " + log)
}

func logInfo(_ message: String) {
    guard GlobalConfig.shared.logLevel >= .info else { return }

    log(message)
}

func logEvent(_ event: String, parameters: [String: String]? = nil) {

    log("******** \(event) ********")
    guard let params = parameters else { return }
    for key in params.keys {
        log("\(event) - \(key):\t" + params[key]! )
    }
    
    log("\(event) *************************\n")
    
}

func logWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard GlobalConfig.shared.logLevel >= .error else { return }

    let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
    log("⚠️⚠️⚠️ WARNING: " + message)
    log("⚠️⚠️⚠️ ⤷ FROM CALLER: " + caller + "\n")
}


func logError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard
        GlobalConfig.shared.logLevel >= .error,
        let err = error
        else { return }
    
    if let code = error?.code, code == 401 || code == 402 || code == 4002 {
        return
    }

    let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
    log("‼️‼️‼️ ERROR: " + err.localizedDescription)
    log("‼️‼️‼️ ⤷ FROM CALLER: " + caller)
    log("‼️‼️‼️ ⤷ USER INFO: \(err.userInfo)\n")
}
