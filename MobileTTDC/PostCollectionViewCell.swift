//
//  PostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell, PostEntryViewContract, BroadcastEventConsumer {
    
    
    @IBOutlet weak var entryConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var entryConstraintTop: NSLayoutConstraint!
    
    @IBOutlet weak var entryRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryLeftConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewCommentsButton: UIButton!  //Deprecated?
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var parentPostCreatorButton: UIButton!
    
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post : Post!{
        didSet{
            dateButton.setTitle(Utilities.singleton.simpleDateFormat(post.date), for: UIControlState())
            entryTextView.setHtmlText(post.entry)
            
            
            
            threadTitleButton.setTitle(post.title, for: UIControlState())
            
            if let url = post.creator?.image?.name {
                creatorImageView.downloadedFrom(link: url, contentMode: .scaleAspectFit)
            }
            
            
            creatorButton.setTitle("\(post.creator!.login)", for: UIControlState())
            parentPostCreatorButton.isHidden = false
            if post.threadPost {
                if post.mass == 0 {
                    parentPostCreatorButton.isHidden = true
                }
                else if post.mass == 1 {
                    parentPostCreatorButton.setTitle("one comment", for: UIControlState())
                } else {
                    parentPostCreatorButton.setTitle("\(post.mass) comments", for: UIControlState())
                }
                
            } else if let inResponseTo = post.parentPostCreator{
                parentPostCreatorButton.setTitle("in response to \(inResponseTo)", for: UIControlState())
            }
            
            
            likesLabel.text = formatLikesString(post: post)
            
            configureLikeButton(post: post, button: likeButton)
            
            refreshStyle()
        }
    }
    
    
    var delegate: PostViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        setupPostBroacastUpdates()
        entryTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        registerForStyleUpdates() //causes refreshStyle to be called
        getApplicationContext().broadcaster.subscribe(consumer: self)
    }
    

    override func refreshStyle() {
        let appStyle = getApplicationContext().getCurrentStyle()
        commentButton.setTitleColor(appStyle.postFooterTextColor(), for: UIControlState())
        likeButton.setTitleColor(appStyle.postFooterTextColor(), for: UIControlState())
        dateButton.setTitleColor(appStyle.headerDetailTextColor(), for: UIControlState())
        threadTitleButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
        creatorButton.setTitleColor(appStyle.headerTextColor(), for: UIControlState())
        likesLabel.textColor = appStyle.postFooterTextColor()
        backgroundColor = appStyle.postBackgroundColor()
        
        entryTextView.textColor = appStyle.entryTextColor()
        entryTextView.backgroundColor = appStyle.postBackgroundColor()
        entryTextView.tintColor = appStyle.headerDetailTextColor()
     
    }
    
    //
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //   print("did finish ScrollHeight: \(contentWebView.scrollView.contentSize.height)")
    }
    
    @IBAction func viewCommentsAction(_ sender: UIButton) {
        //        performSegueWithIdentifier("ConversationWithReplyView", sender: indexPath)
        delegate?.viewComments(post)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        delegate?.commentOnPost(post)
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        delegate?.likePost(post)
    }
    
    @IBAction func threadTitleButton(_ sender: UIButton) {
        delegate?.viewThread(post)
    }
    
    func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryLeftConstraint.constant, bottom: entryConstraintBottom.constant, right: entryRightConstraint.constant)
    }
    
    func postEntryTextView() -> UITextView? {
        return entryTextView
    }
    
    func onPostUpdated(post: Post) {
        self.post = post
    }
}




