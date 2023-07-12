//  SceneDelegate.swift
//  TestSwift
//
//  Created by euvid on 05/11/2020.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        //self.window =  UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let rootVC = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
//            print("ViewController not found")
//            return
//        }
        let rootVC = DemoLandingPageViewController()
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    
    func resetViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let rootVC = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
//            print("ViewController not found")
//            return
//        }
        let rootVC = DemoLandingPageViewController()
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        // Handle URL
        guard  let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),  let host = components.host,let _ = components.queryItems else {
            return
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
    }
}

