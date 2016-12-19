//
//  Template.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/19/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct Template : Decodable {
    public let templateId: String
    public let name: String?
    public let type: String?
    public let value: String?
    public let image: Image?
    
    public init?(json: JSON) {
        templateId = ("templateId" <~~ json)!
        name = "name" <~~ json
        type = "type" <~~ json
        value = "value" <~~ json
        image = "image" <~~ json
    }
}
