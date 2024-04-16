//
//  InstallmentPlanCellViewModel.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 21.02.2022.
//

import Foundation

class InstallmantPlanCellViewModel {
    
    var selected = false
    var item: GDInstallmentPlan
    
    init(_ item: GDInstallmentPlan,_ selected:Bool = false) {
        self.item = item
        self.selected = selected
    }
}
