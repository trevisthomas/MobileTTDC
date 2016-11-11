//
//  Utilities.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

open class Utilities{
    
    open static let singleton : Utilities = Utilities()
    
    let simpleDateFormatter : DateFormatter
    let simpleDateTimeFormatter : DateFormatter
    
    init () {
        simpleDateFormatter = DateFormatter()
        simpleDateFormatter.locale = Locale(identifier: "en_US")
        simpleDateFormatter.dateStyle = .medium
        simpleDateFormatter.timeStyle = .none
        
        simpleDateTimeFormatter = DateFormatter()
        simpleDateTimeFormatter.locale = Locale(identifier: "en_US")
        simpleDateTimeFormatter.dateFormat = "MMM d yyyy, H:mm a"
    }
    
    
    
    func simpleDateFormat(_ date: Date) -> String{
        return simpleDateFormatter.string(from: date)
    }
    
    func simpleDateTimeFormat(_ date: Date) -> String{
        return simpleDateTimeFormatter.string(from: date)
    }
    
}
