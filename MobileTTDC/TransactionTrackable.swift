//
//  Transaction.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/10/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

//This is me bolting on this TransactionId concept as an optional thing for commands and responses.
//Still not sure how i feel about this.  If this were a base class and not a protocol, i could just store the value here.
public protocol TransactionTrackable {
    
    var transactionId : Int? {get set}
    
}

public extension TransactionTrackable {
    var transactionId : Int? {
        get{
            return nil
        }
        set{
            assertionFailure()
        }
    }
}