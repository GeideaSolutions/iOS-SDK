//
//  OrdersViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 01/03/2021.
//

import UIKit
import GeideaPaymentSDK

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var orders = Array<GDOrderResponse>()
    var orderFilter: GDOrdersFilter?
    var totalOrders:Int = 0
    
    var currentPage : Int = 0
    var isDataLoading : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Orders sample"
        let image = UIImage(named: "Filter")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(filterTapped))
        
        getOrders()
        
        tableView.register(OrderTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func filterTapped() {
        
        let vc = FilterViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.action = filterAction
        self.present(vc, animated: true, completion: nil)
        
    }
    
    private func filterAction(filter: GDOrdersFilter) {
        self.orderFilter = filter
        getOrders(filter: filter)
    }
    
    func getOrders() {
        let orders = GDOrdersFilter()
        getOrders(filter: orders)
    }
    
    func getOrders(filter: GDOrdersFilter, append: Bool = false) {
        loadingView.isHidden = false
        GeideaPaymentAPI.getOrders(with: filter, completion:{ [self] (response, error) in
            loadingView.isHidden = true
            if let err = error {
                displayError(err: err)
            } else if let safeResponse = response, let orders = safeResponse.orders {
                if append {
                    self.orders.append(contentsOf: orders)
                } else {
                    self.orders = orders
                }
                
                self.totalOrders = safeResponse.totalCount
                self.tableView.reloadData()
            }
            
        })
    }
    
    func displayError(err: GDErrorResponse) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if err.errors.isEmpty {
                var message = ""
                if err.responseCode.isEmpty {
                    message = "\n responseMessage: \(err.responseMessage)"
                    
                } else if !err.orderId.isEmpty {
                    message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                } else {
                    message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                }
                self.displayAlert(title: err.title,  message: message)
                
            } else {
                self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
}


extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let order =  itemForIndexPath(indexPath)
        
        cell.amount.text = "\(order.amount) " + order.currency!
        cell.orderId.text = order.orderId
        
        cell.date.text = order.createdDate
        
        switch order.status {
        case "InProgress":
            cell.iconImage.image = UIImage(named: "progress")
        case "Failed":
            cell.iconImage.image = UIImage(named: "failed")
        default:
            cell.iconImage.image = UIImage(named: "check")
        }
                if indexPath.row == self.orders.count - 1  && self.orders.count < self.totalOrders {
                    self.loadMore()
                }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let orderId = itemForIndexPath(indexPath).orderId else {
            return
        }
        let vc = OrderDetailsViewController()
        vc.orderId = orderId
        vc.action = filterAction
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadMore() {
        loadingView.isHidden = true
        var orders = GDOrdersFilter(skip: self.orders.count)
        if let filter = orderFilter  {
            orders = filter
            orders.Skip =  self.orders.count
        }
        getOrders(filter: orders, append: true)
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> GDOrderResponse {
        return orders[indexPath.row]
    }
    
}
