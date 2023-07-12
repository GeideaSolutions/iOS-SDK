//
//  Coordinstor.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12/10/2020.
//

import UIKit

@objc protocol Coordinator {
    var navigationController: UIViewController {get set}
    func start()
}

extension Coordinator {
   
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (()->())? = nil) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        if let navController = navigationController as? UINavigationController {
            navController.pushViewController(viewController, animated: animated)
        }
    }
    
    func dismissPresentedViewController(_ animated: Bool = true, completion: (()->())? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func pop(_ animated: Bool = true) {
        if let navController = navigationController as? UINavigationController {
            navController.popViewController(animated: animated)
        }
       
    }
    
    func popToRoot(_ animated: Bool = true) {
        if let navController = navigationController as? UINavigationController {
            navController.popToRootViewController(animated: animated)
        }
       
    }
}
