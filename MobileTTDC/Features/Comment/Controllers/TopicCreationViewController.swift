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
    @IBOutlet weak var forumLabel: UILabel!
    
    var nextButtonItem : UIBarButtonItem!
    var closeButtonItem : UIBarButtonItem!
    
    fileprivate var validForNext : Bool = false {
        didSet{
            if validForNext {
                navigationItem.rightBarButtonItem = nextButtonItem
            } else {
                navigationItem.rightBarButtonItem = closeButtonItem
            }
            
        }
    }
    
    var topicTitle: String!
    fileprivate var forum : Forum? {
        didSet{
            chooseForumButton.setTitle(forum?.displayValue, for: UIControlState())
            commentAccessoryBecomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TopicCreationViewController.nextBarButtonAction(_:)))
        
        closeButtonItem = rightBarButtonItem //Grabbing the ne created in IB.  I know that incosistancy is bad :-(
        
//        titleLabel.setHtmlText(topicTitle, fuckingColor:  "pink")
        
        titleLabel.text = topicTitle
        
        if let text = getApplicationContext().topicStash {
            topicDescriptionTextView.setHtmlText(text)
        }
//        topicDescriptionTextView.attributedText = getApplicationContext().topicStash

        let view = Bundle.main.loadNibNamed("AccessoryCommentView", owner: topicDescriptionTextView, options: nil)!.first as! AccessoryCommentView
        view.delegate = self
        topicDescriptionTextView.inputAccessoryView = view
        
        validateForNextAction()
        registerForStyleUpdates()
        
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        
        view.backgroundColor = style.navigationBackgroundColor()
        
        titleLabel.textColor = style.headerTextColor()
        
        chooseForumButton.setTitleColor(style.tintColor(), for: .normal)
        
        
        topicDescriptionTextView.textColor = UIColor.white
        topicDescriptionTextView.backgroundColor = style.postBackgroundColor()
        topicDescriptionTextView.tintColor = style.headerDetailTextColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseForumAction(_ sender: UIButton) {
    }
    
    
    @IBAction func rightBarButtonAction(_ sender: UIBarButtonItem) {
        //rightBarButtonItem
        dismiss(animated: true, completion: nil)
    }
    
    func nextBarButtonAction(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "CommentViewController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ForumSelectionViewController{
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            popover.delegate = self
            let sourceView = sender as? UIButton
            popover.sourceRect = (sourceView?.bounds)! //No clue why source view didnt do this.
        }
        
        if let vc = segue.destination as? CommentViewController {
            vc.forum = forum!
            vc.topicTitle = topicTitle
            vc.topicDescription = getApplicationContext().topicStash
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        getApplicationContext().topicStash = topicDescriptionTextView.attributedText
    }
    
    @IBAction func handleTapGesture(_ recognizer:UITapGestureRecognizer) {
        commentAccessoryBecomeFirstResponder()
    }
    
    
    
    
    func commentAccessoryBecomeFirstResponder() {
        
        
        topicDescriptionTextView.becomeFirstResponder() //This causes the keyboard to open.
        let accessory = topicDescriptionTextView.inputAccessoryView as! AccessoryCommentView
        
        if let text = getApplicationContext().topicStash {
            accessory.defaultText = text
        }

        _ = accessory.becomeFirstResponder() //This puts the accessory view in focus.
        //NOTE:  The actual text view needs to have it's "editibale" flag set to false or else it will get focus after dismssing the keyboard+accessory.
        topicDescriptionTextView.inputAccessoryView?.isHidden = false
        
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
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //Pretty sure this is only called on iphone.
        return UIModalPresentationStyle.none
    }
    
}

extension TopicCreationViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText: String) {
        topicDescriptionTextView.setHtmlText(commentText)
        getApplicationContext().topicStash = commentText
        refreshStyle() //Blunt, but you have to reapply style to textviews after setting the value.
        topicDescriptionTextView.inputAccessoryView?.isHidden = true
        
        validateForNextAction()
    }
}

extension TopicCreationViewController: ForumSelectionDelegate{
    func selectedForum(_ forum: Forum) {
        self.forum = forum
        
        validateForNextAction()
    }
}
