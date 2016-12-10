//
//  ConversationWithReplyViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationWithReplyViewController: CommonBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var replyTextView: UITextView!
    
    var postId: String! {
        didSet{
            print("ConversationWithReplyViewController is loading \(postId)")
//            loadPost(postId)
//            loadFirstPage()
        }
    }
//    var posts : [Post] = []
    
    var replyToPostId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

                replyTextView.keyboardAppearance = getApplicationContext().getCurrentStyle().keyboardAppearance()
        
        navigationItem.title = "Conversation"
        let accessoryCommentView = Bundle.main.loadNibNamed("AccessoryCommentView", owner: replyTextView, options: nil)!.first as! AccessoryCommentView
        accessoryCommentView.delegate = self
        replyTextView.inputAccessoryView = accessoryCommentView
        
//        accessoryCommentView.postTextView.keyboardAppearance = .dark
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ConversationWithReplyViewController.handleTapToResign(_:)))
        self.view.addGestureRecognizer(tap)
        registerForStyleUpdates()
        loadFirstPage()
        
        getApplicationContext().broadcaster.subscribeForPostAdd(consumer: self)
        getApplicationContext().broadcaster.subscribe(consumer: self)
        
    }
    
    override func refreshStyle() {
        
        let style = getApplicationContext().getCurrentStyle()
        collectionView.backgroundColor = style.postBackgroundColor()
        
        collectionView.indicatorStyle = style.scrollBarStyle()
        
        replyTextView.backgroundColor = style.postBackgroundColor()
        replyTextView.textColor = style.entryTextColor()
        
        view.backgroundColor = style.navigationBackgroundColor()
        
        //Below probably does nothing because of my Accessory view. Unfortunately setting globally doesnt work on text views.  (But does on TextField! WTF.  
        replyTextView.keyboardAppearance = style.keyboardAppearance()
        
//        let accessoryView = replyTextView.inputAccessoryView as! AccessoryCommentView
//        accessoryView.postTextView.keyboardAppearance = style.keyboardAppearance()
        
        

//        UITextView.appearance().keyboardAppearence = .Dark
//        replyTextView.keyboardAppearance = UIKeyboardAppearance.Dark
        
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func handleTap(_ recognizer:UITapGestureRecognizer) {
//        replyToPostId = post.postId //When they just tap the text, reply to the conversation.
        
        guard posts.count > 0 else {
            return
        }
        
        commentAccessoryBecomeFirstResponder(posts[0].postId)
    }
    
    func handleTapToResign(_ recognizer:UITapGestureRecognizer) {
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        _ = accessory.resignFirstResponder()
        replyTextView.resignFirstResponder()
        
        scrollToBottom()
    }
  
    func commentAccessoryBecomeFirstResponder(_ postId: String) {
        replyTextView.becomeFirstResponder() //This causes the keyboard to open.
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        accessory.postId = postId
        
//        accessory.defaultText = replyTextView.attributedText
        
        _ = accessory.becomeFirstResponder() //This puts the accessory view in focus.
        //NOTE:  The actual text view needs to have it's "editibale" flag set to false or else it will get focus after dismssing the keyboard+accessory.
        
//        accessory.postTextView.keyboardAppearance = .dark
//        accessory.postTextView.keyboardAppearance = getApplicationContext().getCurrentStyle().keyboardAppearance()
        
        replyTextView.inputAccessoryView?.isHidden = false
        
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }

//    override func commentOnPost(_ post: Post){
//        print("comment on : " + post.postId)
//    }
    
    override func allowHierarchy() -> Bool {
        return true
    }
   
}

extension ConversationWithReplyViewController {
    
    fileprivate func loadPost(_ postId: String, completion: @escaping ([Post]?) -> Void){
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId, pageNumber: -1, pageSize: 1)
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message!)
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            self.invokeLater{
                
                guard response?.list != nil else {
//                    return
                    completion([])
                    return
                }
                
                completion((response?.list)!.flattenPosts())
//                self.collectionView.reloadData()
//                
                
//                let time = DispatchTime(uptimeNanoseconds: DispatchTime.now()) + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
//                DispatchQueue.main.asyncAfter(deadline: time) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
    

    
    fileprivate func scrollToBottom() {
        
        guard posts.count > 0 else {
            return
        }
        
        let indexPath = IndexPath(row: posts.count - 1, section: 0)
        
        
        collectionView!.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
    }

}


//extension ConversationWithReplyViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return prototypeCellSize(post: posts[indexPath.row], allowHierarchy: true)
//    }
//}

//extension ConversationWithReplyViewController : UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return posts.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        return dequeueCell(posts[indexPath.row], indexPath: indexPath, allowHierarchy: true)
//    }
//    
//}


extension ConversationWithReplyViewController {
    func handleResponse(_ response: PostCrudResponse?, error: String?){
        guard response != nil else {
            self.presentAlert("Error", message: "Failed to create post.  Server error.")
            return
        }
        
        //Trevis!  This is a post being created!
        
        self.getApplicationContext().broadcaster.postAdded(post: (response?.post)!)
        self.getApplicationContext().reloadAllData()
        
//        self.commentTextArea.attributedText = nil //So that it doesnt get stashed when you post!
        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.replyToPostId = nil  //sigh.  This is so that the first responder stays resigned!
//        self.view.becomeFirstResponder()
//        replyTextView.resignFirstResponder()
        
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        accessory.postTextView.text = ""
        replyToPostId = nil //So that it w
//        loadPost(postId)
        
//        loadFirstPage() //Use broadcaster to handle these!
    }
}

extension ConversationWithReplyViewController : PostCollectionViewDelegate {
    func loadPosts(completion: @escaping ([Post]?) -> Void) {
        loadPost(postId, completion: completion)
    }
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void){
//        abort() //I guess?
    }
}

extension ConversationWithReplyViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText: String){
//        replyTextView.text = commentText
//        replyTextView.inputAccessoryView?.hidden = true
        
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        
        let cmd = PostCrudCommand(parentId: accessory.postId, body: commentText)
        
        Network.performPostCrudCommand(cmd, completion: handleResponse)
        
        replyTextView.resignFirstResponder()
        
    }
    
}

extension ConversationWithReplyViewController: BroadcastEventConsumer {
    func observingPostId(postId: String) -> Bool {
        return true
    }
    func onPostUpdated(post : Post) {
        guard let index = posts.indexOfPost(sourcePost: post) else {
            return
        }
        
        posts[index] = post
        let path = IndexPath(item: index, section: 0)
        if let cell = getCollectionView()?.cellForItem(at: path) as? BaseCollectionViewCell {
            cell.post = post
        }
        
    }
}

extension ConversationWithReplyViewController: BroadcastPostAddConsumer {
    func onPostAdded(post : Post) {
        //Find out if this post belongs in your hierarchy and respond acordingly.
        for p in posts {
            if(p.postId == post.parentPostId) {
                //TODO, let the user know that the data changed.  Dont auto refresh.
                loadFirstPage()
            }
        }
    }
    func reloadPosts(){
        loadFirstPage()
    }
}
