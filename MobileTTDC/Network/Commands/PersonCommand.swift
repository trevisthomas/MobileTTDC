//
//  PersonCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/20/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

//
//  PostCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

//{
//    "action": "LATEST_GROUPED",
//    "pageNumber": 1
//}

open class PersonCommand : Command {
    public var connectionId: String?
    
    
    public enum CommandType : String{
        case load = "LOAD"
        
    }
    
    
    let type: CommandType
    let personId: String
    open var token: String?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "type" ~~> self.type,
            "personId" ~~> self.personId,
            "token" ~~> self.token
            ])
    }
    
    public init(personId: String){
        self.type = .load
        self.personId = personId
    }
}
