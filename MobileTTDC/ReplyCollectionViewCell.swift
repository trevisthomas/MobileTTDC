//
//  ReplyCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/12/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ReplyCollectionViewCell: UICollectionViewCell {
    
    var post : Post! {
        didSet{
            creatorNameButton.setTitle(post.creator.login, forState: UIControlState.Normal)
            
            if let url = post.creator.image?.thumbnailName {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
        }
    }

    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func preferredHeight(width : CGFloat) -> CGFloat {
        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
//        print("Size that fits \(sizeThatFits)")
        return ceil(sizeThatFits.height) + 12 + 4 + 4 + 16 + 8 + 50
        
    }

}
