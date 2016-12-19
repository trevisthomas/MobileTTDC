import Foundation

public struct Person: Decodable{
    
    public let personId: String
    public let name: String?
    public let login: String
    public let image: Image?
    public let webPageUserObjects : [UserObject]?
    public let administrator: Bool?
    public let privateAccessAccount: Bool?
    public let nws: Bool?
    public let hits: Int?
    public let bio: String?
    
    
    public init?(json: JSON) {
        personId = ("personId" <~~ json)!
        name = "name" <~~ json
        login = ("login" <~~ json)!
        image = "image" <~~ json
        webPageUserObjects = "webPageUserObjects" <~~ json
        
        administrator = "administrator" <~~ json
        nws = "nws" <~~ json
        privateAccessAccount = "privateAccessAccount" <~~ json
        hits = "hits" <~~ json
        bio = "bio" <~~ json
    }
    
    public init(){
        //No one
        personId = "111@111" 
        login = "Anonymous"
        image = nil
        name = "Blank"
        hits = nil
        administrator = nil
        privateAccessAccount = nil
        nws = nil
        webPageUserObjects = nil
        bio = nil
    }
}
