//
//  TagAssociation.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/26/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct TagAssociation : Decodable{
    let guid : String
    let date : Date
    let creator: Person
    let tag: Tag
    let post : Post?  //Trevis, you added this for like... is it really needed?
    
    public init?(json: JSON) {
        guid = ("guid" <~~ json)!
        date = ("date" <~~ json)!
        creator = ("creator" <~~ json)!
        tag = ("tag" <~~ json)!
        post = ("post" <~~ json)
    }
}
