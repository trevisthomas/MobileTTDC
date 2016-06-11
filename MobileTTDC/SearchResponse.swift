//
//  SearchResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct SearchResponse : Decodable {
    //    public let person: String?
    //    public let postId: String
    public let totalResults: Int
    public let list : [Post]
    //
    public init?(json: JSON) {
        totalResults = ("results.totalResults" <~~ json)!
        //        person = "person" <~~ json
        //        token = ("token" <~~ json)!
        
        list = [Post].fromJSONArray(("results.list" <~~ json)!)
    }
    
}