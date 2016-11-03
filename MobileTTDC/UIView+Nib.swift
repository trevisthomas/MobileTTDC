//
//  UIView+Nib.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/3/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return NSBundle.mainBundle().loadNibNamed(String(T), owner: nil, options: nil)![0] as! T
    }
}
