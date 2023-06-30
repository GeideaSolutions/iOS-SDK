//
//  GridCollectionLayout.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.02.2022.
//

import UIKit

class GridCollectionViewLayout: UICollectionViewLayout {
  
   var columnSpacing: CGFloat = 8
   var rowSpacing: CGFloat = 16
   var sectionSpacing: CGFloat = 32

   var estimatedColumnSpan = 1
   var estimatedCellHeight: CGFloat = 60

   private(set) var numberOfColumns: Int

   init(numberOfColumns: Int) {
       self.numberOfColumns = numberOfColumns
       super.init()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
