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
        case LATEST_THREADS = "LATEST_THREADS"
    }

    
    let action: Action
    let pageNumber: Int
    let pageSize: Int?
    open var token: String?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "action" ~~> self.action,
            "pageNumber" ~~> self.pageNumber,
            "pageSize" ~~> self.pageSize,
            "token" ~~> (self.token ?? nil)
            ])
    }
    
    public init( action: Action, pageNumber: Int, pageSize: Int = 20){
        self.action = action
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
}
