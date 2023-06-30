//
//  Request.swift
//  GeideaPaymentSampleSwift
//
//  Created by euvid on 13/10/2020.
//

import Foundation

class Request {
    
    var router: BaseRouter
    
    private var headers: [String: String]?
    private var request: URLRequest?
    
    init(router: BaseRouter) {
        self.router = router
    }
    
    func sendAsync(_ completionHandler: @escaping (Response?, GDErrorResponse?) -> Void) {
        do {
            guard let request = try self.router.asURLRequest() else { return }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let res = Response(data: data, response: response, error: error as NSError?)
                
           
                
                DispatchQueue.main.async {
                    var error = GDErrorResponse()
                    error = error.withResponse(response: res) ?? error
                    if error.isError {
                        completionHandler(nil,error)
                    } else {
                        completionHandler(res,nil)
                    }
                    
                }
            }
            task.resume()
        } catch {
            GeideaPaymentAPI.shared.returnAction(nil, GDErrorResponse().withError(error: SDKErrorConstants.NETWORK_ERROR))
        }
        self.logRequest()
    }
    
    // MARK: Private Helpers
    
    private func logRequest() {
        if GlobalConfig.shared.logLevel != .debug {
            return
        }
        
        do {
            let url = try self.router.asURLRequest()?.url?.absoluteString ?? ""
            log("******** REQUEST \(self.router.path) ********")
            log(" - URL:\t" + url)
            log(" - METHOD:\t" + (self.router.method.rawValue ))
            self.logHeaders()
            self.logBody()
            log("*************************\n")
        } catch {
            print("unexpected log error")
        }
        
    }
    
    private func logBody() {
        if GlobalConfig.shared.logLevel != .debug {
            return
        }
        
        do {
            let request = try self.router.asURLRequest()
            guard
                let body = request?.httpBody,
                let json = try? JSON.dataToJson(body)
            else { return }
            log(" - BODY:\n\(json)")
        } catch {
            print("unexpected log error")
        }
        
        
    }
    
    private func logHeaders() {
        if GlobalConfig.shared.logLevel != .debug {
            return
        }
        
        do {
            let headers = try self.router.asURLRequest()?.allHTTPHeaderFields
            guard let keys = headers?.keys  else {
                return
            }
            
            log(" - HEADERS: {")
            for key in keys {
                if let value = headers?[key] {
                    log("\t\t\(key): \(value)")
                }
            }
            
            log("}")
        } catch {
            print("unexpected log error")
        }
    }
    
}
