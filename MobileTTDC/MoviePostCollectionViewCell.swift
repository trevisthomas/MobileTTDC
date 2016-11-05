//
//  MoviePostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class MoviePostCollectionViewCell: UICollectionViewCell, PostEntryViewContract{

    @IBOutlet weak var subRatingStackView: UIStackView!
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
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let spacing : Int = 4
    private let starHeight : Int = 20
    @IBOutlet weak var starStackViewHeightConstraint: NSLayoutConstraint!
    
    var delegate : PostViewCellDelegate?
    
    var post : Post! {
        didSet{
            
            movieTitleButton.setTitle(post.title, forState: UIControlState.Normal)
//            reviewTextView.setHtmlText(post.entry)
            if let url = post.image?.name {
                movieCoverImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
//            dateCreatedButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), forState: .Normal)
//            likesLabel.text = post.formatLikesString()
//            
//            let review = NSBundle.mainBundle().loadNibNamed("MovieReviewSubView", owner: self, options: nil)![0] as! MovieReviewSubView
            
            for subview in subRatingStackView.subviews {
                subview.removeFromSuperview()
            }
            
            if let posts = post.posts {
                for p in posts{
                    let review : MovieReviewSubView = MovieReviewSubView.fromNib()
                    review.post = p
                    review.heightAnchor.constraintEqualToConstant(CGFloat(starHeight)).active = true
                    review.widthAnchor.constraintEqualToConstant(self.frame.width).active = true
                    subRatingStackView.addArrangedSubview(review)
                }
            
                subRatingStackView.spacing = CGFloat(spacing)
                subRatingStackView.translatesAutoresizingMaskIntoConstraints = false;
                
                let totalStarHeight = CGFloat((starHeight + spacing) * posts.count)
                starStackViewHeightConstraint.constant = totalStarHeight
            }
            
            
            
            
            
            
//            review.post = post.posts![0]
//            subRatingStackView.addSubview(review)
            
            refreshStyle() //For some reason those attributed guys get unhappy if you dont do this
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        reviewTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        registerForStyleUpdates() //causes refreshStyle to be called
    }
    
    
    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        movieTitleButton.setTitleColor(appStyle.headerTextColor(), forState: .Normal)
//        likeButton.setTitleColor(appStyle.postFooterTextColor(), forState: .Normal)
//        dateCreatedButton.setTitleColor(appStyle.headerDetailTextColor(), forState: .Normal)
//        likesLabel.textColor = appStyle.postFooterTextColor()
//        backgroundColor = appStyle.postBackgroundColor()
//        
//        
//        creatorButton.setTitleColor(appStyle.headerTextColor(), forState: .Normal)
//        reviewTextView.textColor = appStyle.entryTextColor()
//        //        entryTextView.backgroundColor = appStyle.postReplyBackgroundColor()
//        reviewTextView.backgroundColor = UIColor.clearColor()
//        reviewTextView.tintColor = appStyle.headerDetailTextColor()
        
    }


    @IBAction func likeAction(sender: UIButton) {
    }
    
    @IBAction func commentAction(sender: UIButton) {
    }
    
    @IBAction func movieTitleAction(sender: UIButton) {
    }
    
    func postEntryInsets() -> UIEdgeInsets {
//        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryConstraintLeft.constant, bottom: entryConstraintBottom.constant, right: entryConstraintRight.constant)
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func postEntryTextView() -> UITextView? {
        return nil
    }
    
    func preferredHeight(width: CGFloat) -> CGFloat {
        
//        return frame.height
        if let posts = post.posts {
            
            let totalStarHeight = CGFloat((starHeight + spacing) * posts.count)
//            let minStarHeight = (totalStarHeight + topConstraint.constant  + bottomConstraint.constant)

            let minStarHeight = (totalStarHeight + topConstraint.constant )
            return minStarHeight < frame.height ? frame.height : minStarHeight
            
        }
        else {
            return frame.height
        }
    }
}
