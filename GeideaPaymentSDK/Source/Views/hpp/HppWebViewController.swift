//
//  HppWebViewController.swift
//  GeideaPaymentSDK
//
//  Created by Virender on 12/06/24.
//

import UIKit
import WebKit
class HppWebViewController: BaseViewController {
    var authParams: InitiateAuthenticateParams!
    @IBOutlet weak var webView: WKWebView!
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        AuthenticateManager.createSession(with: authParams) {[weak self] (response, request, error) in
            guard let self else {
                return
            }
            guard let sessionId = response?.session.id else {
                GeideaPaymentAPI.shared.returnAction(nil,error)
                return
            }
            let urlPath = HppPaymentRouter.session(sessionId: sessionId).fullpath()
            self.configureWebView(url: urlPath)
        }
        // Do any additional setup after loading the view.
    }
    
    private func configureWebView(url: String) {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorX = UIScreen.screenWidth / 2
        let activityIndicatorY = UIScreen.screenHeight / 2
        activityIndicator.center = CGPoint(x: activityIndicatorX, y: activityIndicatorY)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func cancelTapped(_ sender: Any) {
        GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withCancelCode(responseMessage: "Cancelled", code: "010", detailedResponseCode: "001", detailedResponseMessage: "PAYMENT_CANCELLED".localized, orderId: ""));
    }
    
}
extension HppWebViewController:  WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "print" {
            
        } else {
            print("Some other message sent from web page...")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let host = navigationAction.request.url?.absoluteString else { return }
        checkHost(host: host)
    }
    
    func checkHost(host: String) {
        print(host)
        if host.contains(Constants.sdkReturnURL)  {
            let params = parseQueryString(urlString: host)
            if params["responseCode"] == "000", params["responseMessage"] == "Success", let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []), let paymentResponse = try? JSONDecoder().decode(PaymentResponse.self, from: jsonData) {
                GeideaPaymentAPI.shared.returnAction(paymentResponse, nil)
            } else {
                let code = params["responseCode"] ?? ""
                let msg = params["responseMessage"] ?? ""
                GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withErrorCode(error: msg, code: code, detailedResponseMessage: msg, orderId:""))
            }
        }
    }
    
    func parseQueryString(urlString: String) -> [String: String] {
        var queryParameters: [String: String] = [:]
        if let urlComponents = URLComponents(string: urlString), let queryItems = urlComponents.queryItems {
            for item in queryItems {
                queryParameters[item.name] = item.value
            }
        }
        return queryParameters
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

@objc public class PaymentResponse: NSObject, Codable {
    public let orderId: String
    public let responseCode: String
    public let responseMessage: String
    public let sessionId: String
    
    @objc public init(orderId: String, responseCode: String, responseMessage: String, sessionId: String) {
        self.orderId = orderId
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.sessionId = sessionId
    }
}
