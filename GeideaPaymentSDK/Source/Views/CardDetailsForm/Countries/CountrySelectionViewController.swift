//
//  TableViewSelectionDataSource.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 18/01/2021.
//

import Foundation
import UIKit

protocol SelectionViewControllerDelegate: class {
    func didSelectCountryItem(item: Any, buttonTag: Int)
}

protocol TableViewSelectionDataSource: class {
    func cellForRowAtIndex(indexPath: IndexPath, tableView: UITableView, searchString: String, searchResults: [Any]) -> UITableViewCell
    func numberOfItems(inSection section: Int) -> Int
    func resultsForSearchString(_ string: String) -> [Int: [Any]]
    func itemForIndexPath(_ indexPath: IndexPath) -> Any
}

class CountrySelectionViewController: BaseViewController, UIGestureRecognizerDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noResultsFound: UIView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var cancelBtn: UIButton!
    var searchTextField: UITextField!
    fileprivate var searchString = ""
    fileprivate var searchResults = [Int: [Any]]()
    weak var delegate: SelectionViewControllerDelegate?
    var cancelButton: UIButton?
    var dataSource: TableViewSelectionDataSource?
    
    
    init() {
        super.init(nibName: "CountrySelectionViewController", bundle: Bundle(for: CountrySelectionViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    var countries: [ConfigCountriesResponse] =  []
    var buttonTag: Int = 0
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureView() {
        tableView.register(CountryTableViewCell.self)
        dataSource = CountriesDataSource(countries: countries)
        
        tableView.delegate = self
        tableView.dataSource = self
        setupTitles()
    }
    
    func setupTableBackgroundView() {
        if searchString.count > 0 && areSearchResultsEmpty() {
            showNoResultsView()
        } else {
            tableView.backgroundView = nil
        }
    }
    
    // This method should be overridden in the subclasses
    func showNoResultsView() {
        tableView.backgroundView = noResultsFound
    }
    
    func setupTitles() {
        if let sView = searchView {
            searchTextField = sView.searchTextField
            searchTextField.tintColor = .black
            searchTextField.delegate = self
            searchTextField.rightViewMode = .never
            searchTextField.clearButtonMode = .never
            searchTextField.addTarget(self,
                                      action: #selector(textFieldDidChange),
                                      for: .allEditingEvents)
        }
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }

    
    @objc
    func clearSelected() {
        searchTextField.text = ""
        dismissKeyboard()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectItem(item: Any) {
        delegate?.didSelectCountryItem(item: item, buttonTag: buttonTag)
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapGestureRecognizer(_ sender: Any) {
        handleGestureRecognizerTapped()
    }
    
    func handleGestureRecognizerTapped() {
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    private func areSearchResultsEmpty() -> Bool {
        for result in searchResults where result.value.count != 0 {
            return false
        }
        
        return true
    }
    
    // MARK: Update localized strings
    
    func returnNumberOfSections() -> Int {
        return 1
    }
}

typealias SelectionTableViewDelegate = CountrySelectionViewController
extension SelectionTableViewDelegate: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchString.count > 0 {
            return searchResults[section]?.count ?? 0
        }
        
        guard let ds = dataSource else {
            return 0
        }
        return ds.numberOfItems(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchString.count > 0 && searchResults.count == 0 {
            return 0
        }
        return returnNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let ds = dataSource {
            let results = searchResults[indexPath.section] ?? []
            return ds.cellForRowAtIndex(indexPath: indexPath, tableView: tableView, searchString: searchString, searchResults: results)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let ds = dataSource {
            let results = searchResults[indexPath.section] ?? []
            let item = searchString.count > 0 ? results[indexPath.row]: ds.itemForIndexPath(indexPath)
            didSelectItem(item: item)
        }
    }
}

typealias SearchTextFieldDelegate = CountrySelectionViewController
extension SearchTextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc
    func textFieldDidChange() {
        if let string = searchTextField.text {
            searchString = string
        } else {
            searchString = ""
        }
        
        guard let results = dataSource?.resultsForSearchString(searchString) else {
            return
        }
        searchResults = results
        
        setupTableBackgroundView()
        tableView.reloadData()
    }
}
