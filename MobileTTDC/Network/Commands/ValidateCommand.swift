//
//  ValidateCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/23/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class ValidateCommand : Command{
    public var connectionId: String?

    open var token: String?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token
            ])
    }
    
    public init(){
        
    }
    
}
