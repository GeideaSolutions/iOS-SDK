//
//  AppDelegate.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 15/10/2020.
//

import UIKit
import GeideaPaymentSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var language: String = "en"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
        } else {
            showLaunchScreen()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard  let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),  let host = components.host,let queryItems = components.queryItems else {
            return false
        }
        
        //redirect to to particular viewController
        switch host {
        case "hostMethod":
            //go to host
            break
        default:
            //go to main
            break
        }
        
//        if let merchantReferenceId = queryItems.filter({$0.name == "merchantReferenceId"}).first {
//            //Use merchantReferenceId
//        }
//        
//        if let amount = queryItems.filter({$0.name == "amount"}).first {
//            //Use amount
//        }
//        
//        if let rrn = queryItems.filter({$0.name == "rrn"}).first {
//            //Use transactionId
//        }
//        
//        
//        if let authCode = queryItems.filter({$0.name == "authCode"}).first {
//            //Use authCode
//        }
//        
//        if let transactionResponseTime = queryItems.filter({$0.name == "transactionResponseTime"}).first {
//            //Use transactionResponseTime
//        }
//        
//        if let transactionResponseTime = queryItems.filter({$0.name == "status"}).first {
//            //Use transactionResponseTime
//        }
//        
//        // For pay by card there are 2 different fields
//        if let cardScheme = queryItems.filter({$0.name == "cardScheme"}).first {
//            //Use cardScheme
//        }
//        
//        if let responseCode = queryItems.filter({$0.name == "responseCode"}).first {
//            //Use responseCode
//        }
        
        return true
    }
    
    func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        _ = storyboard.instantiateViewController(withIdentifier: "ViewController")
        let rootViewController = self.window?.rootViewController as! UINavigationController
        window?.rootViewController = rootViewController
    }

    func resetViewController() {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        } else {
            showLaunchScreen()
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        

        return
    }
    
    
}

