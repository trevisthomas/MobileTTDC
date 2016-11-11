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
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    fileprivate let spacing : Int = 4
    fileprivate let starHeight : Int = 20
    @IBOutlet weak var starStackViewHeightConstraint: NSLayoutConstraint!
    
    var delegate : PostViewCellDelegate?
    
    var post : Post! {
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
                    let review : MovieReviewSubView = MovieReviewSubView.fromNib()
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForStyleUpdates() //causes refreshStyle to be called
    }
    
    
    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        movieTitleButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
    }


    @IBAction func likeAction(_ sender: UIButton) {
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
    }
    
    @IBAction func movieTitleAction(_ sender: UIButton) {
    }
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0) //Not used for movie summary
    }
    
    func postEntryTextView() -> UITextView? {
        return nil
    }
    
    func preferredHeight(_ width: CGFloat) -> CGFloat {
        
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
