//
//  EInvoiceDetailsViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.11.2021.
//

import UIKit

protocol EInvoiceItemControllerDelegate: class {
    func didAddItem(item: GDEInvoiceItem)
}

class EInvoiceDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var subtTotalTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var grandTotalTF: UITextField!
    @IBOutlet weak var extraChargesTF: UITextField!
    @IBOutlet weak var extraChargesTypeTF: UITextField!
    @IBOutlet weak var discountTypeTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    @IBOutlet weak var chargeDescriptionTF: UITextField!
    @IBOutlet weak var paaymentIntentRefTF: UITextField!
    @IBOutlet weak var collectBillingAddressSwitch: UISwitch!
    @IBOutlet weak var preAuthorizeSwitch: UISwitch!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var sendByEmailSwitch: UISwitch!
    @IBOutlet weak var sendBySMSSwitch: UISwitch!
    
    private var inputs: [UITextField]!
    private var contentInset: UIEdgeInsets?
    var viewModel: EInvoiceDetailsViewModel!
    var eInvoiceItems: [GDEInvoiceItem] = [GDEInvoiceItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemsTableView.register(EInvoiceItemTableViewCell.self)
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
//        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    func setupViews() {

        if viewModel.isUpdate {
            createBtn.setTitle("Update EInvoice", for: .normal)
        }
        inputs = [subtTotalTF, grandTotalTF, extraChargesTF, extraChargesTypeTF, discountTF, discountTypeTF, chargeDescriptionTF, paaymentIntentRefTF]
        inputs.forEach {
            $0.delegate = self
            $0.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: "DONE")
        }
    }
    
    @objc func keyboardButtonAction(_ sender: UIBarButtonItem) {
        unfocusFields()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            unfocusFields()
            return true
        }
    
    private func unfocusFields() {
        
        inputs.forEach {
            $0.endEditing(true)
        }
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func creteEInvoiceTapped(_ sender: Any) {
        
        let eInvoicePaymentDetails = viewModel.paymentIntentDetails
        let eInvoiceDetails = GDEInvoiceDetails(collectCustomersBillingShippingAddress: collectBillingAddressSwitch.isOn, preAuthorizeAmount: preAuthorizeSwitch.isOn, subTotal: Double(subtTotalTF.text ?? "") ?? 0, grandTotal:  Double(grandTotalTF.text ?? "") ?? 0, extraCharges:  Double(extraChargesTF.text ?? "") ?? 0, extraChargesType: extraChargesTypeTF.text, chargeDescription: chargeDescriptionTF.text, paymentIntentReference: paaymentIntentRefTF.text, invoiceDiscount: Double(discountTF.text ?? "") ?? 0, invoiceDiscountType: discountTypeTF.text, eInvoiceItems: eInvoiceItems)
        eInvoicePaymentDetails.eInvoiceDetails = eInvoiceDetails
        
        if viewModel.isUpdate {
            GeideaPaymentAPI.updatePaymentIntent(with: eInvoicePaymentDetails, completion:{ response, error in
                GeideaPaymentAPI.shared.returnAction(response,error)
            })
        } else {
            GeideaPaymentAPI.createPaymentIntent(with: eInvoicePaymentDetails, completion:{ response, error in
                GeideaPaymentAPI.shared.returnAction(response,error)
                if let res = response { 
                    if let email = self.viewModel.paymentIntentDetails.email, !email.isEmpty && self.sendByEmailSwitch.isOn{
                        GeideaPaymentAPI.sendLinkByEmail(with: res.paymentIntent?.paymentIntentId ?? "", completion:{  response, error in
                            print(res.paymentIntent?.paymentIntentId)
                        })
                    }
                    if let phoneNumber = self.viewModel.paymentIntentDetails.phoneNumber, !phoneNumber.isEmpty && self.sendBySMSSwitch.isOn {
                        GeideaPaymentAPI.sendLinkBySMS(with: res.paymentIntent?.paymentIntentId ?? "", completion:{  response, error in
                            print(res.paymentIntent?.paymentIntentId)
                        })
                    }
                }
               
                
            })
        }
        
    }
    @IBAction func AddItemTapped(_ sender: Any) {
        let vc = PaymentIntentFactory.makeEInvoiceItemViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
        
    }
    
    func getModelString(eInvoiceItem: GDEInvoiceItem) -> String? {
        
        do {
            let data = try JSONEncoder().encode(eInvoiceItem)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any?] else {
                throw NSError()
            }
            let decimalData = try JSONSerialization.decimalData(withJSONObject: dictionary, options: .prettyPrinted)
            let stringJson = String(decoding: decimalData, as: UTF8.self)
            return stringJson
            
        } catch  {
//            shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.PARSING_ERROR))
        }
        return nil
        
    }
    
  
}

extension EInvoiceDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eInvoiceItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EInvoiceItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let eInvoiceItem =  itemForIndexPath(indexPath)
        
        cell.priceTF.text = "\(eInvoiceItem?.price ?? 0)"
        cell.quantityTF.text = "\(eInvoiceItem?.quantity ?? 0)"
        cell.descriptionTF.text = eInvoiceItem?.itemDescription
        
        cell.selectionStyle = .none
        return cell
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> GDEInvoiceItem? {
        return eInvoiceItems[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let safeInvoiceItem =  itemForIndexPath(indexPath) else { return  }
        
        displayAlert(title: "EInvoice Item", message: getModelString(eInvoiceItem: safeInvoiceItem) ?? "")
        
    }
    
    func displayAlert(title: String, message: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true)
        }
        
    }
}

extension EInvoiceDetailsViewController:  EInvoiceItemControllerDelegate {
    func didAddItem(item: GDEInvoiceItem) {
        self.eInvoiceItems.append(item)
        var grandTotal = 0.0
        for item in eInvoiceItems {
            grandTotal += item.total
        }
        grandTotalTF.text = String(grandTotal)
        itemsTableView.reloadData()
    }
    
    
    
}

