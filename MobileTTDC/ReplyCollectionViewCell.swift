//
//  ReplyCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/12/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ReplyCollectionViewCell: UICollectionViewCell {
    
    var post : Post! {
        didSet{
            creatorNameButton.setTitle(post.creator.login, forState: UIControlState.Normal)
            entryTextView.setHtmlText(post.entry)
            if let url = post.creator.image?.thumbnailName {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
        }
    }

    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var entryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryRightConstraint: NSLayoutConstraint!
    var delegate : PostViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func replyAction(sender: UIButton) {
        delegate?.commentOnPost(post)
    }
    
    @IBAction func likeAction(sender: UIButton) {
        delegate?.likePost(post)
    }
    
    func preferredHeight(width : CGFloat) -> CGFloat {
//        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
//        print("Size that fits \(sizeThatFits)")
//        return ceil(sizeThatFits.height) + 12 + 4 + 4 + 16 + 8 + 50
        
        
        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width - entryLeftConstraint.constant - entryRightConstraint.constant, CGFloat.max))
        let insets: UIEdgeInsets = entryTextView.textContainerInset;
        let heightThatFits = sizeThatFits.height + insets.top + insets.bottom + entryTopConstraint.constant + entryBottomConstraint.constant
        
        return heightThatFits
        
    }

}
