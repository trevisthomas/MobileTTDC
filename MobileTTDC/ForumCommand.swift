//
//  ForumListRequest.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class ForumCommand : Command{
    public var token: String?
    public var action: String
    
    public func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token,
            "action" ~~> self.action
        ])
    }
    
    init(){
        self.action = "LOAD_FORUMS"
    }

}
