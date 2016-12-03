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
    
    public init?(json: JSON) {
        thumbnailName = Image.prependPath(("thumbnailName" <~~ json)!)
        name = Image.prependPath(("name" <~~ json)!)
    }
    
    fileprivate static func prependPath(_ imageFileName : String) -> String{
        return "\(Network.getHost())/images/\(imageFileName)"
    }
}
