//
//  CountriesDataSource.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/01/2021.
//

import Foundation
import UIKit

class CountriesDataSource: NSObject, TableViewSelectionDataSource {
    var countries = Array<ConfigCountriesResponse>()
    
    init(countries: Array<ConfigCountriesResponse>) {
        super.init()
        
        self.countries = countries.filter{ country in
            return country.isSupported
        }
        
        if let index = countries.firstIndex(where: { $0.key3 == "SAU" }) {
            self.countries.rearrange(from: index, to: 0)
        }
    }
    
    // MARK: - SelectionDataSource methods
    
    func numberOfItems(inSection section: Int) -> Int {
        return countries.count
    }
    
    func resultsForSearchString(_ string: String) -> [Int: [Any]] {
        return [0: countries.filter({ $0.nameEn!.lowercased().contains(string.lowercased()) })]
    }
    
    func cellForRowAtIndex(indexPath: IndexPath, tableView: UITableView, searchString: String, searchResults: [Any]) -> UITableViewCell {
        let cell: CountryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        var country = ConfigCountriesResponse()
        if searchString.count > 0 {
            if let results = searchResults as? [ConfigCountriesResponse] {
                country = results[indexPath.row]
            }
        } else if let countryItem = itemForIndexPath(indexPath) as? ConfigCountriesResponse {
            country = countryItem
        }
        
        cell.flagLabel.text = flag(country: country.key2 ?? "")
        switch GlobalConfig.shared.language {
        case .arabic:
            cell.countryNameLabel.text = country.nameAr
        default:
            cell.countryNameLabel.text = country.nameEn
        }
      
        return cell
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> Any {
        return countries[indexPath.row]
    }
    
    func flag(country: String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            usv.append(UnicodeScalar(base + Int(i))! )
        }
        return String(usv)
    }
}
