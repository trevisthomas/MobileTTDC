//
//  ConversationCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit


//TODO Find out where this is used
class ConversationCollectionViewCell: UICollectionViewCell {
    
    var post : Post! {
        didSet{
            titleButton.setTitle(post.title, forState: UIControlState.Normal)
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), forState: .Normal)
            entryTextView.setHtmlText(post.entry)
            if let url = post.creator.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            
            var replyTitle : String = ""
            switch post.replyCount {
            case 0:
                replyTitle = "no replies yet"
            case 1:
                replyTitle = "\(post.replyCount) reply"
                
            default:
                replyTitle = "\(post.replyCount) replies"
            }
            
            repliesButton.setTitle(replyTitle, forState: UIControlState.Normal)
//            print(replyTitle)
        }
    }

    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var repliesButton: UIButton!
    @IBOutlet weak var repliedPersonImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        entryTextView.delegate = self
//        entryTextView.shouldInteractWithURL()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectCell))
        
        entryTextView.addGestureRecognizer(gesture)
    }
    
    func selectCell(){
        let collectionView = self.superview as! UICollectionView
        let ip = collectionView.indexPathForCell(self)
        collectionView.delegate?.collectionView!(collectionView, didSelectItemAtIndexPath: ip!)
    }

    func preferredHeight(width : CGFloat) -> CGFloat {
        
//        self.invalidateIntrinsicContentSize()
//        
//        self.contentView.setNeedsLayout()
//        self.contentView.layoutIfNeeded()
        
        
//        return 123
//        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
//        print("Size that fits conversation cell \(sizeThatFits)")
//        return ceil(sizeThatFits.height) + 64 + 8 + 8 + 50
        
//        let sizeThatFits = self.contentView.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
//        
//        print("Size that fits \(sizeThatFits)")
//        return ceil(sizeThatFits.height)
        
        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width, CGFloat.max))
        let insets: UIEdgeInsets = entryTextView.textContainerInset;
        let heightThatFits = sizeThatFits.height + insets.top + insets.bottom + 60 + 24
        
        return heightThatFits
    }

}



