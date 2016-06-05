//
//  FlatCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class FlatCollectionViewCell: UICollectionViewCell {
    
    
    var post : Post!{
        didSet{
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), forState: .Normal)
            contentWebView.loadHTMLString(post.entry, baseURL: nil)
            
//            contentWebView.frame = CGRectMake(0, 0,  CGFloat.max, 1);
//            contentWebView.sizeToFit()
            
            threadTitleButton.setTitle(post.title, forState: UIControlState.Normal)
            
            if let url = post.creator.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
        }
    }

    @IBOutlet weak var contentWebView: UIWebView! {
        didSet{
            contentWebView.delegate = self //For url behaviors initially at least.
        }
    }
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}

