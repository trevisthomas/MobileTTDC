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
    func navigationBackgroundColor() -> UIColor
    func navigationColor() -> UIColor
    func scrollBarStyle() -> UIScrollViewIndicatorStyle
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
    
    public func navigationBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    public func navigationColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    public func scrollBarStyle() -> UIScrollViewIndicatorStyle {
        return UIScrollViewIndicatorStyle.Black

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
//        return UIColor.blackColor()
        return UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
    }
    
    public func postReplyBackgroundColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    public func navigationBackgroundColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    public func navigationColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    public func scrollBarStyle() -> UIScrollViewIndicatorStyle {
        return UIScrollViewIndicatorStyle.White
    }
}

