//
//  MoviePostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class MoviePostCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var subRatingStackView: UIStackView!
    @IBOutlet weak var movieTitleButton: UIButton!
    @IBOutlet weak var movieCoverImageView: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    fileprivate let spacing : Int = 4
    fileprivate let starHeight : Int = 20
    @IBOutlet weak var starStackViewHeightConstraint: NSLayoutConstraint!
    
//    var delegate : PostViewCellDelegate?
    
    override var post : Post! {
        didSet{
            
            movieTitleButton.setTitle(post.title, for: UIControlState())
            if let url = post.image?.name {
                movieCoverImageView.downloadedFrom(link: url, contentMode: .scaleAspectFit)
            }
            
            for subview in subRatingStackView.subviews {
                subview.removeFromSuperview()
            }
            
            if let posts = post.posts {
                for p in posts{
                    //Trevis, after Swift 3 / iOS 10 conversion this stopped working.
//                    let review : MovieReviewSubView = MovieReviewSubView.fromNib()
                    
                    let nib = UINib(nibName: "MovieReviewSubView", bundle: nil)
                    let review = nib.instantiate(withOwner: nil, options: nil)[0] as! MovieReviewSubView
                    
                    review.post = p
                    review.heightAnchor.constraint(equalToConstant: CGFloat(starHeight)).isActive = true
                    review.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
                    subRatingStackView.addArrangedSubview(review)
                }
            
                subRatingStackView.spacing = CGFloat(spacing)
                subRatingStackView.translatesAutoresizingMaskIntoConstraints = false;
                
                let totalStarHeight = CGFloat((starHeight + spacing) * posts.count)
                starStackViewHeightConstraint.constant = totalStarHeight
            }
            
            
            refreshStyle() //For some reason those attributed guys get unhappy if you dont do this
            
//            getApplicationContext().broadcaster.subscribe(consumer: self)
//            getApplicationContext().latestPostsModel.addListener(listener: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForStyleUpdates() //causes refreshStyle to be called
//        getApplicationContext().broadcaster.subscribe(consumer: self)
        
        self.movieTitleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.movieTitleButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    
    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        movieTitleButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
        backgroundColor = appStyle.postBackgroundColor()
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
    
    override func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0) //Not used for movie summary
    }
    
    override func postEntryTextView() -> UITextView? {
        return nil
    }
    
    override func preferredHeight(_ width: CGFloat) -> CGFloat {
        
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
    
//    override func onPostUpdated(post: Post) {
//        guard let p = self.post else {
//            return
//        }
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

//extension MoviePostCollectionViewCell : BroadcastEventConsumer {
//    func onPostUpdated(post: Post) {
//        self.post = post
//    }
//    
//    func observingPostId(postId: String) -> Bool {
//        if post == nil {
//            return false
//        }
//        return self.post.postId == postId
//    }
//}

