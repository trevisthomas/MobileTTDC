//
//  ForumResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct ForumResponse: Response {
    public let list : [Forum]
    public init?(json: JSON) {
        list = [Forum].fromJSONArray(("list" <~~ json)!)
    }
}