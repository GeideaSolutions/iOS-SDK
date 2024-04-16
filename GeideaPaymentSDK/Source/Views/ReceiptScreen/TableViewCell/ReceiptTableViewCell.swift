//
//  ReceiptTableViewCell.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 16.09.2021.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    func setupViews() {
        if GlobalConfig.shared.language == .arabic {
            value.textAlignment = .left
        } else {
            value.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
