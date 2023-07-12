//
//  AppConfig.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 19/10/2020.
//

import Foundation

class AppConfig {
    fileprivate struct Constants {
        static let AuthenticateResponse = "GDAuthencticateResponse"
        static let ConfigResponse = "GDConfigResponse"
        static let groupName = "GDAppGroup"
    }
    
    static let sharedInstance = AppConfig()
    
    lazy var userDefaults: UserDefaults = {
        let defaults = UserDefaults(suiteName: Constants.groupName)
        return defaults ?? UserDefaults.standard
    }()
    
}

// MARK: - User Defaults

extension AppConfig {
    
    func clearSuite() {
        userDefaults.removePersistentDomain(forName: Constants.groupName)
    }
    
}

extension AppConfig {
  
    func getAuthenticateResponse() -> [String:Any] {
        return userDefaults.object(forKey: Constants.AuthenticateResponse) as! [String : Any]
    }
    
    func setAuthenticateResponse(_ authenticateResponse: [String: Any]) {
        userDefaults.set(authenticateResponse, forKey: Constants.AuthenticateResponse)
        userDefaults.synchronize()
    }
    
    func getConfigResponse() -> [String:Any] {
        return userDefaults.object(forKey: Constants.ConfigResponse) as? [String : Any] ?? [:]
    }
    
    func setConfigResponse(_ configResponse: [String: Any]) {
        userDefaults.set(configResponse, forKey: Constants.ConfigResponse)
        userDefaults.synchronize()
    }
}

    
