//
//  CountryTableViewCell.swift
//  RazerPay
//
//  Created by euvid on 10/06/2020.
//  Copyright © 2020 RazerPay. All rights reserved.
//

import Foundation
import UIKit
class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
   
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if borderView != nil {
            borderView.backgroundColor = highlighted ? UIColor.lightGray : UIColor.white
        }
    }
}
