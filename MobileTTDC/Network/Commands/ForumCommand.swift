//
//  ForumListRequest.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class ForumCommand : Command{
    public var connectionId: String?

    open var token: String?
    open var action: String
    
    open func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token,
            "action" ~~> self.action
        ])
    }
    
    init(){
        self.action = "LOAD_FORUMS"
    }

}
