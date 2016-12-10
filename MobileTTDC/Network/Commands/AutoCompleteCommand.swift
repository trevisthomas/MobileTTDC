//
//  AutoCompleteCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class AutoCompleteCommand : Command{
    public var connectionId: String?

    let query : String
    open var token: String?
    open var transactionId: Int?
    
    open func toJSON() -> JSON? {
        return jsonify([
            "query" ~~> self.query,
            ])
    }
    
    public init( query: String, transactionId: Int){
        self.query = query
        self.transactionId = transactionId
    }
}
