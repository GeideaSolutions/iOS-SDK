//
//  QRPaymentDetailsViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 19.07.2021.
//

import UIKit
import GeideaPaymentSDK

class QRPaymentDetailsViewController: UIViewController {
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var currencyTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var expiryDateTF: UITextField!
    let datePicker =  UIDatePicker()
    
    var amount: Double = 0
    var currency: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var expiryDate: String?
    var callbackUrl: String?
    var showReceipt: Bool = false
    
    private var inputs: [UITextField]!
    
    init() {
        super.init(nibName: "QRPaymentDetailsViewController", bundle: Bundle(for:  QRPaymentDetailsViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        amountTF.text = String(amount)
        currencyTF.text = currency
        
        emailTF.text = email
        phoneNumberTF.text = phoneNumber
        nameTF.text = name
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        expiryDateTF.inputAccessoryView = toolbar
        expiryDateTF.inputView = datePicker
        expiryDateTF.text = expiryDate
        
        checkInputs()
    }
    
    func checkInputs() {
        
        inputs = [amountTF, currencyTF, emailTF, phoneNumberTF, nameTF, expiryDateTF]
       
        handleTextFields()
    }
    
    func handleTextFields() {
        (0..<inputs.count).forEach { index in
            let textField = inputs[index]
            textField.tag = index
            var buttonText = "DONE"
            textField.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: buttonText)
            
        }
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
            inputs[sender.tag].resignFirstResponder()
    }
    
    @objc func doneButtonPressed(sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  Locale(identifier: "en_us")
        expiryDateTF.text = dateFormatter.string(from: datePicker.date )
        self.view.endEditing(true)
        
    }
    
    @IBAction func payQRTapped(_ sender: Any) {
        guard let safeAmount = Double(amountTF.text ?? "") else {
            return
        }
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "EGP")
//        let customerDetails = GDPICustomer(withName: nameTF.text, andPhoneNumber: phoneNumberTF.text, andEmail: emailTF.text)
        let qrDetails = GDQRDetails(phoneNumber: phoneNumberTF.text, email: emailTF.text, name: nameTF.text, expiryDate: expiryDate)
        GeideaPaymentAPI.payQRWithGeideaForm(theAmount: amount, qrDetails: qrDetails, config: nil, showReceipt: showReceipt, orderId: nil, callbackUrl:  callbackUrl , viewController: self, completion:{ response, error in
            DispatchQueue.main.async {
               
                if let err = error {
                    if err.errors.isEmpty {
                        var message = ""
                        if err.responseCode.isEmpty {
                            message = "\n responseMessage: \(err.responseMessage)"
                            
                        } else if !err.orderId.isEmpty {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage) \n orderId: \(err.orderId)"
                        } else {
                            message = "\n responseCode: \(err.responseCode)  \n responseMessage: \(err.responseMessage) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)"
                        }
                        self.displayAlert(title: err.title, message: message)
                    } else {
                        self.displayAlert(title: err.title,  message:  "responseCode:  \(err.status) \n responseMessage: \(err.errors) \n detailedResponseCode: \(err.detailedResponseCode)  \n detailedResponseMessage: \(err.detailedResponseMessage)")
                    }
                } else {
                    guard let orderResponse = response else {
                        return
                    }
                    
                    if let orderString = GeideaPaymentAPI.getModelString(order: orderResponse) {
                        let vc = SuccessViewController()
                        vc.json = orderString
                        self.present(vc, animated: true, completion: nil)
                    }


                }
            }
        })
    
    }
    
    func displayAlert(title: String, message: String) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            self?.present(alert, animated: true)
        }
        
    }
    
}
