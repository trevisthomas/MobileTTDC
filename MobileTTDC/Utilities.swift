//
//  Utilities.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class Utilities{
    
    public static let singleton : Utilities = Utilities()
    
    let simpleDateFormatter : NSDateFormatter
    let simpleDateTimeFormatter : NSDateFormatter
    
    init () {
        simpleDateFormatter = NSDateFormatter()
        simpleDateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        simpleDateFormatter.dateStyle = .MediumStyle
        simpleDateFormatter.timeStyle = .NoStyle
        
        simpleDateTimeFormatter = NSDateFormatter()
        simpleDateTimeFormatter.locale = NSLocale(localeIdentifier: "en_US")
        simpleDateTimeFormatter.dateFormat = "MMM d yyyy, H:mm a"
    }
    
    
    
    func simpleDateFormat(date: NSDate) -> String{
        return simpleDateFormatter.stringFromDate(date)
    }
    
    func simpleDateTimeFormat(date: NSDate) -> String{
        return simpleDateTimeFormatter.stringFromDate(date)
    }
    
}
