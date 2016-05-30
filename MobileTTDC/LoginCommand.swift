import Foundation

public class LoginCommand : Command{
    
    let login: String
    let password: String
    public var token: String?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "username" ~~> self.login,
            "password" ~~> self.password
            ])
    }
    
    public init( login: String, password: String){
        self.login = login
        self.password = password
    }
    
}