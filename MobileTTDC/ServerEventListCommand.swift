//
//  ServerEventListCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class ServerEventListCommand : Command {
    public var token: String?
    open var connectionId: String
    
    open func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token,
            "connectionId" ~~> self.connectionId
            ])
    }
    
    init (connectionId: String){
        self.connectionId = connectionId
        
    }
}
