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
}