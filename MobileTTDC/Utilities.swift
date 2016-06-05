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
    
    init () {
        simpleDateFormatter = NSDateFormatter()
        simpleDateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        simpleDateFormatter.dateStyle = .MediumStyle
        simpleDateFormatter.timeStyle = .NoStyle
    }
    
    func simpleDateFormat(date: NSDate) -> String{
        return simpleDateFormatter.stringFromDate(date)
    }
    
}