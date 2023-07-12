//
//  SuccessViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 03/11/2020.
//

import UIKit

protocol RefundActionProtocol: AnyObject {
    func refundClicked()
}


class SuccessViewController: UIViewController {
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var json = ""
    var isRefundVisible = true
    weak var delegate: RefundActionProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = json
        if isRefundVisible {
            successLabel.text = "Success - Paid"
            refundButton.isHidden = false
        } else {
            successLabel.text = "Success - Refunded"
            refundButton.isHidden = true
        }
    }
    
    @IBAction func refundTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.refundClicked()
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        textView.setContentOffset(.zero, animated: false)
    }

    @IBAction func okTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
