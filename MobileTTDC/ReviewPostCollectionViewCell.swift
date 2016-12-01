//
//  ReviewPostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ReviewPostCollectionViewCell: UICollectionViewCell, PostEntryViewContract, BroadcastEventConsumer {
    
    @IBOutlet weak var movieTitleButton: UIButton!
    @IBOutlet weak var movieCoverImageView: UIImageView!
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var dateCreatedButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var numCommentsButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var entryConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var entryConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var entryConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var entryConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    var delegate : PostViewCellDelegate?
    
    var post : Post! {
        didSet{
            
            movieTitleButton.setTitle(post.title, for: UIControlState())
            creatorButton.setTitle(post.creator!.login, for: UIControlState())
            reviewTextView.setHtmlText(post.entry)
            if let url = post.image?.name {
                movieCoverImageView.downloadedFrom(link: url, contentMode: .scaleAspectFit)
            }
            dateCreatedButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), for: UIControlState())
            
            likesLabel.text = formatLikesString(post: post)
            configureLikeButton(post: post, button: likeButton)
            
            if post.mass == 0 {
                numCommentsButton.isHidden = true
            }
            else if post.mass == 1 {
                //                    inReplyPrefixLabel.text = "view"
                numCommentsButton.setTitle("one comment", for: UIControlState())
            } else {
                //                    inReplyPrefixLabel.text = "view"
                numCommentsButton.setTitle("\(post.mass) comments", for: UIControlState())
            }

            
            if let rating = post.reviewRating {
                starRatingView.isHidden = false
                starRatingView.starsVisible = CGFloat(rating)
            } else {
                starRatingView.isHidden = true
            }
            configureLikeButton(post: post, button: likeButton)
            refreshStyle() //For some reason those attributed guys get unhappy if you dont do this
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        registerForStyleUpdates() //causes refreshStyle to be called
        getApplicationContext().broadcaster.subscribe(consumer: self)
    }
    
    
    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        likeButton.setTitleColor(appStyle.postFooterTextColor(), for: UIControlState())
        dateCreatedButton.setTitleColor(appStyle.headerDetailTextColor(), for: UIControlState())
        likesLabel.textColor = appStyle.postFooterTextColor()
        backgroundColor = appStyle.postBackgroundColor()
        
        
        
        creatorButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
        reviewTextView.textColor = appStyle.entryTextColor()
        //        entryTextView.backgroundColor = appStyle.postReplyBackgroundColor()
        reviewTextView.backgroundColor = UIColor.clear
        reviewTextView.tintColor = appStyle.headerDetailTextColor()
        
        movieTitleButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
        
    }
    
    
    @IBAction func likeAction(_ sender: UIButton) {
        delegate?.likePost(post)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        delegate?.commentOnPost(post)
    }
    
    @IBAction func movieTitleAction(_ sender: UIButton) {
        delegate?.viewThread(post)
    }
    
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryConstraintLeft.constant, bottom: entryConstraintBottom.constant, right: entryConstraintRight.constant)
    }
    
    func postEntryTextView() -> UITextView? {
        return reviewTextView
    }
    
//    override func onPostUpdated(post: Post) {
//        if self.post.postId == post.postId {
//            self.post = post
//        }
//    }

    func onPostUpdated(post: Post) {
        self.post = post
    }
}
