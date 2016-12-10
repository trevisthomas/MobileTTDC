//
//  ConnectResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct ConnectResponse: Response {
    public let connectionId : String
    
    public init?(json: JSON) {
        connectionId = ("connectionId" <~~ json)!
    }
}

