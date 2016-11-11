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
    func statusBarStyle() -> UIStatusBarStyle
    func attributedTextLabelColor() -> String //Html colors becase for some fucking reason attributed text behaves differently depending on where it's used?
    func selectionColor() -> UIColor
    func searchBackgroundColor() -> UIColor
}

public struct AppStyleLight : AppStyle {
    
    public func headerTextColor() -> UIColor {
        return UIColor.black
    }
    
    public func headerDetailTextColor() -> UIColor {
        return UIColor.gray
    }
    
    public func entryTextColor() -> UIColor {
        return UIColor.black
    }
    
    public func tintColor() -> UIColor {
        return UIColor.blue
    }
    
    public func postFooterTextColor() -> UIColor {
        return UIColor.lightGray
    }
    
    public func postFooterDetailColor() -> UIColor {
        return UIColor.lightGray
    }
    
    public func postBackgroundColor() -> UIColor {
        return UIColor.white
//        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    }
    
    public func postReplyBackgroundColor() -> UIColor {
        return UIColor.white
    }
    
    public func navigationBackgroundColor() -> UIColor {
        return UIColor.white
    }
    
    public func navigationColor() -> UIColor {
        return UIColor.black
    }
    
    public func scrollBarStyle() -> UIScrollViewIndicatorStyle {
        return UIScrollViewIndicatorStyle.black

    }
    
    public func statusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    public func attributedTextLabelColor() -> String {
        return "black"
    }
    
    public func selectionColor() -> UIColor{
//        return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
//        return UIColor.redColor()
    }
    
    public func searchBackgroundColor() -> UIColor {
        return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    }
}

public struct AppStyleDark : AppStyle {
    
    public func headerTextColor() -> UIColor {
        return UIColor.white
    }
    
    public func headerDetailTextColor() -> UIColor {
        return UIColor.gray
    }
    
    public func entryTextColor() -> UIColor {
        return UIColor.white
    }
    
    public func tintColor() -> UIColor {
        return UIColor.orange
    }
    
    public func postFooterTextColor() -> UIColor {
        return UIColor.lightGray
    }
    
    public func postFooterDetailColor() -> UIColor {
        return UIColor.lightGray
    }
    
    public func postBackgroundColor() -> UIColor {
//        return UIColor.blackColor()
        return UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
    }
    
    public func postReplyBackgroundColor() -> UIColor {
        return UIColor.black
    }
    
    public func navigationBackgroundColor() -> UIColor {
        return  UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
    }
    
    public func navigationColor() -> UIColor {
        return UIColor.white
    }
    
    public func scrollBarStyle() -> UIScrollViewIndicatorStyle {
        return UIScrollViewIndicatorStyle.white
    }
    
    public func statusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    public func attributedTextLabelColor() -> String {
        return "white"
    }
    
    public func selectionColor() -> UIColor{
        return UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
    }
    
    public func searchBackgroundColor() -> UIColor {
        return postBackgroundColor()
    }
}

