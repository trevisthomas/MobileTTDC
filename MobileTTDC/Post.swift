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
    
    public init?(json: JSON) {
        postId = ("postId" <~~ json)!
        date = ("date" <~~ json)!
        title = ("title" <~~ json)!
        creator = ("creator" <~~ json)!
        latestEntry = ("latestEntry" <~~ json)!
        entry = ("entry" <~~ json)!
    }
    
}