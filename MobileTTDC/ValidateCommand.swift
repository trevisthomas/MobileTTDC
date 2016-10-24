//
//  ValidateCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/23/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class ValidateCommand : Command{
    public var token: String?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token
            ])
    }
    
    public init(){
        
    }
    
}
