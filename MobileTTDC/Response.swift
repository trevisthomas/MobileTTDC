//
//  Decodable+TransactionId.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public protocol Response : Decodable {
    //Trevis: Seems like
    // var transactionId : Int {get set} should work but i couldnt figure out how to give that a default implementation
    func getTransactionId() -> Int?
    func setTransactionId(transactionId : Int)
}

extension Response {
    public func getTransactionId() -> Int? {
        return nil
    }
    
    public func setTransactionId(transactionId : Int){
        //Error?
    }
    
}