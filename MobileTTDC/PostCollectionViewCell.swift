//
//  PostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell, PostEntryViewContract {
    
    
    @IBOutlet weak var entryConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var entryConstraintTop: NSLayoutConstraint!
    
    @IBOutlet weak var entryRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryLeftConstraint: NSLayoutConstraint!
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
//            inReplyStackView.hidden = false
//            if post.threadPost {
//                toParentCreatorStackView.hidden = true
//                if post.mass == 0 {
//                    inReplyStackView.hidden = true
//                }
//                else if post.mass == 1 {
//                    inReplyPrefixLabel.text = "view"
//                    viewCommentsButton.setTitle("conversation", forState: .Normal)
//                } else {
//                    inReplyPrefixLabel.text = "view"
//                    viewCommentsButton.setTitle("\(post.mass) replies to conversation", forState: .Normal)
//                }
//                
//            } else {
//                toParentCreatorStackView.hidden = false
//                parentPostCreatorButton.setTitle("\(post.parentPostCreator)", forState: .Normal)
//                inReplyPrefixLabel.text = "in"
//                viewCommentsButton.setTitle("response", forState: .Normal)
//            }
            

            parentPostCreatorButton.hidden = false
            if post.threadPost {
                if post.mass == 0 {
                    parentPostCreatorButton.hidden = true
                }
                else if post.mass == 1 {
//                    inReplyPrefixLabel.text = "view"
                    parentPostCreatorButton.setTitle("one comment", forState: .Normal)
                } else {
//                    inReplyPrefixLabel.text = "view"
                    parentPostCreatorButton.setTitle("\(post.mass) comments", forState: .Normal)
                }
                
            } else {
//                toParentCreatorStackView.hidden = false
//                parentPostCreatorButton.setTitle("\(post.parentPostCreator)", forState: .Normal)
//                inReplyPrefixLabel.text = "in"
                parentPostCreatorButton.setTitle("in response to \(post.parentPostCreator)", forState: .Normal)
            }
            
//            
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
            
            likesLabel.text = post.formatLikesString()
        }
    }
    @IBOutlet weak var viewCommentsButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var parentPostCreatorButton: UIButton!
    
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    var delegate: PostViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        entryTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    
    //
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
    
    @IBAction func threadTitleButton(sender: UIButton) {
        delegate?.viewThread(post)
    }
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryLeftConstraint.constant, bottom: entryConstraintBottom.constant, right: entryRightConstraint.constant)
    }
    
    func postEntryTextView() -> UITextView {
        return entryTextView
    }
}



