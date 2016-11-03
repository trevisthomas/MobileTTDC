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
    let tagAssociations:[TagAssociation]?
    let isMovie : Bool
    let isReview : Bool
    let image : Image?
    let reviewRating: Float?
    
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
        tagAssociations = ("tagAssociations" <~~ json)
        isMovie = ("movie" <~~ json)!
        isReview = ("review" <~~ json)!
        image = ("image" <~~ json)
        reviewRating = ("reviewRating" <~~ json) //Trevis, you added this field to post for mobile!
        
    }
    
    func formatLikesString() -> String {
        
        guard howManyLikes() > 0 else {
            return ""
        }
        var likes = ""
        for tagAss in tagAssociations! {
            if(tagAss.tag.type == "LIKE"){
                if (!likes.isEmpty){
                    likes.appendContentsOf(", ")
                }
                likes.appendContentsOf(tagAss.creator.login)
            }
        }
        return "Liked by: \(likes)"
    }
    
    func howManyLikes() -> Int {
        guard tagAssociations != nil else {
            return 0
        }
        var count = 0
        for tagAss in tagAssociations! {
            if(tagAss.tag.type == "LIKE"){
                count += 1
            }
        }
        return count
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
