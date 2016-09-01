//
//  ConversationWithReplyViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationWithReplyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var replyTextView: UITextView!
    
    
    var postId: String! {
        didSet{
            loadPost(postId)
        }
    }
    var post : Post!
    
    var replyToPostId: String!
//        {
//        didSet{
////            commentAccessoryBecomeFirstResponder()
//            postId = replyToPostId
//        }
//    }
    
    private var replyPrototypeCell : ReplyCollectionViewCell!
    private var sectionHeaderPrototype : PostInHeaderCollectionReusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
        
        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
        
        let view = NSBundle.mainBundle().loadNibNamed("AccessoryCommentView", owner: replyTextView, options: nil).first as! AccessoryCommentView
        view.delegate = self
        replyTextView.inputAccessoryView = view
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ConversationWithReplyViewController.handleTapToResign(_:)))
//        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
//        replyToPostId = post.postId //When they just tap the text, reply to the conversation.
        commentAccessoryBecomeFirstResponder(post.postId)
    }
    
    func handleTapToResign(recognizer:UITapGestureRecognizer) {
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        accessory.resignFirstResponder()
        replyTextView.resignFirstResponder()
        
        scrollToBottom()
    }
  
    func commentAccessoryBecomeFirstResponder(postId: String) {
        replyTextView.becomeFirstResponder() //This causes the keyboard to open.
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        accessory.postId = postId
        
//        accessory.defaultText = replyTextView.attributedText
        
        accessory.becomeFirstResponder() //This puts the accessory view in focus.
        //NOTE:  The actual text view needs to have it's "editibale" flag set to false or else it will get focus after dismssing the keyboard+accessory.
        replyTextView.inputAccessoryView?.hidden = false
        
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
}

extension ConversationWithReplyViewController {
    
//    private func registerAndCreatePrototypeHeaderViewFromNib(withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
//        let nib = UINib(nibName: withName, bundle: nil)
//        self.collectionView!.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
//        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionReusableView
//    }
//    
//    private func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
//        let nib = UINib(nibName: withName, bundle: nil)
//        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
//        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
//    }
    
    private func loadPost(postId: String){
//        let cmd = PostCrudCommand(postId: postId)
//        Network.performPostCrudCommand(cmd){
//            (response, message) -> Void in
//            guard (response != nil) else {
//                print(message)
//                self.presentAlert("Error", message: "Failed to load post")
//                return;
//            }
//            
//            self.invokeLater{
//                self.post = response?.post
//                self.collectionView.reloadData()
//            }
//            
//        }
        
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId)
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message)
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            self.invokeLater{
                
                self.post = response?.list.first
                self.collectionView.reloadData()
                
//                self.collectionView.reloadData(){
//                    self.scrollToBottom()
//                }
                
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    //put your code which should be executed with a delay here
                    self.scrollToBottom()
                    
                }
                
                
                if self.replyToPostId != nil {
                    self.commentAccessoryBecomeFirstResponder(self.replyToPostId)
                }
              
            }
            
            
            
        }
    }
    
    override func viewDidLayoutSubviews() {
//        scrollToBottom()
    }
    

    
    private func scrollToBottom() {
//        let lastSectionIndex = (collectionView?.numberOfSections())! - 1
//        let lastItemIndex = (collectionView?.numberOfItemsInSection(lastSectionIndex))! - 1
//        let indexPath = NSIndexPath(forItem: lastItemIndex, inSection: lastSectionIndex)
        
        guard post != nil else {
            return
        }
        
        let row = (post.posts?.count)! - 1
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        
        
        collectionView!.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
    }
}


//extension UICollectionView {
//    func reloadData(completion: ()->()) {
//        UIView.animateWithDuration(0, animations: { self.reloadData() })
//        { _ in completion() }
//    }
//}

extension ConversationWithReplyViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        post.posts![indexPath.row]
        let height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        sectionHeaderPrototype.post = post
        let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
        
    }
}

extension ConversationWithReplyViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard post != nil else {
            return 0
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if post == nil {
            return 0;
        }
        
        guard let count = post.posts?.count else {
            return 0
        }
        return count
//        return (post.posts?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
        cell.post = post.posts![indexPath.row]
        cell.delegate = self
        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                               withReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW,
                                                                               forIndexPath: indexPath) as! PostInHeaderCollectionReusableView
        headerView.post = post
        
        return headerView
    }
    
    
}

extension ConversationWithReplyViewController : PostViewCellDelegate {
    func likePost(post: Post){
        //TODO: Something.
    }
    func viewComments(post: Post){
        //not used on reply
    }
    func commentOnPost(post: Post){
        self.commentAccessoryBecomeFirstResponder(post.postId)
    }
    
    func viewThread(post: Post) {
        print("Show the thread, here too. Dummy.")
    }
}

extension ConversationWithReplyViewController {
    func handleResponse(response: PostCrudResponse?, error: String?){
        guard response != nil else {
            self.presentAlert("Error", message: "Failed to create post.  Server error.")
            return
        }
        self.getApplicationContext().reloadAllData()
        
//        self.commentTextArea.attributedText = nil //So that it doesnt get stashed when you post!
        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.replyToPostId = nil  //sigh.  This is so that the first responder stays resigned!
//        self.view.becomeFirstResponder()
//        replyTextView.resignFirstResponder()
        loadPost(postId)
    }
}

extension ConversationWithReplyViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText commentText: String){
//        replyTextView.text = commentText
//        replyTextView.inputAccessoryView?.hidden = true
        
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        
        let cmd = PostCrudCommand(parentId: accessory.postId, body: commentText)
        
        Network.performPostCrudCommand(cmd, completion: handleResponse)
        
        replyTextView.resignFirstResponder()
        
    }
    
}