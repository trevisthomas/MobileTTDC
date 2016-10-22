//
//  UICollectionViewCell+TTDC.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell : UITextViewDelegate {
    //http://stackoverflow.com/questions/20541676/ios-uitextview-or-uilabel-with-clickable-links-to-actions
    public func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        print("\(URL.absoluteString)")
        return true;
    }
    
    
}

protocol PostEntryViewContract {
    func postEntryInsets() -> UIEdgeInsets
    func postEntryTextView() -> UITextView
}


extension PostEntryViewContract {
    func preferredHeight(width : CGFloat) -> CGFloat {
        
        let entryInsets = postEntryInsets()
        
        let sizeThatFits = postEntryTextView().sizeThatFits(CGSizeMake(width - entryInsets.left - entryInsets.right, CGFloat.max))
        let insets: UIEdgeInsets = postEntryTextView().textContainerInset;
        let heightThatFits = sizeThatFits.height + insets.top + insets.bottom + entryInsets.top + entryInsets.bottom
        return heightThatFits
    }
}
