//
//  TopicCreationViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/16/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class TopicCreationViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chooseForumButton: UIButton!
    @IBOutlet weak var topicDescriptionTextView: UITextView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    var nextButtonItem : UIBarButtonItem!
    var closeButtonItem : UIBarButtonItem!
    
    private var validForNext : Bool = false {
        didSet{
            if validForNext {
                navigationItem.rightBarButtonItem = nextButtonItem
            } else {
                navigationItem.rightBarButtonItem = closeButtonItem
            }
            
        }
    }
    
    var topicTitle: String!
    private var forum : Forum? {
        didSet{
            chooseForumButton.setTitle(forum?.displayValue, forState: UIControlState.Normal)
            commentAccessoryBecomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TopicCreationViewController.nextBarButtonAction(_:)))
        
        closeButtonItem = rightBarButtonItem //Grabbing the ne created in IB.  I know that incosistancy is bad :-(
        
        titleLabel.setHtmlText(topicTitle, fuckingColor:  "pink")
        topicDescriptionTextView.attributedText = getApplicationContext().topicStash

        let view = NSBundle.mainBundle().loadNibNamed("AccessoryCommentView", owner: topicDescriptionTextView, options: nil)!.first as! AccessoryCommentView
        view.delegate = self
        topicDescriptionTextView.inputAccessoryView = view
        
        validateForNextAction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseForumAction(sender: UIButton) {
    }
    
    
    @IBAction func rightBarButtonAction(sender: UIBarButtonItem) {
        //rightBarButtonItem
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func nextBarButtonAction(sender: UIBarButtonItem){
        performSegueWithIdentifier("CommentViewController", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ForumSelectionViewController{
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            popover.delegate = self
            let sourceView = sender as? UIButton
            popover.sourceRect = (sourceView?.bounds)! //No clue why source view didnt do this.
        }
        
        if let vc = segue.destinationViewController as? CommentViewController {
            vc.forum = forum!
            vc.topicTitle = topicTitle
            vc.topicDescription = topicDescriptionTextView.text
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        getApplicationContext().topicStash = topicDescriptionTextView.attributedText
    }
    
    @IBAction func handleTapGesture(recognizer:UITapGestureRecognizer) {
        commentAccessoryBecomeFirstResponder()
    }
    
    
    
    
    func commentAccessoryBecomeFirstResponder() {
        
        
        topicDescriptionTextView.becomeFirstResponder() //This causes the keyboard to open.
        let accessory = topicDescriptionTextView.inputAccessoryView as! AccessoryCommentView
        
        accessory.defaultText = topicDescriptionTextView.attributedText
        accessory.becomeFirstResponder() //This puts the accessory view in focus.
        //NOTE:  The actual text view needs to have it's "editibale" flag set to false or else it will get focus after dismssing the keyboard+accessory.
        topicDescriptionTextView.inputAccessoryView?.hidden = false
        
    }
    
    func validateForNextAction(){
        if forum == nil {
            validForNext = false
            return
        }
        
        if topicDescriptionTextView.text.isEmpty {
            validForNext = false
            return
        }
        
        validForNext = true
    }

}

extension TopicCreationViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        //Pretty sure this is only called on iphone.
        return UIModalPresentationStyle.None
    }
    
}

extension TopicCreationViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText commentText: String) {
        topicDescriptionTextView.text = commentText
        topicDescriptionTextView.inputAccessoryView?.hidden = true
        
        validateForNextAction()
    }
}

extension TopicCreationViewController: ForumSelectionDelegate{
    func selectedForum(forum: Forum) {
        self.forum = forum
        
        validateForNextAction()
    }
}
