//
//  UICollectionView+Utils.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/6/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func isScrollingNeeded() -> Bool {
        let scrollViewHeight = self.frame.size.height
        let scrollContentSizeHeight = self.contentSize.height
        
        return scrollViewHeight > scrollContentSizeHeight
        
    }
}
