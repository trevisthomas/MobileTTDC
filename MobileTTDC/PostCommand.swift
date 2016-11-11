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

open class PostCommand : Command {
    
    public enum Action : String{
        case LATEST_GROUPED = "LATEST_GROUPED"
        case LATEST_FLAT = "LATEST_FLAT"
    }

    
    let action: Action
    let pageNumber: Int
    open var token: String?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "action" ~~> self.action,
            "pageNumber" ~~> self.pageNumber,
            "token" ~~> (self.token ?? nil)
            ])
    }
    
    public init( action: Action, pageNumber: Int){
        self.action = action
        self.pageNumber = pageNumber
    }
}
