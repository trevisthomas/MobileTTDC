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
        thumbnailName = Image.prependPath(("thumbnailName" <~~ json)!)
        name = Image.prependPath(("name" <~~ json)!)
        width = ("width" <~~ json)!
        height = ("height" <~~ json)!
    }
    
    private static func prependPath(imageFileName : String) -> String{
        return "http://ttdc.us/images/\(imageFileName)"
    }
}