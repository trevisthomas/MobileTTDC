import Foundation

public class LoginCommand : Encodable{
    
    let login: String;
    let password: String;
    
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