//
//  BaseCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/6/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit


class BaseCollectionViewCell : UICollectionViewCell{
    var post : Post!
}

protocol PostEntryViewContract {
    func postEntryInsets() -> UIEdgeInsets
    func postEntryTextView() -> UITextView?
}


extension BaseCollectionViewCell : PostEntryViewContract {
    func postEntryInsets() -> UIEdgeInsets {
        abort()
    }
    func postEntryTextView() -> UITextView? {
        abort()
    }

    
    func preferredHeight(_ width : CGFloat) -> CGFloat {

        let entryInsets = postEntryInsets()

        let sizeThatFits = postEntryTextView()!.sizeThatFits(CGSize(width: width - entryInsets.left - entryInsets.right, height: CGFloat.greatestFiniteMagnitude))
        let insets: UIEdgeInsets = postEntryTextView()!.textContainerInset;
        let heightThatFits = sizeThatFits.height + insets.top + insets.bottom + entryInsets.top + entryInsets.bottom
        return heightThatFits
    }
}
