//
//  AppColors.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/29/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

public protocol AppStyle {
    func headerTextColor() -> UIColor
    func headerDetailTextColor() -> UIColor
    func entryTextColor() -> UIColor
    func tintColor() -> UIColor
    func postFooterTextColor() -> UIColor
    func postFooterDetailColor() -> UIColor
    func postBackgroundColor() -> UIColor
    func postReplyBackgroundColor() -> UIColor
    
}

public struct AppStyleLight : AppStyle {
    
    public func headerTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    public func headerDetailTextColor() -> UIColor {
        return UIColor.grayColor()
    }
    
    public func entryTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    public func tintColor() -> UIColor {
        return UIColor.cyanColor()
    }
    
    public func postFooterTextColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    public func postFooterDetailColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    public func postBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    public func postReplyBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
}

public struct AppStyleDark : AppStyle {
    
    public func headerTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    public func headerDetailTextColor() -> UIColor {
        return UIColor.grayColor()
    }
    
    public func entryTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    public func tintColor() -> UIColor {
        return UIColor.orangeColor()
    }
    
    public func postFooterTextColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    public func postFooterDetailColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    public func postBackgroundColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    public func postReplyBackgroundColor() -> UIColor {
        return UIColor.blackColor()
    }
}

