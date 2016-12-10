//
//  TopicCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/12/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class TopicCommand : Command {
    public var connectionId: String?

    
    //Grouped
    //Replies to a conversation
    public enum TopicType : String{
        case NESTED_THREAD_SUMMARY = "NESTED_THREAD_SUMMARY"
        case CONVERSATION = "CONVERSATION"
    }
    
    
    let type: TopicType
    let pageNumber: Int  //Page -1 makes ttdc find the page containing your post!
    let postId: String
    let pageSize: Int
    open var token: String?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "type" ~~> self.type,
            "pageNumber" ~~> self.pageNumber,
            "token" ~~> (self.token ?? nil),
            "postId" ~~> self.postId,
            "pageSize" ~~> self.pageSize
            ])
    }
    
    public init( type: TopicType, postId: String, pageNumber: Int = 1, pageSize: Int = 10){
        self.type = type
        self.pageNumber = pageNumber
        self.postId = postId
        self.pageSize = pageSize
    }
}
