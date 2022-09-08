//
//  OrderTableViewCell.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 02/03/2021.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
