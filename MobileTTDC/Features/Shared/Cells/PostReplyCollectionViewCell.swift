//
//  PostReplyCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostReplyCollectionViewCell: BaseCollectionViewCell {
    
    override var post : Post! {
        didSet{
            creatorNameButton.setTitle(post.creator!.login, for: UIControlState())
            entryTextView.setHtmlText(post.entry)
            if let url = post.creator?.image?.thumbnailName {
                creatorImageView.downloadedFrom(link: url, contentMode: .scaleAspectFit)
            }
            dateButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), for: UIControlState())
            likesLabel.text = formatLikesString(post: post)
            
            configureLikeButton(post: post, button: likeButton)
            
            refreshStyle() //For some reason those attributed guys get unhappy if you dont do this
            
//            getApplicationContext().broadcaster.subscribe(consumer: self)
//            getApplicationContext().latestPostsModel.addListener(listener: self)
        }
    }
    
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var insetView: UIView!
    
    @IBOutlet weak var entryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryRightConstraint: NSLayoutConstraint!
//    var delegate : PostViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        entryTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        registerForStyleUpdates() //causes refreshStyle to be called
//        getApplicationContext().broadcaster.subscribe(consumer: self)
        
        connectCreatorImageView(creatorImageView: creatorImageView)
    }
    
    
    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        likeButton.setTitleColor(appStyle.postFooterTextColor(), for: UIControlState())
        replyButton.setTitleColor(appStyle.postFooterTextColor(), for: UIControlState())
        dateButton.setTitleColor(appStyle.headerDetailTextColor(), for: UIControlState())
        likesLabel.textColor = appStyle.postFooterTextColor()
        backgroundColor = appStyle.postBackgroundColor()
        
        
        creatorNameButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
        entryTextView.textColor = appStyle.entryTextColor()
//        entryTextView.backgroundColor = appStyle.postReplyBackgroundColor()
        entryTextView.backgroundColor = UIColor.clear
        entryTextView.tintColor = appStyle.headerDetailTextColor()
        
        insetView.backgroundColor = appStyle.underneath()
        
    }

    
    @IBAction func replyAction(_ sender: UIButton) {
        delegate?.commentOnPost(post)
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        delegate?.likePost(post)
    }
    
    override func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryTopConstraint.constant, left: entryLeftConstraint.constant, bottom: entryBottomConstraint.constant, right: entryRightConstraint.constant)
    }
    
    override func postEntryTextView() -> UITextView? {
        return entryTextView
    }
    
//    override func onPostUpdated(post: Post) {
//        if self.post.postId == post.postId {
//            self.post = post
//        }
//    }
    
    
//    func onPostUpdated(post: Post) {
//        self.post = post
//    }
//    
//    func getPostId() -> String? {
//        return self.post.postId
//    }
}



