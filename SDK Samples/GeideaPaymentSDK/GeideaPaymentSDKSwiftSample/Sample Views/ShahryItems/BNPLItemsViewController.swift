//
//  ShahryItemsViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Eugen Vidolman on 13.04.2022.
//

import UIKit
import GeideaPaymentSDK

class BNPLItemsViewController: UIViewController {

    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var countTF: UITextField!
    @IBOutlet weak var itemId: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var payItemBtn: UIButton!
    
    var vcCompletion: FormCompletionHandler!
    var total = 0.0
    var viewModel: BNPLItemViewModel!
    var items: [GDBNPLItem] = [GDBNPLItem]()
    
    private var inputs: [UITextField]!
    
    init() {
        super.init(nibName: "ShahryItemsViewController", bundle: Bundle(for:  BNPLItemsViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupViews()
    }
    
    func setupViews() {
        
        total = viewModel.amount.amount
        
        inputs = [priceTF, countTF,nameTF, descriptionTF, categoryTF ]
        handleTextFields()
        
        itemsTV.register(ItemTableViewCell.self)
        itemsTV.delegate = self
        itemsTV.dataSource = self
       
    }
    
    func handleTextFields() {
        (0..<inputs.count).forEach { index in
            let textField = inputs[index]
            textField.delegate = self
            textField.tag = index
            let buttonText = "DONE"
//            if index == inputs.count - 1 {
//                buttonText = "DONE"
//            }
            textField.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: buttonText)
            
        }
    }
    
    private func unfocusFields() {
        
        inputs.forEach {
            $0.endEditing(true)
        }
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
//        if sender.tag == inputs.count - 1 {
            inputs[sender.tag].resignFirstResponder()
//        } else {
//            inputs[sender.tag + 1].becomeFirstResponder()
//        }
    }


    @IBAction func addItemTapped(_ sender: Any) {
        let category =  categoryTF.text?.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        let item = GDBNPLItem(merchantItemId: itemId.text, name: nameTF.text, itemDescription: descriptionTF.text, categories: category, count: Int(countTF.text ?? "0") ?? 0, price: Double(priceTF.text ?? "0.0") ?? 0.0)
        
        self.items.append(item)
        
        itemsTV.reloadData()
    }

    @IBAction func payItemsTapped(_ sender: Any) {
        let amount = GDAmount(amount: total, currency: viewModel.amount.currency)
        GeideaPaymentAPI.payWithGeideaForm(theAmount: amount, showAddress: viewModel.showAddress, showEmail: viewModel.showEmail, showReceipt: viewModel.showReceipt, tokenizationDetails: viewModel.tokenizationDetails, customerDetails: viewModel.customerDetails,config: viewModel.config, paymentIntentId: viewModel.paymentIntentId, qrDetails: viewModel.qrCustomerDetails, bnplItems: items, cardPaymentMethods: viewModel.paymentMethods, paymentSelectionMethods: viewModel.paymentSelectionMethods, viewController: self, completion: { order, error in
            DispatchQueue.main.async {
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewModel.completion(order, error)
                }
                
                self.dismiss(animated: false)
             
            }
           
        })
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension BNPLItemsViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let eInvoiceItem =  itemForIndexPath(indexPath)
        
        cell.priceTF.text = "\(eInvoiceItem?.price ?? 0)"
        cell.quantityTF.text = "\(eInvoiceItem?.count ?? 0)"
        cell.descriptionTF.text = eInvoiceItem?.name
        
        cell.selectionStyle = .none
        
        total = viewModel.amount.amount
//        for item in items {
//            let totalItem = item.price * Double(item.count)
//            total += totalItem
//        }
        payItemBtn.setTitle("Pay Items \(total) \(viewModel.amount.currency)", for: .normal)
        return cell
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> GDBNPLItem? {
        return items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard itemForIndexPath(indexPath) != nil else { return  }
        
//        displayAlert(title: "EInvoice Item", message: getModelString(eInvoiceItem: safeInvoiceItem) ?? "")
        
    }
    
    func displayAlert(title: String, message: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true)
        }
        
    }
}


extension BNPLItemsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        unfocusFields()
        return true
    }
}



