//
//  PostCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostCollectionViewCell: BaseCollectionViewCell {
    
    
    @IBOutlet weak var entryConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var entryConstraintTop: NSLayoutConstraint!
    
    @IBOutlet weak var entryRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryLeftConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var parentPostCreatorButton: UIButton!
    
    @IBOutlet weak var creatorButton: UIButton!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var threadTitleButton: UIButton!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    override var post : Post!{
        didSet{
            
            dateButton.setTitle(Utilities.singleton.simpleDateTimeFormat(post.date), for: UIControlState())
            entryTextView.setHtmlText(post.entry)
            
            
            
            threadTitleButton.setTitle(post.title, for: UIControlState())
            
            if let url = post.creator?.image?.thumbnailName {
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
            
//            getApplicationContext().broadcaster.subscribe(consumer: self)
//            getApplicationContext().latestPostsModel.addListener(listener: self)
        }
    }
    
    
//    var delegate: PostViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        setupPostBroacastUpdates()
        entryTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        registerForStyleUpdates() //causes refreshStyle to be called
//        getApplicationContext().broadcaster.subscribe(consumer: self)
        
        self.threadTitleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.threadTitleButton.titleLabel?.minimumScaleFactor = 0.5
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCreator))
//        tap.delegate = self
//        creatorImageView.isUserInteractionEnabled = true
//        creatorImageView.addGestureRecognizer(tap)
        
        connectCreatorImageView(creatorImageView: creatorImageView)
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
    
    //This doesnt help for shit.  Hm.
    override func prepareForReuse() {
//        getApplicationContext().broadcaster.subscribe(consumer: self)
//        commentButton.setTitle(nil, for: .normal)
//        likeButton.setTitle(nil, for: .normal)
//        parentPostCreatorButton.setTitle(nil, for: .normal)
//        
//        creatorButton.setTitle(nil, for: .normal)
//        entryTextView.text = nil
//        dateButton.setTitle(nil, for: .normal)
//        threadTitleButton.setTitle(nil, for: .normal)
//        creatorImageView.image = nil
//        likesLabel.text = nil
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
    
    override func postEntryInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: entryConstraintTop.constant, left: entryLeftConstraint.constant, bottom: entryConstraintBottom.constant, right: entryRightConstraint.constant)
    }
    
    override func postEntryTextView() -> UITextView? {
        return entryTextView
    }
    
//    func handleTapOnCreator (_ sender: UIGestureRecognizer) {
//        delegate?.presentCreator(post.creator!.personId)
//    }
}

//extension PostCollectionViewCell : BroadcastEventConsumer {
//    func onPostUpdated(post: Post) {
//        self.post = post
//    }
//    
//    func observingPostId(postId: String) -> Bool {
//        if post == nil {
//            return false
//        }
//        return self.post.postId == postId
//    }
//}



