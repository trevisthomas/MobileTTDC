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
            entryTextView.setHtmlText(post.entry)
        
            
//            print("Lable size \(labelForSizing.intrinsicContentSize())")
            
//            contentWebView.frame = CGRectMake(0, 0,  CGFloat.max, 1);
//            contentWebView.sizeToFit()
            
            threadTitleButton.setTitle(post.title, forState: UIControlState.Normal)
            
            if let url = post.creator.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
            }
            
//            if post.mass == 1 {
//                viewCommentsButton.setTitle("1 Comment", forState: .Normal)
//            } else {
//                viewCommentsButton.setTitle("\(post.mass) Comments", forState: .Normal)
//            }
            
            
            creatorButton.setTitle("\(post.creator.login)", forState: .Normal)
            
//            viewCommentsButton.hidden = false
            inReplyStackView.hidden = false
            if post.threadPost {
                toParentCreatorStackView.hidden = true
                if post.mass == 0 {
                    inReplyStackView.hidden = true
                }
                else if post.mass == 1 {
                    inReplyPrefixLabel.text = "view"
                    viewCommentsButton.setTitle("conversation", forState: .Normal)
                } else {
                    inReplyPrefixLabel.text = "view"
                    viewCommentsButton.setTitle("\(post.mass) replies to conversation", forState: .Normal)
                }
                
            } else {
                toParentCreatorStackView.hidden = false
                parentPostCreatorButton.setTitle("\(post.parentPostCreator)", forState: .Normal)
                inReplyPrefixLabel.text = "in"
                viewCommentsButton.setTitle("response", forState: .Normal)
            }
            
//            contentWebView.setNeedsLayout()
//            contentWebView.layoutIfNeeded()
            
        
  //          print("scrollZize: \(contentWebView.scrollView.contentSize.height)")
            
            
//            contentWebView.scrollView.contentSize.height = 1
//            contentWebView.frame.height = 1
//            let heightString = contentWebView.stringByEvaluatingJavaScriptFromString("document.height")
//            print("heightString: \(heightString)")
            
            
            
            
//            contentWebView.delegate = self
            
//            var frame : CGRect = contentWebView.frame;
//            frame.size.height = 1;
//            contentWebView.frame = frame;
//            let fittingSize = contentWebView.sizeThatFits(CGSizeZero)
//            frame.size = fittingSize;
//            contentWebView.frame = frame;
            
            
//        print("fittingSize: \(fittingSize)")
//            print("Size of web that fits: \(contentWebView.sizeThatFits(CGSizeZero))")
//            print("Size of web: \(contentWebView.intrinsicContentSize())")
//            print("Size of btn: \(dateButton.intrinsicContentSize())")
        }
    }
    @IBOutlet weak var viewCommentsButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var parentPostCreatorButton: UIButton!

    @IBOutlet weak var inReplyPrefixLabel: UILabel!
    @IBOutlet weak var inReplyStackView: UIStackView!
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var toParentCreatorStackView: UIStackView!
//    @IBOutlet weak var labelForSizing: UILabel!
//    @IBOutlet weak var contentWebView: UIWebView! {
//        didSet{
//            contentWebView.delegate = self //For url behaviors initially at least.
//        }
//    }
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    
    
    var delegate: PostViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
     //   print("did finish ScrollHeight: \(contentWebView.scrollView.contentSize.height)")
    }
    
    
    @IBAction func viewCommentsAction(sender: UIButton) {
//        performSegueWithIdentifier("ConversationWithReplyView", sender: indexPath)
        delegate?.viewComments(post)
    }

    @IBAction func commentAction(sender: UIButton) {
        delegate?.commentOnPost(post)
    }
    
    @IBAction func likeAction(sender: UIButton) {
    }

}

extension FlatCollectionViewCell {
//    func preferredHeight(width : CGFloat) -> CGFloat {
//        
//        self.invalidateIntrinsicContentSize()
//        
//        self.contentView.setNeedsLayout()
//        self.contentView.layoutIfNeeded()
//        
//        let sizeThatFits = labelForSizing.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
//        
////        print("Size that fits too \(sizeThatFits2)")
//        
////        let sizeThatFits = entryTextView.layoutManager.usedRectForTextContainer(entryTextView.textContainer).size
//        print("Size that fits \(sizeThatFits)")
//        return ceil(sizeThatFits.height) + 64 + 8 + 8 + 50
//        
//        
//    }
    
    func preferredHeight(width : CGFloat) -> CGFloat {
        
        let sizeThatFits = entryTextView.sizeThatFits(CGSizeMake(width - 16, CGFloat.max))
        
        print("Size that fits flat cell \(sizeThatFits)")
        return ceil(sizeThatFits.height) + 64 + 8 + 8 + 50
    }
}


extension FlatCollectionViewCell : UITextViewDelegate {
    //http://stackoverflow.com/questions/20541676/ios-uitextview-or-uilabel-with-clickable-links-to-actions
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        print("\(URL.absoluteString)")
        return true;
    }
}


//** Move this extension!!


