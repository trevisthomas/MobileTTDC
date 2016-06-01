//
//  NSDate+Gloss.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

//In my mind this is an extension but since it's kind of extending a custom operator it's not a real extensios just an operator overload.

//extension NSDate {
    public func <~~ (key: String, json: JSON) -> NSDate? {
        let dateSecondsSince1970String : Int64 = (key <~~ json)!
        let date = NSDate(timeIntervalSince1970: Double(dateSecondsSince1970String) / 1000)
        return date
    }
//}