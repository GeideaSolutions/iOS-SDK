import Foundation

enum SessionRouterV2: BaseRouter {
    
    case session(sessionParams: SessionRequest)
    
    var method: GDWSHTTPMethod {
        return .POST;
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .session(let sessionRequest):
            return sessionRequest.toJson()
        }
    }
    
    var path: String {
        switch self {
        case .session:
            return "direct/session"
        }
    }
    
    func fullpath() -> String {
        return APIHost.PAYMENTINTENT.rawValue+BaseVersion.V2.rawValue + path
    }
}
