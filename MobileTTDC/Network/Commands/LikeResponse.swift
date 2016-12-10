//
//  LikeResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/18/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct LikeResponse: Response {
    
    public let post : Post?
    public let tagAssociation : TagAssociation
    public let remove : Bool
    //There are more flags...but they are weird
    
    public init?(json: JSON) {
        post = "post" <~~ json
        tagAssociation = ("associationPostTag" <~~ json)!
        remove = ("remove" <~~ json)!
    }
}

