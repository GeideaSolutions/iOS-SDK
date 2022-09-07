//
//  ItemTableViewCell.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 12.11.2021.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var priceTF: UILabel!
    @IBOutlet weak var quantityTF: UILabel!
    @IBOutlet weak var descriptionTF: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
