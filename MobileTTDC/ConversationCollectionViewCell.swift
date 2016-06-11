//
//  ConversationCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationCollectionViewCell: UICollectionViewCell {
    
    var post : Post! {
        didSet{
            titleButton.setTitle(post.title, forState: UIControlState.Normal)
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), forState: .Normal)
            entryTextView.setHtmlText(post.entry)
        }
    }

    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func preferredHeight(width : CGFloat) -> CGFloat {
        
        self.invalidateIntrinsicContentSize()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        
        return 123
//        let sizeThatFits = labelForSizing.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
//        print("Size that fits \(sizeThatFits)")
//        return ceil(sizeThatFits.height) + 64 + 8 + 8 + 50
        
        
    }

}

