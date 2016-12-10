//
//  Command.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public protocol Command : Encodable, TransactionTrackable{
    var token : String?{get set}
    var connectionId : String?{get set}
}
