import Foundation

public struct Person: Decodable{
    
    public let personId: String
    public let name: String?
    public let login: String
    public let image: Image?
    
    public init?(json: JSON) {
        personId = ("personId" <~~ json)!
        name = "name" <~~ json
        login = ("login" <~~ json)!
        image = "image" <~~ json
    }
    
    public init(){
        //No one
        personId = "111@111" 
        login = "Anonymous"
        image = nil
        name = "Blank"
    }
}
