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
    
    
    var parentPost : Post? {
        didSet{
            threadTitle.text = parentPost?.title
            threadSummaryLabel.text = "Topic currently contains \(parentPost!.mass) replies in \(parentPost!.replyCount) conversations."
        }
    }
    
    var parentId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextArea.text = ""
        
        //TODO: Trevis, util for extention?
//        let storyboard : UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
        
        let view = NSBundle.mainBundle().loadNibNamed("AccessoryCommentView", owner: commentTextArea, options: nil).first as! AccessoryCommentView
        
        view.delegate = self
        commentTextArea.inputAccessoryView = view
        
        
//        threadTitle.inputAccessoryView = view
        
        
//        let vc = storyboard.instantiateViewControllerWithIdentifier("AccessoryCommentViewController") as! UIViewController
        
        //AccessoryCommentViewController
//        commentTextArea.inputAccessoryView = vc.view
//        commentTextArea.inputAccessoryViewController = vc

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if parentPost == nil {
            fetchPost(parentId!)
        }
        
    }

    @IBAction func closeAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postComment(sender: AnyObject) {
        print(commentTextArea.text)
        postComment(parentId!, body: commentTextArea.text)
    }

    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        commentAccessoryBecomeFirstResponder()
    }

    func commentAccessoryBecomeFirstResponder() {
        commentTextArea.becomeFirstResponder()
        let accessory = commentTextArea.inputAccessoryView as! AccessoryCommentView
        accessory.becomeFirstResponder()
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
    func fetchPost(postId: String){
        
        let cmd = PostCrudCommand(postId: postId)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message)
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            self.invokeLater{
                self.parentPost = (response?.post)!
//                self.commentTextArea.becomeFirstResponder()
                self.commentAccessoryBecomeFirstResponder()
            }
            
        };
    }
    
    func postComment(parentId: String, body: String){
        
        let cmd = PostCrudCommand(parentId: parentId, body: body)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            guard response != nil else {
                self.presentAlert("Error", message: "Failed to create post.  Server error.")
                return
            }
            self.getApplicationContext().reloadLatestPosts()
            self.getApplicationContext().reloadLatestConversations()
//            self.performSegueWithIdentifier("Main", sender: self)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        };
    }
}

extension CommentViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText commentText: String) {
        commentTextArea.text = commentText
    }
}
