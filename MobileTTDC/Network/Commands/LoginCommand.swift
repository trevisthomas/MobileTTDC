import Foundation

open class LoginCommand : Command{
    public var connectionId: String?

    
    let login: String
    let password: String
    open var token: String?
    
    open func toJSON() -> JSON? {
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
