
public struct PersonResponse: Response {
    public let person: Person?
    public let message: String
    public init?(json: JSON) {
        person = "object" <~~ json //This makes me suspitious that this method may return different things depending on the command.
        message = ("message" <~~ json)!
        
    }
}
