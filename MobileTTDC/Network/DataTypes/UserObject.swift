//
//  UserObject.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/19/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct UserObject : Decodable {
    public let objectId: String
    public let name: String?
    public let value: String?
    public let desc: String?
    public let date: Date
    public let type: String
    public let url: String?
    public let template: Template?
    
    
    public init?(json: JSON) {
        objectId = ("objectId" <~~ json)!
        name = "name" <~~ json
        value = ("value" <~~ json)
        date = ("date" <~~ json)!
        type = ("type" <~~ json)!
        
        desc = ("description" <~~ json)
        url = ("url" <~~ json)
        template = ("template" <~~ json)
    }
  
}
