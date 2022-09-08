//
//  SuccessViewController.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by euvid on 03/11/2020.
//

import UIKit

class SuccessViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var json = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = json
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.setContentOffset(.zero, animated: false)
    }

    @IBAction func okTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
