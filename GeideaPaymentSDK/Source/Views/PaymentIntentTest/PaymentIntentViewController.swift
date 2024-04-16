//
//  PaymentIntentViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 17/02/2021.
//

import UIKit

class PaymentIntentViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eInvoiceSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var createView: UIStackView!
    
    @IBOutlet weak var eInvoiceView: UIStackView!
    @IBOutlet weak var typeStatusView: UIStackView!
    
    @IBOutlet weak var paymentIntentIDTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var currencyTF: UITextField!
    @IBOutlet weak var expiryDateTF: UITextField!
    @IBOutlet weak var activationDateTF: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusTF: UITextField!
    @IBOutlet weak var pymentIntentTypeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!

    @IBOutlet weak var phoneNumberCountryCode: UITextField!
    @IBOutlet weak var eInvoiceDetailsSwitch: UISwitch!
    
    var viewModel: PaymentIntentViewModel!
    private var inputs: [UITextField]!
    let expiryDatePicker =  UIDatePicker()
    let activationDatePicker =  UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eInvoiceSegmentedControl.selectedSegmentIndex = 0
        eInvoiceSegmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
        paymentIntentIDTF.text = viewModel.paymentIntentId
        statusTF.text = viewModel.status
        pymentIntentTypeTF.text = viewModel.type
        currencyTF.text = viewModel.currency
        createDatePicker()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        
        scrollView.keyboardDismissMode = .onDrag
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.contentView.addGestureRecognizer(tap)
        inputs = [paymentIntentIDTF, amountTF, currencyTF, nameTF, emailTF, phoneNumberTF]
        inputs.forEach {
            $0.delegate = self
            $0.addDoneButtonToKeyboard(myAction: #selector(self.handleTap(_:)),
                                              target: self,
                                              text: "DONE")
        }

    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        unfocusFields()
    }
    
    private func unfocusFields() {
        
        inputs.forEach {
            $0.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            unfocusFields()
            return true
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
        let info = notification.userInfo!
        let rect: CGRect = info[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height+100, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height+20;
        
        let activeField: UITextField? = inputs.first { $0.isFirstResponder }
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createDatePicker() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let activatetoolbar = UIToolbar()
        activatetoolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(expiryDonePressed))
        toolbar.setItems([doneButton], animated: true)
        
        let activateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(activationDonePressed))
        activatetoolbar.setItems([activateDoneButton], animated: true)
        
        
        expiryDateTF.text = dateFormatter.string(from: Date().adding(days: 30))
        expiryDatePicker.datePickerMode = .date
        expiryDateTF.inputAccessoryView = toolbar
        expiryDateTF.inputView = expiryDatePicker
        
        
        activationDateTF.text = ""
        activationDateTF.inputAccessoryView = activatetoolbar
        activationDatePicker.datePickerMode = .date
        activationDateTF.inputView = activationDatePicker
        
        if #available(iOS 13.4, *) {
            expiryDatePicker.preferredDatePickerStyle = .wheels
            activationDatePicker.preferredDatePickerStyle = .wheels
        }

    }
    
    @objc func activationDonePressed(sender: AnyObject) {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        activationDateTF.text = dateFormatter.string(from: activationDatePicker.date )
        self.view.endEditing(true)
        
    }
    
    @objc func expiryDonePressed(sender: AnyObject) {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        expiryDateTF.text = dateFormatter.string(from: expiryDatePicker.date )
    
        self.view.endEditing(true)
        
    }
    
    @IBAction func okTapped(_ sender: Any) {
        guard let safeAmount = Double(amountTF.text ?? "") else {
            return
        }
        let paymentIntentId = paymentIntentIDTF.text ?? ""
        var expiryDate: Date?
        var activationDate: Date?
        if let date = expiryDateTF.text, !date.isEmpty {
            expiryDate = dateFormatter.date(from: date)
        } else {
            expiryDate = nil
        }
        
        if let date = activationDateTF.text, !date.isEmpty {
            activationDate = dateFormatter.date(from: date)
        } else {
            activationDate = nil
        }
        
        let amount = GDAmount(amount: safeAmount, currency: currencyTF.text ?? "")
        let customer = GDPICustomer(phoneNumber: phoneNumberTF.text, andPhoneCountryCode: phoneNumberCountryCode.text ?? "", andEmail: emailTF.text ?? "", name: nameTF.text ?? "")
        let paymentIntentDetails = GDPaymentIntentDetails(withAmount: amount, andExpiryDate: expiryDate, andActivationDate: activationDate, andCustomer: customer,andEInvoiceDetails: nil, paymentIntentId: paymentIntentId, status: statusTF.text, type: pymentIntentTypeTF.text)
        
        self.scrollView.isHidden = false
        switch eInvoiceSegmentedControl.selectedSegmentIndex {
        case 0:
            
            if !eInvoiceDetailsSwitch.isOn  {
                GeideaPaymentAPI.createPaymentIntent(with: paymentIntentDetails, completion:{ response, error in
                    if let paymentIntent = response?.paymentIntent {
                        self.paymentIntentIDTF.text = paymentIntent.paymentIntentId
                        self.pymentIntentTypeTF.text = paymentIntent.type
                        self.statusTF.text = paymentIntent.status
                    }
                    GeideaPaymentAPI.shared.returnAction(response,error)
                })
            } else {
                let vc = PaymentIntentFactory.makeEInvoiceDetailsViewController()
                vc.viewModel = PaymentIntentFactory.makeEInvoiceDetailsViewModel(paymentIntentDetails: paymentIntentDetails)
                present(vc, animated: false)
            }
            
            break
        case 1:
            
            if paymentIntentId.isEmpty {
                let paymentIntentFilter = GDPaymentIntentFilter(take:50)
                GeideaPaymentAPI.getPaymentIntents(with: paymentIntentFilter, completion:{ response, error in
                                if let paymentIntents = response?.paymentIntents {
                                    self.viewModel.paymentIntents = paymentIntents
                                    
                                    let vc = PaymentIntentsViewController(nibName: String(describing: PaymentIntentsViewController.self), bundle:  Bundle(for: PaymentIntentsViewController.self))
                                    vc.paymentIntents = paymentIntents
                                    self.present(vc, animated: true, completion: nil)
                                }
                                
                            })
            } else {
                GeideaPaymentAPI.getPaymentIntent(with: paymentIntentId, completion:{ response, error in
                        GeideaPaymentAPI.shared.returnAction(response,error)
                })
            }
            break
        case 2:
            GeideaPaymentAPI.deletePaymentIntent(with: paymentIntentId, completion:{ response, error in
                let responseAsError = GDErrorResponse().withErrorCode(title: "\(paymentIntentId)", error: response?.detailedResponseCode ?? "", code: response?.responseMessage ?? "", detailedResponseMessage: response?.detailedResponseMessage ?? "")
                if error != nil {
                    GeideaPaymentAPI.shared.returnAction(response,error)
                } else {
                    GeideaPaymentAPI.shared.returnAction(response,responseAsError)
                }
               
            })
            break
        case 3:
            if !eInvoiceDetailsSwitch.isOn  {
                GeideaPaymentAPI.updatePaymentIntent(with: paymentIntentDetails, completion:{ response, error in
                    GeideaPaymentAPI.shared.returnAction(response,error)
                })
            } else {
                let vc = PaymentIntentFactory.makeEInvoiceDetailsViewController()
                vc.viewModel = PaymentIntentFactory.makeEInvoiceDetailsViewModel(paymentIntentDetails: paymentIntentDetails, isUpdate: true)
                present(vc, animated: false)
            }
            break
        default:
            break
        }
        
    }
    
    @IBAction func eInvoiceSegmentControllTapped(_ sender: Any) {
       
        switch eInvoiceSegmentedControl.selectedSegmentIndex {
        case 0:
            createView.isHidden = false
            eInvoiceView.isHidden = true
            typeStatusView.isHidden = true
            break
        case 1,2:
            eInvoiceView.isHidden = false
            typeStatusView.isHidden = true
            createView.isHidden = true
            break
        case 3:
            eInvoiceView.isHidden = false
            typeStatusView.isHidden = false
            createView.isHidden = false

            break
        default:
            break
        }
        
        
    }
    
}
