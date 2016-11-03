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
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
////        NSBundle.mainBundle().loadNibNamed("SomeView", owner: self, options: nil)
////        self.addSubview(self.view);    // adding the top level view to the view hierarchy
//    }

    
//    @IBOutlet var view:UIView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.frame = UIScreen.mainScreen().bounds
//        NSBundle.mainBundle().loadNibNamed("MovieReviewSubView", owner: self, options: nil)
////        self.view.frame = UIScreen.mainScreen().bounds
////        self.addSubview(self.view)
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var post : Post? {
        didSet{
            creatorLabel.text = post!.creator.login
            print(creatorLabel.text)
            if let rating = post!.reviewRating {
                starRatingView.starsVisible = CGFloat (rating)
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
