//
//  CVVAlertViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 21/01/2021.
//

import UIKit
import GeideaPaymentSDK

class FilterStatus {
    
    var selected = false
    var item: String
    
    init(_ item: String,_ selected:Bool = false) {
        self.item = item
        self.selected = selected
    }
}


class FilterViewController: UIViewController {
    
    @IBOutlet weak var statusCV: UICollectionView!
    @IBOutlet weak var detailedStatusCV: UICollectionView!
    
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    
    @IBOutlet weak var okBtn: UIButton!
    
    let datePicker =  UIDatePicker()
    var action: ((GDOrdersFilter)->())?
    let dateFormatter = DateFormatter()
    
    
    var filterStatus =  [FilterStatus("Success"), FilterStatus("InProgress"), FilterStatus("Failed")]
    var filterDetailsStatuses = [
        FilterStatus("Initiated"),
        FilterStatus("Authenticated"),
        FilterStatus("AuthenticationFailed"),
        FilterStatus("AuthorizationFailed"),
        FilterStatus("CaptureFailed"),
        FilterStatus("PayFailed"),
        FilterStatus("Authorized"),
        FilterStatus("Captured"),
        FilterStatus("Paid"),
        FilterStatus("Refunded"),
        FilterStatus("Cancelled"),
        FilterStatus("ServerTimedOut"),
        FilterStatus("ClientTimedOut"),
        FilterStatus("Blocked")]
    
    
    init() {
        super.init(nibName: "FilterViewController", bundle: Bundle(for: FilterViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        createDatePicker()
    }
    
    func setupViews() {
        
        statusCV.delegate = self
        statusCV.dataSource = self
        statusCV.register(UINib(nibName:"FilterTableViewCell", bundle: nil), forCellWithReuseIdentifier:"FilterTableViewCell")
        
        detailedStatusCV.delegate = self
        detailedStatusCV.dataSource = self
        detailedStatusCV.register(UINib(nibName:"FilterTableViewCell", bundle: nil), forCellWithReuseIdentifier:"FilterTableViewCell")
        detailedStatusCV.allowsMultipleSelection = true
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
    }
    
    func createDatePicker() {
        
        let toolbarFrom = UIToolbar()
        let toolbarTo = UIToolbar()

        toolbarFrom.sizeToFit()
        toolbarTo.sizeToFit()
        
        let doneButtonFrom = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneFromPressed))
        toolbarFrom.setItems([doneButtonFrom], animated: true)
        
        let doneButtonTo = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneToPressed))
        toolbarTo.setItems([doneButtonTo], animated: true)
        
        datePicker.datePickerMode = .date
        
        fromTF.inputAccessoryView = toolbarFrom
        fromTF.inputView = datePicker
        
        toTF.inputAccessoryView = toolbarTo
        toTF.inputView = datePicker
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func doneFromPressed(sender: AnyObject) {
        fromTF.text = dateFormatter.string(from: datePicker.date )
        self.view.endEditing(true)
        
    }
    
    @objc func doneToPressed(sender: AnyObject) {
        
        toTF.text = dateFormatter.string(from: datePicker.date )
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func OKTapped(_ sender: Any) {
        let filter = GDOrdersFilter()
        
        let filteredDetailedSatus = filterDetailsStatuses.filter({ $0.selected == true})
        var filterDetailed = [String]()
        for filter in filteredDetailedSatus {
            filterDetailed.append(filter.item)
        }
        filter.DetailedStatuses = filterDetailed
        
        filter.Status = filterStatus.filter({ $0.selected == true}).first?.item

        
        if let toDate = toTF.text, !toDate.isEmpty {
            filter.ToDate = toTF.text
        }

        if let fromDate = fromTF.text, !fromDate.isEmpty {
            filter.FromDate = fromTF.text
        }
        
        if let safeAction = action  {
            safeAction(filter)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.statusCV {
            return filterStatus.count
        }
        
        return filterDetailsStatuses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        
        var status = self.filterDetailsStatuses[indexPath.item]
        if collectionView == self.statusCV {
            status = self.filterStatus[indexPath.item]
        }
        
        cell.filterLabel.text = status.item
        if status.selected {
            cell.checkIV.isHidden = false
        } else {
            cell.checkIV.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var status = self.filterDetailsStatuses[indexPath.item]
        if collectionView == self.statusCV {
            status = self.filterStatus[indexPath.item]
            let lastStatus = status.selected
            self.filterStatus.map{ $0.selected = false }
            status.selected = !lastStatus
            collectionView.reloadData()
        } else {
            status.selected =  !status.selected
            collectionView.reloadItems(at: [indexPath])
        }
        
        
       
        
    }
}
