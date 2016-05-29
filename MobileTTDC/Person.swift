import Foundation

public struct Person: Decodable{
    
    public let personId: String
    public let name: String
    
    public init?(json: JSON) {
        personId = ("personId" <~~ json)!
        name = ("name" <~~ json)!
    }
}