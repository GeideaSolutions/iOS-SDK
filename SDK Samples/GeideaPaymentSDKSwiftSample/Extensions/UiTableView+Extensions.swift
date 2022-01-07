//
//  UiiTableView+Extensions.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 02/03/2021.
//

import UIKit

extension UITableView {
 
    func register<T: UITableViewCell>(_: T.Type) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
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
