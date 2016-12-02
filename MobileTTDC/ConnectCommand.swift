//
//  ConnectCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class ConnectCommand : Command {
    open var token: String?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "token" ~~> self.token,
            ])
    }
    
}
