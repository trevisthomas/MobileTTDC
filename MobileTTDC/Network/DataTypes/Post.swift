//
//  Post.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class Post : Decodable{
    let postId : String
    let date : Date
    let title : String
    let creator: Person?
    //    let latestEntry: Entry
    let entry: String
    let replyCount : UInt
    let posts : [Post]?
    let mass : UInt
    let threadId: String?
    let threadPost: Bool //For conversations this is true.
    let parentPostId: String!
    let parentPostCreator: String!
    let parentPostCreatorId: String!
    let tagAssociations:[TagAssociation]?
    let isMovie : Bool
    let isReview : Bool
    let image : Image?
    let reviewRating: Float?
    let isRootPost : Bool
    
    var size : (Float, Float)? // :-)  Is this bad?
    
    public required init?(json: JSON) {
        postId = ("postId" <~~ json) ?? ""
        date = ("date" <~~ json)!
        
        //Trevis. It took you a long time to figure out that movie review's attached to a movie didnt have their title populated! This was during the work to add root posts and movie reviews so there were some server chagnges that were not quite vetted
        //        if let t : String = ("title" <~~ json) {
        //            title = t
        //        } else {
        //            title = "nil"
        //        }
        
        title = ("title" <~~ json) ?? "nil"
        
        creator = ("creator" <~~ json)
        //        latestEntry = ("latestEntry" <~~ json)!
        entry = ("entry" <~~ json)!
        replyCount = ("replyCount" <~~ json)!
        posts = ("posts" <~~ json)
        mass = ("mass" <~~ json)!
        //        thread = ("thread" <~~ json)!
        //        threadId = ("thread.postId" <~~ json)
        
        //If the thread hapens to be on the object, us it.  If not use the one from the minified json response
        if let thread : Post = ("thread" <~~ json) {
            threadId = thread.postId
        } else {
            threadId = ("threadId" <~~ json)
        }
        threadPost = ("threadPost" <~~ json)! //isThreadPost
        parentPostCreator = ("parentPostCreator" <~~ json)
        parentPostCreatorId = ("parentPostCreatorId" <~~ json)
        parentPostId = ("parentPostId" <~~ json)
        tagAssociations = ("tagAssociations" <~~ json)
        isMovie = ("movie" <~~ json)!
        isReview = ("review" <~~ json)!
        image = ("image" <~~ json)
        reviewRating = ("reviewRating" <~~ json) //Trevis, you added this field to post for mobile!
        isRootPost = ("rootPost" <~~ json)!
        
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
    
    func isLikedByMe(personId : String) -> Bool {
        guard tagAssociations != nil else {
            return false
        }
        
        for tagAss in tagAssociations! {
            if(tagAss.tag.type == "LIKE"){
                if tagAss.creator.personId == personId {
                    return true
                }
            }
        }
        return false
    }
    
}


