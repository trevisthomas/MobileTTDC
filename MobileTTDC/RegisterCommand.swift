//
//  RegisterCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/16/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class RegisterCommand : Command{
    
    let deviceToken: String
    public var token: String?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token,
            "deviceToken" ~~> self.deviceToken
            ])
    }
    
    public init( deviceToken: String){
        self.deviceToken = deviceToken
    }
    
}