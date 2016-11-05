//
//  UIView+Nib.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/3/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

//http://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
extension UIView {
    class func fromNib<T : UIView>() -> T {
        return NSBundle.mainBundle().loadNibNamed(String(T), owner: nil, options: nil)![0] as! T
    }
}
