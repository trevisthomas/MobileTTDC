import Foundation

public struct LoginResponse: Response {
    public let person: Person?
    public let token: String
    
    public init?(json: JSON) {
        person = "person" <~~ json
        token = ("token" <~~ json)!
    }
    
}