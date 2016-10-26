//
//  Tag.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/26/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct Tag : Decodable{
    let tagId : String
    let type : String
    
    public init?(json: JSON) {
        tagId = ("tagId" <~~ json)!
        type = ("type" <~~ json)!
    }
}
