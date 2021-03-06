//
//  LikeCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/18/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class LikeCommand : Command{
    open var token: String?
    open var connectionId: String?
    
    open var postId: String
    
    open func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token,
            "postId" ~~> self.postId,
            "connectionId" ~~> self.connectionId
            ])
    }
    
    init(postId : String){
        self.postId = postId
    }
    
}

