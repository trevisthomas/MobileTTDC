//
//  PostCrudCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/10/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

/*
 
 {
 "action":"CREATE",
 "body":"Conversation from json with new topic!",
 "forumId":"293C8189-44B9-41BD-BC75-F3DFD7CF670B",
 "title":"First Thread From Json",
 "topicDescription":"TTDC is going mobile. For that we need JSON.  I am the body of the first topic created this way.",
 "token":"rO0ABXN..."
 }
 /* Read a single post Request */
 
 {
 "postId":"977E6A57-AE9E-461C-BFD6-2D4D337F6C69",
 "action":"READ"
 }
 
 */

public class PostCrudCommand : Command {
    
    public enum Action : String{
        case CREATE = "CREATE"
        case READ = "READ"
    }
    
    
    let action: Action
    let postId: String?
    let parentId: String?
    let body: String?
    let forumId: String?
    let title: String?
    let topicDescription: String?
    let loadRootAncestor: Bool?
    
    public var token: String?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token ?? nil,
            "action" ~~> self.action,
            "postId" ~~> self.postId ?? nil,
            
            "title" ~~> self.title ?? nil,
            "parentId" ~~> self.parentId ?? nil,
            "body" ~~> self.body ?? nil,
            "forumId" ~~> self.forumId ?? nil,
            "topicDescription" ~~> self.topicDescription ?? nil,
            "loadRootAncestor" ~~> self.loadRootAncestor ?? nil
            ])
    }
    
    convenience public init( postId: String){
        self.init(postId: postId, loadRootAncestor: false)
    }
    
    public init( postId: String, loadRootAncestor: Bool ){
        self.action = Action.READ
        self.postId = postId
        self.parentId = nil
        self.body = nil
        self.forumId = nil
        self.title = nil
        self.topicDescription = nil
        self.loadRootAncestor = loadRootAncestor
    }
    
    public init ( parentId: String, body: String) {
        self.action = Action.CREATE
        self.postId = nil
        self.parentId = parentId
        self.body = body
        self.forumId = nil
        self.title = nil
        self.topicDescription = nil
        self.loadRootAncestor = nil
    }
    
    public init ( title: String, body: String, forumId: String, topicDescription: String) {
        self.action = Action.CREATE
        self.postId = nil
        self.parentId = nil
        self.body = body
        self.forumId = forumId
        self.title = title
        self.topicDescription = topicDescription
        self.loadRootAncestor = nil
        
    }
    
    
}