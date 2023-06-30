//
//  UIViewController+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 27/10/2020.
//

import Foundation
import UIKit

extension UIViewController {
    
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParentViewController: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
}
