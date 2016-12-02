//
//  ServerEventListResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct ServerEventListResponse: Response {
    public let person : Person
    public let events : [ServerEvent]
    
    public init?(json: JSON) {
        person = ("person" <~~ json)!
        events = [ServerEvent].fromJSONArray(("events" <~~ json)!)
    }
}
