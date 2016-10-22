//
//  Post.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct Post : Decodable{
    let postId : String
    let date : NSDate
    let title : String
    let creator: Person
    let latestEntry: Entry
    let entry: String
    let replyCount : UInt
    let posts : [Post]?
    let mass : UInt
    let threadId: String?
    let threadPost: Bool //For conversations this is true.
    let parentPostCreator: String!
    let parentPostCreatorId: String!
    
    public init?(json: JSON) {
        postId = ("postId" <~~ json)!
        date = ("date" <~~ json)!
        title = ("title" <~~ json)!
        creator = ("creator" <~~ json)!
        latestEntry = ("latestEntry" <~~ json)!
        entry = ("entry" <~~ json)!
        replyCount = ("replyCount" <~~ json)!
        posts = ("posts" <~~ json)
        mass = ("mass" <~~ json)!
//        thread = ("thread" <~~ json)!
        threadId = ("thread.postId" <~~ json)
        threadPost = ("threadPost" <~~ json)! //isThreadPost
        parentPostCreator = ("parentPostCreator" <~~ json)
        parentPostCreatorId = ("parentPostCreatorId" <~~ json)
        
    }
    
}

//Entending array so that it can flatten groupped posts
extension SequenceType where Generator.Element == Post {
    func flattenPosts() -> [Post]{
        var flatPosts : [Post] = []
        for post in self {
            flatPosts.append(post)
            guard (post.posts != nil) else {
                continue
            }
            for reply in post.posts! {
                flatPosts.append(reply)
            }
        }
        return flatPosts
    }
}
