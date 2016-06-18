//
//  PostInHeaderCollectionReusableView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/18/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostInHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var entryTextView: UITextView!
    var post : Post! {
        didSet{
            titleButton.setTitle(post.title, forState: UIControlState.Normal)
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), forState: .Normal)
            entryTextView.setHtmlText(post.entry)
            if let url = post.creator.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func preferredHeight(width : CGFloat) -> CGFloat {
        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
//        print("Size that fits conversation cell \(sizeThatFits)")
        return ceil(sizeThatFits.height) + 64 + 8 + 8 + 50
        
    }
    
}
