//
//  TopicResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/12/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct TopicResponse : Decodable {
    public let totalResults: Int
    public let list : [Post]

    public init?(json: JSON) {
        totalResults = ("results.totalResults" <~~ json)!
        
        list = [Post].fromJSONArray(("results.list" <~~ json)!)
    }
    
}