//
//  PostReplyCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostReplyCollectionViewCell: UICollectionViewCell, PostEntryViewContract {
    
    var post : Post! {
        didSet{
            creatorNameButton.setTitle(post.creator.login, forState: UIControlState.Normal)
            entryTextView.setHtmlText(post.entry)
            if let url = post.creator.image?.thumbnailName {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            dateButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), forState: .Normal)
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
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryTopConstraint.constant, left: entryLeftConstraint.constant, bottom: entryBottomConstraint.constant, right: entryRightConstraint.constant)
    }
    
    func postEntryTextView() -> UITextView {
        return entryTextView
    }
}
