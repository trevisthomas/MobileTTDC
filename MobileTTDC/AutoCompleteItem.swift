//
//  AutoCompleteItem.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct AutoCompleteItem : Decodable {
    let postId : String?
    let displayTitle : String
    
//    let conversationCount: Int
//    let totalReplyCount : Int
    
    public init?(json: JSON) {
        postId = ("postId" <~~ json)!
        displayTitle = ("displayTitle" <~~ json)!
//        conversationCount = ("conversationCount" <~~ json)!
//        totalReplyCount = ("totalReplyCount" <~~ json)!
    }
    
    public init (displayTitle: String){
        postId = nil
        self.displayTitle = displayTitle
    }
}