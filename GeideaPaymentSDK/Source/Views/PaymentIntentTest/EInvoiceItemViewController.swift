//
//  EInvoiceItemViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 11.11.2021.
//

import UIKit

class EInvoiceItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var discountTypeTF: UITextField!
    @IBOutlet weak var taxTF: UITextField!
    @IBOutlet weak var taxTypeTF: UITextField!
    @IBOutlet weak var skuTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var totalTF: UITextField!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var discountTF: UITextField!
    private var inputs: [UITextField]!
    var delegate: EInvoiceItemControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
//        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    }
    
    func setupViews() {
       
        inputs = [priceTF, quantityTF, discountTF,discountTypeTF, taxTF, taxTypeTF, totalTF, skuTF, descriptionTF]
        scrollView.keyboardDismissMode = .onDrag

        inputs.forEach {
            $0.delegate = self
            $0.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: "DONE")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow(notification:)),
                                             name: NSNotification.Name.UIKeyboardWillShow,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide(notification:)),
                                             name: NSNotification.Name.UIKeyboardWillHide,
                                             object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        
        dismiss(animated: false, completion: nil)
       
        let item = GDEInvoiceItem(total: Double(totalTF.text ?? "") ?? 0, tax:  Double(taxTF.text ?? "") ?? 0, taxType: taxTypeTF.text, price: Double(priceTF.text ?? "") ?? 0, quantity:  Int(quantityTF.text ?? "") ?? 0, itemDiscount: Double(discountTF.text ?? "") ?? 0, itemDiscountType: discountTypeTF.text, description: descriptionTF.text, sku: skuTF.text)

        delegate?.didAddItem(item: item)
         
    }
}
