import Foundation

enum PaymentRouterV6: BaseRouter {
    
    case intiate(authenticateParams: InitiateAuthenticateParams)
    case authenticatePayer(authenticateParams: AuthenticateParams)
    case initiateToken(initiateParams: InitiateAuthenticateTokenParams)
    case authenticateToken(authenticateParams: AuthenticateTokenPayerParams)
    
    
    var method: GDWSHTTPMethod {
        switch self {
        case  .intiate, .authenticatePayer, .initiateToken, .authenticateToken:
            return .POST
            
        }
    }
    
    var path: String {
        switch self {
        case .intiate:
            return "direct/authenticate/initiate"
        case .authenticatePayer:
            return "direct/authenticate/payer"
        case .initiateToken:
            return "direct/authenticate/initiate/token"
        case .authenticateToken:
            return "direct/authenticate/payer/token"
            
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .intiate(let authenticateParams):
            return authenticateParams.toJson()
        case .authenticatePayer(let authenticateParams):
            return authenticateParams.toJson()
        case .initiateToken(initiateParams: let initiateParams):
            return initiateParams.toJson()
        case .authenticateToken(authenticateParams: let authenticateParams):
            return authenticateParams.toJson()
            
        }
        
    }
    
    func fullpath() -> String {
        return APIHost.PGW.rawValue+BaseVersion.V6.rawValue + path
    }
}
