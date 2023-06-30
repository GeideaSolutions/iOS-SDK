//
//  WebviewViewController.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 08/10/2020.
//

import UIKit
import WebKit

class WebviewViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var webViewContainer: UIView!
    
    var webView: WKWebView!
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var viewModel: WebViewViewModel!
    var payAction: ((AuthenticateParams?, AuthenticateResponse?, GDErrorResponse?)->())!
    var payTokenAction: ((PayTokenParams?, AuthenticateResponse?, GDErrorResponse?)->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
    
        webView.loadHTMLString( viewModel.authenticateResponse.htmlBodyContent, baseURL: nil)
    }
    
    private func show3DSSuccess() {
        guard let params = viewModel?.authenticateParams, let response = viewModel?.authenticateResponse else {
            return
        }
        payAction(params, response, nil)
    }
    
    private func showToken3DSSuccess() {
        guard let params = viewModel?.payTokenParams, let response = viewModel?.authenticateResponse else {
            return
        }
        var mutableParams = params
        mutableParams.threeDSecureId = viewModel.authenticateResponse.threeDSecureId
        payTokenAction(mutableParams, response, nil)
    }
    
    private func configureWebView() {
        let config = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        let scriptSource = """
        var meta = document.createElement('meta');
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=\(UIScreen.screenWidth) height=\(UIScreen.screenHeight)');
        document.getElementsByTagName('head')[0].appendChild(meta);
        """
        
        config.userContentController = contentController
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        let messageScript = WKUserScript(source: "window.print = function() { window.webkit.messageHandlers.print.postMessage('print') }", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        contentController.addUserScript(messageScript)
        config.userContentController = contentController
        webView = WKWebView(frame: webViewContainer.bounds, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webViewContainer.addSubview(webView)
        setupActivityIndicator()
    }
  
    func checkHost(host: String) {
        if host.contains(Constants.sdkReturnURL)  {
            if host.contains("code=000&msg=Success") {
                if viewModel.payTokenParams != nil {
                    showToken3DSSuccess()
                } else {
                    show3DSSuccess()
                }
               
            } else {
                var message = ""
                var code = ""
                if host.contains("code=") {
                    code = host.slice(from: "code=", to: "&msg") ?? ""
                    if host.contains("msg="), let range = host.range(of: "msg=") {
                        let msg = String(host[range.upperBound...].trimmingCharacters(in: .whitespaces))
                        let prettify = msg.replacingOccurrences(of: "%20", with: " ")
                        message = prettify
                        
                    }
                    
                    
                    if viewModel.payTokenParams != nil {
                        payTokenAction(nil, nil, GDErrorResponse().withErrorCode(error: message, code: code, detailedResponseMessage: message, orderId: viewModel.authenticateResponse.orderId))
                    } else {
                        payAction(nil, nil, GDErrorResponse().withErrorCode(error: message, code: code,  detailedResponseMessage: message, orderId: viewModel.authenticateResponse.orderId))
                    }
                    
                } else {
                
                    if viewModel.payTokenParams != nil {
                        payTokenAction(nil, nil, GDErrorResponse())
                    } else {
                        payAction(nil, nil, GDErrorResponse())
                    }
                }
                
            }
            
        }

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        print(webView.url?.absoluteString)
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorX = UIScreen.screenWidth / 2 - activityIndicator.frame.size.width / 2
        let activityIndicatorY = UIScreen.screenHeight / 2 - activityIndicator.frame.size.height / 2
        
        activityIndicator.center = CGPoint(x: activityIndicatorX, y: activityIndicatorY)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "print" {
        
        } else {
            print("Some other message sent from web page...")
        }
    }
    
}
