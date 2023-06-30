//
//  DynamicTableView.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 17.09.2021.
//

import UIKit

class DynamicTableView: UITableView {
    /// Will assign automatic dimension to the rowHeight variable
    /// Will asign the value of this variable to estimated row height.
    var dynamicRowHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            rowHeight = UITableViewAutomaticDimension
            estimatedRowHeight = dynamicRowHeight
        }
    }

    public override var intrinsicContentSize: CGSize { contentSize }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }

}
