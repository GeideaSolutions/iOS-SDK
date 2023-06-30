//
//  ShahryConfirmViewController.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 28.03.2022.
//

import UIKit

class ShahryConfirmViewController: BaseViewController {

    @IBOutlet weak var merchantNameValue: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var shahryIDTF: UITextField!
    
    @IBOutlet weak var totalAmountTitle: UILabel!
    @IBOutlet weak var confirmErrorLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: NSLayoutConstraint!
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var totalAmountValue: UILabel!
    @IBOutlet weak var whereFindLabel: UILabel!
    @IBOutlet weak var learnMoreLabel: UILabel!
    
    @IBOutlet weak var nextBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    var sharyIdTimer: Timer? = nil
    var bnplVM: BNPLViewModel?
    
    var viewModel: ShahryConfirmViewModel!
    
    init() {
        super.init(nibName: "ShahryConfirmViewController", bundle: Bundle(for: ShahryConfirmViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "ShahryConfirmViewController", bundle: Bundle(for: ShahryConfirmViewController.self))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePreferredSize()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupViews()
    }
    
    func handleTextFields() {
        shahryIDTF.delegate = self
        shahryIDTF.addDoneButtonToKeyboard(myAction: #selector(self.keyboardButtonAction(_:)),
                                              target: self,
                                              text: viewModel.doneTitle)
    }
    
    @objc
    func keyboardButtonAction(_ sender: UIBarButtonItem) {
        shahryIDTF.resignFirstResponder()
    }
    
    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width, height: view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
        preferredContentSize = contentView.systemLayoutSizeFitting(targetSize)
    }
    
    func setupViews() {
        if let bnpl = self.parent as? BNPLViewController {
            bnplVM = bnpl.viewModel
        }
        localizeStrings()

        setBranding()
        handleTextFields()
        
        shahryIDTF.autocorrectionType = .no
        shahryIDTF.spellCheckingType = .no
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.containerView.addGestureRecognizer(tap)
        
        merchantNameValue.text = GlobalConfig.shared.language == .arabic ? bnplVM?.selectPaymentVM.config?.merchantNameAr : bnplVM?.selectPaymentVM.config?.merchantName

        let whereFind = UITapGestureRecognizer(target: self, action: #selector(self.whereFindTapped))
        whereFindLabel.isUserInteractionEnabled = true
        whereFindLabel.addGestureRecognizer(whereFind)
        
        let learnMore = UITapGestureRecognizer(target: self, action: #selector(self.learnMoreTapped))
        learnMoreLabel.isUserInteractionEnabled = true
        learnMoreLabel.addGestureRecognizer(learnMore)
        
        if let bnpl = self.parent as? BNPLViewController {
            bnplVM = bnpl.viewModel
            totalAmountValue.text = String(format: "%.2f", bnplVM?.selectPaymentVM.amount.amount ?? "")
            currencyValue.text = bnplVM?.selectPaymentVM.amount.currency ?? ""
        }

        totalAmountValue.text = String(format: "%.2f", bnplVM?.selectPaymentVM.amount.amount ?? 0)
        currencyValue.text = bnplVM?.selectPaymentVM.amount.currency ?? ""
        
        validateButton()
        
        shahryIDTF.delegate = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        shahryIDTF.resignFirstResponder()
    }
    
    func setBranding() {
        cancelBtn.applyBrandingCancel(config: bnplVM?.selectPaymentVM.config)
        nextBtn.enabled(isEnabled: shahryIDTF.hasText, config: bnplVM?.selectPaymentVM.config)
    }
    override func localizeStrings() {
        merchantNameLabel.text = viewModel.merchantNameTitle
        totalAmountTitle.text = viewModel.totalAmountTitle
        nextBtn.setTitle(viewModel.nextTitle, for: .normal)
        cancelBtn.setTitle(viewModel.cancelTitle, for: .normal)
        shahryIDTF.placeholder = viewModel.shahryId
        whereFindLabel.text = viewModel.whereToFind
        learnMoreLabel.text = viewModel.learnMore
        
    }

    @objc func whereFindTapped(sender:UITapGestureRecognizer) {

        openUrl(urlString: "https://shahry.app/my-shahry-id")
    }
    
    @objc func learnMoreTapped(sender:UITapGestureRecognizer) {

        openUrl(urlString: "https://shahry.app/")
    }
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        if let bnpl = self.parent as? BNPLViewController {
            nextBtn.showLoading()
            bnpl.confirmNextTapped(with: shahryIDTF.text ?? "")
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        if let orderId = bnplVM?.selectPaymentVM.orderId, !orderId.isEmpty {
            logEvent("Cancelled By User \(orderId)")
            let cancelParams = CancelParams(orderId: orderId, reason: "CancelledByUser")
            CancelManager().cancel(with: cancelParams, completion: { cancelResponse, error  in
                self.viewModel.orderId = nil
            })
        }
        dismiss(animated: false)
    }

}

extension ShahryConfirmViewController: UITextFieldDelegate {

    
    fileprivate func areFieldsValid() -> Bool {
        var isValid = false
        if shahryIDTF.text?.count ?? 0 > 3 {
            isValid = true
        }
        
        
        if let validator = viewModel.customerIdValidator(customerId: shahryIDTF.text ?? "") {
            confirmErrorLabel.text = validator
            confirmErrorLabel.isHidden = false
            isValid = false
        } else {
            confirmErrorLabel.isHidden = true
        }
        
        return isValid
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }

    func validateButton() {
        nextBtn.enabled(isEnabled: shahryIDTF.text?.count ?? 0 > 3 && areFieldsValid(), config: bnplVM?.selectPaymentVM.config)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        sharyIdTimer?.invalidate()
        
        sharyIdTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.shahryIdCheck),
            userInfo: ["textField": textField],
            repeats: false)
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {

           shahryIDTF.resignFirstResponder()
           return true
       }
    
    @objc func shahryIdCheck() {
        _ = areFieldsValid()
        validateButton()
    }
    
   
}

