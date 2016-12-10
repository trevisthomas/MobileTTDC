//
//  AutoComplete.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct AutoCompleteResponse: Response {
    public var transactionId: Int?
    let items : [AutoCompleteItem]
    
    public init?(json: JSON) {
        items = ("items" <~~ json)!
        transactionId = ("transactionId" <~~ json)
    }
}