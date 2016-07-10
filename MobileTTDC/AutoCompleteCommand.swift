//
//  AutoCompleteCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class AutoCompleteCommand : Command{
    let query : String
    public var token: String?
    public var transactionId: Int?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "query" ~~> self.query,
            ])
    }
    
    public init( query: String, transactionId: Int){
        self.query = query
        self.transactionId = transactionId
    }
}
