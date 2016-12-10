//
//  Topic.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct Forum: Decodable {
    var value: String
    var tagId: String
    var mass: Int
    var displayValue: String
    
    public init?(json: JSON) {
        value = ("value" <~~ json)!
        displayValue = ("displayValue" <~~ json)!
        mass = ("mass" <~~ json)!
        tagId = ("tagId" <~~ json)!
    }
}