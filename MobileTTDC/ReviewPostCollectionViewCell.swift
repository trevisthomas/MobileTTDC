//
//  ReviewPostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ReviewPostCollectionViewCell: UICollectionViewCell, PostEntryViewContract{
    
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
            
            movieTitleButton.setTitle(post.title, forState: UIControlState.Normal)
            creatorButton.setTitle(post.creator.login, forState: UIControlState.Normal)
            reviewTextView.setHtmlText(post.entry)
            if let url = post.image?.name {
                movieCoverImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            dateCreatedButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), forState: .Normal)
            likesLabel.text = post.formatLikesString()
            
            if post.mass == 0 {
                numCommentsButton.hidden = true
            }
            else if post.mass == 1 {
                //                    inReplyPrefixLabel.text = "view"
                numCommentsButton.setTitle("one comment", forState: .Normal)
            } else {
                //                    inReplyPrefixLabel.text = "view"
                numCommentsButton.setTitle("\(post.mass) comments", forState: .Normal)
            }

            
            if let rating = post.reviewRating {
                starRatingView.hidden = false
                starRatingView.starsVisible = CGFloat(rating)
            } else {
                starRatingView.hidden = true
            }
            
            refreshStyle() //For some reason those attributed guys get unhappy if you dont do this
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        registerForStyleUpdates() //causes refreshStyle to be called
    }
    
    
    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        likeButton.setTitleColor(appStyle.postFooterTextColor(), forState: .Normal)
        dateCreatedButton.setTitleColor(appStyle.headerDetailTextColor(), forState: .Normal)
        likesLabel.textColor = appStyle.postFooterTextColor()
        backgroundColor = appStyle.postBackgroundColor()
        
        
        
        creatorButton.setTitleColor(appStyle.headerTextColor(), forState: .Normal)
        reviewTextView.textColor = appStyle.entryTextColor()
        //        entryTextView.backgroundColor = appStyle.postReplyBackgroundColor()
        reviewTextView.backgroundColor = UIColor.clearColor()
        reviewTextView.tintColor = appStyle.headerDetailTextColor()
        
        movieTitleButton.setTitleColor(appStyle.headerTextColor(), forState: .Normal)
        
    }
    
    
    @IBAction func likeAction(sender: UIButton) {
        delegate?.likePost(post)
    }
    
    @IBAction func commentAction(sender: UIButton) {
        delegate?.commentOnPost(post)
    }
    
    @IBAction func movieTitleAction(sender: UIButton) {
        delegate?.viewThread(post)
    }
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryConstraintLeft.constant, bottom: entryConstraintBottom.constant, right: entryConstraintRight.constant)
    }
    
    func postEntryTextView() -> UITextView? {
        return reviewTextView
    }

}
