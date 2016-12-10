//
//  Entry.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct Entry : Decodable {
    let summary : String?
    let body : String
    
    public init?(json: JSON) {
        summary = ("summary" <~~ json)
//        summary = "?"
        body = ("body" <~~ json)!
    }
}