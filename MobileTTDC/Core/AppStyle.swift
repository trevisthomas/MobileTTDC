//
//  AppColors.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/29/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

//http://uicolor.xyz/#/hex-to-ui

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
    func navigationTintColor() -> UIColor
    func scrollBarStyle() -> UIScrollViewIndicatorStyle
    func statusBarStyle() -> UIStatusBarStyle
    func attributedTextLabelColor() -> String //Html colors becase for some fucking reason attributed text behaves differently depending on where it's used?
    func selectionColor() -> UIColor
    func searchBackgroundColor() -> UIColor
    func keyboardAppearance() -> UIKeyboardAppearance
    func starStroke() -> UIColor
    func starFill() -> UIColor
    
    func postFooterBackgroundColor() -> UIColor
    func tabbarBackgroundColor() -> UIColor
    
    func underneath() -> UIColor
}

extension UIColor {
    class func mutedPaper() -> UIColor {
        return UIColor(hexString: "#f4f4f4")
    }
    
    class func mutedWhiterPaper() -> UIColor {
        return UIColor(hexString: "#f9f9f9")
    }
    
    class func mutedSilk() -> UIColor {
        return UIColor(hexString: "#dcd0c0")
    }
    class func mutedPaleGold() -> UIColor {
        return UIColor(hexString: "#c0b283")
    }
    class func mutedCharcoal() -> UIColor {
        return UIColor(hexString: "#373737")
    }
    class var bloodRed : UIColor {
        return UIColor(hexString: "#6c2c2c")
    }
    
    class var blueness : UIColor {
        return UIColor(hexString: "#d6ddf4")
        //return UIColor(red:0.84, green:0.87, blue:0.96, alpha:1.0)
        //return UIColor.yellow
    }
    
    class var greyness : UIColor {
        return UIColor(hexString: "#dddddd")
    }
    
    class var blackish : UIColor {
        return UIColor(hexString: "#444f67")
    }
    
    class var palegrey : UIColor {
        return UIColor(hexString: "#f8f8f4")
    }
    
}

public struct AppStyleLight : AppStyle {
    
    public func headerTextColor() -> UIColor {
        return UIColor.black
    }
    
    public func headerDetailTextColor() -> UIColor {
        return UIColor.blackish
    }
    
    public func entryTextColor() -> UIColor {
        return UIColor.black
    }
    
    public func tintColor() -> UIColor {
        return UIColor.blackish
    }
    
    public func postFooterTextColor() -> UIColor {
        return UIColor.black
    }
    
    public func postFooterDetailColor() -> UIColor {
        return UIColor.black
    }
    
    public func postBackgroundColor() -> UIColor {
//        return UIColor.mutedPaper()
//        return UIColor.palegrey
        return UIColor.white
//        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    }
    
    public func postReplyBackgroundColor() -> UIColor {
        return UIColor.red //depreated?
    }
    
    public func navigationBackgroundColor() -> UIColor {
//        return UIColor.white
        return UIColor.blueness
    }
    
    public func tabbarBackgroundColor() -> UIColor {
        return UIColor.greyness
    }
    
    public func navigationColor() -> UIColor {
        return UIColor.black
    }
    
    public func navigationTintColor() -> UIColor {
        return UIColor.blackish
    }
    
    public func scrollBarStyle() -> UIScrollViewIndicatorStyle {
        return UIScrollViewIndicatorStyle.black

    }
    
    public func statusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    public func attributedTextLabelColor() -> String {
        return "#444f67"
    }
    
    public func selectionColor() -> UIColor{
//        return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
//        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
//        return UIColor.redColor()
        return UIColor.greyness
    }
    
    public func searchBackgroundColor() -> UIColor {
//        return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        return UIColor.palegrey
    }
    
    public func keyboardAppearance() -> UIKeyboardAppearance {
        return .light
    }
    
    public func underneath() -> UIColor {
//        return UIColor(hexString: "#f4f4f4")
//        return UIColor.white
        return UIColor.palegrey
    }
    
    public func postFooterBackgroundColor() -> UIColor {
        return UIColor.greyness
    }
    
    public func starStroke() -> UIColor {
        return UIColor.orange
    }
    
    public func starFill() -> UIColor {
        return UIColor.orange
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
//        return UIColor.orange
        return UIColor.bloodRed
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
        return UIColor.bloodRed
    }
    
    public func tabbarBackgroundColor() -> UIColor {
        return  UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
    }
    
    public func navigationColor() -> UIColor {
        return UIColor.white
    }
    
    public func navigationTintColor() -> UIColor {
        //return UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
        return UIColor.lightGray
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
    
    public func keyboardAppearance() -> UIKeyboardAppearance {
        return .dark
    }
    
    public func underneath() -> UIColor {
        return  UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
    }
    
    public func postFooterBackgroundColor() -> UIColor {
//        return UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
        return UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
    }
    
    public func starStroke() -> UIColor {
        return UIColor.orange
    }
    
    public func starFill() -> UIColor {
        return UIColor.orange
    }

}

