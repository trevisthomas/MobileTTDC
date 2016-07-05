//
//  Command.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public protocol Command : Encodable{
    var token : String?{get set}
    
    //Trevis... you have got to figure out why you cant do this with a {get set} parameter :-(   Seems like an extention should be able to satisfy the {get set} but they dont
    func getTransactionId() -> Int?
    func setTransactionId(transactionId : Int)
}

extension Command {
    public func getTransactionId() -> Int? {
        return nil
    }
    
    public func setTransactionId(transactionId : Int){
        //Error?
    }
    
}