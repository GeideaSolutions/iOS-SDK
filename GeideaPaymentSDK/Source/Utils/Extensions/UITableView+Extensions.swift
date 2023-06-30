//
//  UITableView+Extensions.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/01/2021.
//

import UIKit

extension UITableView {
 
    func register<T: UITableViewCell>(_: T.Type) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: Bundle(identifier: "net.geidea.GeideaPaymentSDK"))
        register(nib, forCellReuseIdentifier: nibName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let nibName = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(nibName)")
        }
        return cell
    }
}
