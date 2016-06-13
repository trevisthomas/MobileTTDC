//
//  TopicCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/12/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class TopicCommand : Command {
    
    //Grouped
    //Replies to a conversation
    public enum Type : String{
        case NESTED_THREAD_SUMMARY = "NESTED_THREAD_SUMMARY"
        case CONVERSATION = "CONVERSATION"
    }
    
    
    let type: Type
    let pageNumber: Int
    let postId: String
    public var token: String?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "type" ~~> self.type,
            "pageNumber" ~~> self.pageNumber,
            "token" ~~> self.token ?? nil,
            "postId" ~~> self.postId
            ])
    }
    
    public init( type: Type, postId: String, pageNumber: Int = 1){
        self.type = type
        self.pageNumber = pageNumber
        self.postId = postId
    }
}