//
//  MoviePostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class MoviePostCollectionViewCell: UICollectionViewCell, PostEntryViewContract{

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
    
    
    var post : Post! {
        didSet{
            
            creatorButton.setTitle(post.creator.login, forState: UIControlState.Normal)
            reviewTextView.setHtmlText(post.entry)
            if let url = post.creator.image?.thumbnailName {
                movieCoverImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            dateCreatedButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), forState: .Normal)
            likesLabel.text = post.formatLikesString()
            
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
        
    }


    @IBAction func likeAction(sender: UIButton) {
    }
    
    @IBAction func commentAction(sender: UIButton) {
    }
    
    @IBAction func movieTitleAction(sender: UIButton) {
    }
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryConstraintLeft.constant, bottom: entryConstraintBottom.constant, right: entryConstraintRight.constant)
    }
    
    func postEntryTextView() -> UITextView {
        return reviewTextView
    }
}
