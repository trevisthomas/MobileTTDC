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
    
//    private NSDateFormatter
    
    public init?(json: JSON) {
        postId = ("postId" <~~ json)!
//        date = Decoder.decodeDate(key: "date", dateFormatter:)
//        let dateSecondsSince1970String : String = ("date" <~~ json)!
        
        let dateSecondsSince1970String : Int64 = ("date" <~~ json)!
        
        print(dateSecondsSince1970String)
        
        date = NSDate(timeIntervalSince1970: Double(dateSecondsSince1970String) / 1000)
//        name = ("name" <~~ json)!
    }
    
}