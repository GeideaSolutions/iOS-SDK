
//
//  PaymentIntentTableViewCell.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12.07.2021.
//

import UIKit

class PaymentIntentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var paymentId: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
