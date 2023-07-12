//
//  InstallmentsCollectionViewCell.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.02.2022.
//

import UIKit

class InstallmentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var monthsValue: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelected(isSelected: true)
    }
    
    func setSelected(isSelected: Bool) {
        if isSelected {
            borderView.borderColor = UIColor(red: 0.2, green: 0.6, blue: 1, alpha: 1)
        } else {
            borderView.borderColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
        }
    }
    

}
