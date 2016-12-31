//
//  CommentViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/9/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var threadSummaryLabel: UILabel!
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    var postBarButtonItem : UIBarButtonItem!
    
    var forum: Forum!
    var topicTitle: String!
    var topicDescription: String!
    
    
    fileprivate var validForPost: Bool = false {
        didSet{
            if validForPost {
                navigationItem.rightBarButtonItem = postBarButtonItem
            } else {
                navigationItem.rightBarButtonItem = closeBarButtonItem
            }
        }
    }
    
    var parentPost : Post? {
        didSet{
            threadTitle.text = parentPost?.title
            threadSummaryLabel.text = "Topic currently contains \(parentPost!.mass) replies in \(parentPost!.replyCount) conversations."
        }
    }
    
    var parentId : String?
    
    var hideCloseButton : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = getApplicationContext().commentStash {
            commentTextArea.setHtmlText(text)
        }
        
        //TODO: Trevis, util for extention?
//        let storyboard : UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
        
        let view = Bundle.main.loadNibNamed("AccessoryCommentView", owner: commentTextArea, options: nil)!.first as! AccessoryCommentView
        
        view.delegate = self
        view.defaultText = commentTextArea.text
        commentTextArea.inputAccessoryView = view
        
        
        postBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CommentViewController.decidePostTypeAndPost))
        
        registerForStyleUpdates()
        
//        threadTitle.inputAccessoryView = view
        
        
//        let vc = storyboard.instantiateViewControllerWithIdentifier("AccessoryCommentViewController") as! UIViewController
        
        //AccessoryCommentViewController
//        commentTextArea.inputAccessoryView = vc.view
//        commentTextArea.inputAccessoryViewController = vc

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        if (hideCloseButton) {
            closeBarButtonItem.isEnabled = false
        }
        
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        
        view.backgroundColor = style.underneath()
        
        threadTitle.textColor = style.headerTextColor()
        threadSummaryLabel.textColor = style.headerDetailTextColor()
        
        
        commentTextArea.textColor = style.entryTextColor()
        commentTextArea.backgroundColor = style.searchBackgroundColor()
        commentTextArea.tintColor = style.headerDetailTextColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if parentId != nil {
            fetchPost(parentId!)
        } else {
            threadTitle.text = topicTitle
            threadSummaryLabel.text = "You are creating the first conversation in a brand new topic."
            commentAccessoryBecomeFirstResponder()
            
        }
        validateForPost()
    }

    @IBAction func closeAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postComment(_ sender: AnyObject) {
        print(commentTextArea.text)
        postComment(parentId!, body: commentTextArea.text)
    }

    @IBAction func handleTap(_ recognizer:UITapGestureRecognizer) {
        commentAccessoryBecomeFirstResponder()
    }

    func commentAccessoryBecomeFirstResponder() {
        commentTextArea.becomeFirstResponder()
        let accessory = commentTextArea.inputAccessoryView as! AccessoryCommentView
        _ = accessory.becomeFirstResponder()
        commentTextArea.inputAccessoryView?.isHidden = false
    }
    
    func decidePostTypeAndPost(){
        if(parentId != nil) {
            postComment(parentId!, body: commentTextArea.text)
        }
        else {
            postComment(forum.tagId, topicTitle: topicTitle, topicDescription: topicDescription, body: commentTextArea.text)
        }
    }
    
    func decidePostTypeAndPreview(commentText: String){
        if(parentId != nil) {
            previewPost(parentId!, body: commentText)
        }
        else {
            previewPost(forum.tagId, topicTitle: topicTitle, topicDescription: topicDescription, body: commentText)
        }
    }
    
    func validateForPost(){
        if(parentId != nil && !commentTextArea.text.isEmpty) {
            validForPost = true
        } else if forum != nil && topicTitle != nil && topicDescription != nil && !commentTextArea.text.isEmpty{
            validForPost = true
        }
        else {
            validForPost = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        getApplicationContext().commentStash = commentTextArea.attributedText
    }
}

//extension CommentViewController {
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
////            invokeLater {
////                self.bottomConstraint.constant = keyboardFrame.height - 50 //Hm, is this 50px becaues of tabbar?!
////            }
//        }
//    }
//    
//    func keyboardDidHide(notification: NSNotification) {
////        invokeLater {
////            self.bottomConstraint.constant = 0.0
////        }
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
//    }
//
//}

extension CommentViewController {
    func fetchPost(_ postId: String){
        
        let cmd = PostCrudCommand(postId: postId)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message ?? "Failed but message was nil")
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            invokeLater{
                self.parentPost = (response?.post)!
//                self.commentTextArea.becomeFirstResponder()
                self.commentAccessoryBecomeFirstResponder()
            }
            
        };
    }
    
    func postComment(_ parentId: String, body: String){
        
        let cmd = PostCrudCommand(parentId: parentId, body: body)
        
        Network.performPostCrudCommand(cmd, completion: handleResponse)
        /*{
            (response, message) -> Void in
            
            
        };*/
    }
    
    func postComment(_ forumTagId: String, topicTitle: String, topicDescription: String, body: String){
        let cmd = PostCrudCommand(title: topicTitle, body: body, forumId: forumTagId, topicDescription: topicDescription)
        Network.performPostCrudCommand(cmd, completion: handleResponse)
    }
    
    func handleResponse(_ response: PostCrudResponse?, error: String?){
        guard response != nil else {
            self.presentAlert("Error", message: "Failed to create post.  Server error.")
            return
        }
        
        self.getApplicationContext().broadcaster.postAdded(post: (response?.post)!)
        self.getApplicationContext().reloadAllData()
        
        self.commentTextArea.attributedText = nil //So that it doesnt get stashed when you post!
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func previewPost(_ forumTagId: String, topicTitle: String, topicDescription: String, body: String){
        let cmd = PostCrudCommand(title: topicTitle, body: body, forumId: forumTagId, topicDescription: topicDescription, action: .PREVIEW)
        
        
        Network.performPostCrudCommand(cmd, completion: handlePreviewResponse)
    }
    
    func previewPost(_ parentId: String, body: String){
        let cmd = PostCrudCommand(parentId: parentId, body: body, action: .PREVIEW)
        
        Network.performPostCrudCommand(cmd, completion: handlePreviewResponse)
    }
    
    func handlePreviewResponse(_ response: PostCrudResponse?, error: String?){
        guard let post = response?.post else {
            self.presentAlert("Sorry", message: "Webservice request failed.")
            //commentTextArea.text = ""
            // What to do?
            return;
        }
        
        invokeLater{
            self.commentTextArea.setHtmlText(post.entry)
            self.refreshStyle()
            self.validateForPost()
            
            self.commentTextArea.inputAccessoryView?.isHidden = true
        }
    }

}

extension CommentViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText: String) {
        //commentTextArea.setHtmlText(commentText)
        decidePostTypeAndPreview(commentText: commentText)
        
        self.getApplicationContext().commentStash = commentText
        
        
        
    }
}
