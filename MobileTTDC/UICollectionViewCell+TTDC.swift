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
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("\(URL.absoluteString)")
        return true;
    }
    
    
}

protocol PostEntryViewContract {
    func postEntryInsets() -> UIEdgeInsets
    func postEntryTextView() -> UITextView?
}


extension PostEntryViewContract {
    func preferredHeight(_ width : CGFloat) -> CGFloat {
        
        let entryInsets = postEntryInsets()
        
        let sizeThatFits = postEntryTextView()!.sizeThatFits(CGSize(width: width - entryInsets.left - entryInsets.right, height: CGFloat.greatestFiniteMagnitude))
        let insets: UIEdgeInsets = postEntryTextView()!.textContainerInset;
        let heightThatFits = sizeThatFits.height + insets.top + insets.bottom + entryInsets.top + entryInsets.bottom
        return heightThatFits
    }
    
//    func postEntryTextView() -> UITextView? {
//        return nil
//    }
}

extension PostEntryViewContract {
    
}
