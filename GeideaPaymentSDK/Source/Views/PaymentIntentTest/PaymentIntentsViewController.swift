//
//  PaymentIntentsViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 12.07.2021.
//

import UIKit

class PaymentIntentsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var paymentIntents: [GDPaymentIntentDetailsResponse]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PaymentIntentTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentIntents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PaymentIntentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let paymentIntent =  itemForIndexPath(indexPath)
        
        cell.paymentId.text = paymentIntent?.paymentIntentId
        cell.type.text = paymentIntent?.type
        cell.status.text = paymentIntent?.status
        
        cell.selectionStyle = .none
        return cell
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> GDPaymentIntentDetailsResponse? {
        return paymentIntents?[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let paymentIntent =  itemForIndexPath(indexPath) else {
            return
        }
        
        GeideaPaymentAPI.getPaymentIntent(with: paymentIntent.paymentIntentId!, completion: { response, error in
            
            GeideaPaymentAPI.shared.returnAction(response,error)

        })
        
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

