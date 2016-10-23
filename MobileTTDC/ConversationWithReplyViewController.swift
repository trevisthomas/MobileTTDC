//
//  ConversationWithReplyViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationWithReplyViewController: PostBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var replyTextView: UITextView!
    
    
    var postId: String! {
        didSet{
            print("ConversationWithReplyViewController is loading \(postId)")
            loadPost(postId)
        }
    }
    var posts : [Post] = []
    
    var replyToPostId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let view = NSBundle.mainBundle().loadNibNamed("AccessoryCommentView", owner: replyTextView, options: nil)!.first as! AccessoryCommentView
        view.delegate = self
        replyTextView.inputAccessoryView = view
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ConversationWithReplyViewController.handleTapToResign(_:)))
        self.view.addGestureRecognizer(tap)
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
//        replyToPostId = post.postId //When they just tap the text, reply to the conversation.
        
        guard posts.count > 0 else {
            return
        }
        
        commentAccessoryBecomeFirstResponder(posts[0].postId)
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

    override func commentOnPost(post: Post){
        print("comment on : " + post.postId)
    }
   
}

extension ConversationWithReplyViewController {
    
    private func loadPost(postId: String){
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId, pageNumber: -1, pageSize: 1)
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message)
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            self.invokeLater{
                
                guard response?.list != nil else {
                    return
                }
                
                self.posts = (response?.list)!.flattenPosts()
                self.collectionView.reloadData()
                
                
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
        
        guard posts.count > 0 else {
            return
        }
        
        let indexPath = NSIndexPath(forRow: posts.count - 1, inSection: 0)
        
        
        collectionView!.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
    }

}


extension ConversationWithReplyViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return prototypeCellSize(post: posts[indexPath.row], allowHierarchy: true)
    }
}

extension ConversationWithReplyViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return dequeueCell(posts[indexPath.row], indexPath: indexPath, allowHierarchy: true)
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
        
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        accessory.postTextView.text = ""
        replyToPostId = nil //So that it w
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
