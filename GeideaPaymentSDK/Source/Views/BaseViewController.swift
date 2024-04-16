//
//  BaseViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 25.08.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        
        switch GlobalConfig.shared.language {
        case .arabic:
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        default:
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        if #available(iOS 13.0, *) {
               // Always adopt a light interface style.
               overrideUserInterfaceStyle = .light
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localizeStrings()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    
    func localizeStrings() {}

}
