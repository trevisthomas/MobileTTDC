//
//  MovieReviewSubView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/3/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class MovieReviewSubView: UIView {

    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    var post : Post? {
        didSet{
            registerForStyleUpdates()
            
            creatorLabel.text = post!.creator?.login
            print(creatorLabel.text!)
            if let rating = post!.reviewRating {
                starRatingView.starsVisible = CGFloat (rating)
            }
            
        }
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        creatorLabel.textColor = style.headerTextColor()
//        starRatingView.bgColor = style.postBackgroundColor()
    }

}
