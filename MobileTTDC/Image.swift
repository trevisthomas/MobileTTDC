//
//  Image.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct Image: Decodable{
    
    public let name: String
    public let thumbnailName: String
    public let width: Int
    public let height: Int
    
    public init?(json: JSON) {
        thumbnailName = ("thumbnailName" <~~ json)!
        name = ("name" <~~ json)!
        width = ("width" <~~ json)!
        height = ("height" <~~ json)!
    }
}