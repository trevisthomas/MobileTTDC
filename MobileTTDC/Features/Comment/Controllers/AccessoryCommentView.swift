//
//  AccessoryCommentView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/14/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

protocol AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText: String)
}

class AccessoryCommentView: UIView, UITextViewDelegate {
    var delegate : AccessoryCommentViewDelegate! {
        didSet{
            if let url = getApplicationContext().currentUser()?.image?.name {
                creatorProfilePic.downloadedFrom(link: url, contentMode: .scaleAspectFit)
            }
        }
    }
    var postId : String!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var textViewToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewToBottomConstraint: NSLayoutConstraint!
    var currentHeight : CGFloat?
    
    @IBOutlet weak var creatorProfilePic: UIImageView!
    
    var defaultText: String! {
        didSet{
            postTextView.text = defaultText
            
            
        }
    }
    
    @IBOutlet weak var postTextView: UITextView! {
        didSet{
            postTextView.delegate = self
        }
    }
    @IBAction func photoButtonAction(_ sender: AnyObject) {
    }
    
    
    @IBAction func postButtonAction(_ sender: UIButton) {
        postTextView.resignFirstResponder()
        delegate.accessoryCommentView(commentText: postTextView.text)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
//        let fixedWidth = postTextView.frame.size.width
//        let templateSize = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
//        
//        
//        let suggestedSize = postTextView.sizeThatFits(templateSize)
//        
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
        
        let vmargin = textViewToTopConstraint.constant + textViewToBottomConstraint.constant
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + vmargin)
//        textView.frame = newFrame;
        
        var suggested = newSize.height + vmargin
        if currentHeight == nil {
            currentHeight = suggested
        }
        
//        print("Suggested: \(newFrame)")
        
        if (suggested > 200) {
            suggested = 200
        }
        
        if suggested != currentHeight{
            currentHeight = suggested
            frame.size.height = currentHeight!
            textView.reloadInputViews()
        }
        
//        print("Suggested: \(newFrame)")
//        
//        if (newFrame.height > 200) {
//            frame.size.height = 200
//            textView.reloadInputViews()
//        } else {
//            frame.size.height = newFrame.height
//            textView.reloadInputViews()
//        }
//        frame.size.height = newFrame.height
    }
    
//    override func addConstraint(_ constraint: NSLayoutConstraint) {
//        if constraint.firstItem === self {
//            self.heightConstraint = constraint
//            
//            print("\(self.heightConstraint?.constant)")
//        }
//        
//        super.addConstraint(constraint)
//    }
//    
//    override func addConstraints(_ constraints: [NSLayoutConstraint]) {
//        super.addConstraints(constraints)
//    }
    
    
    
    override func becomeFirstResponder() -> Bool {
//        postTextView.keyboardAppearance = getApplicationContext().getCurrentStyle().keyboardAppearance()

        super.becomeFirstResponder() //Maybe?
        refreshStyle()
        
        
        return postTextView.becomeFirstResponder()
    }
    
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder() // Shrug
        return postTextView.resignFirstResponder()
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        postTextView.keyboardAppearance = style.keyboardAppearance()
        backgroundColor = style.underneath()
        
        postTextView.backgroundColor = style.postBackgroundColor()
        postTextView.textColor = style.entryTextColor()
        postTextView.tintColor = style.tintColor()
        
//        postButton.backgroundColor = style.tintColor()
        postButton.titleLabel?.textColor = style.tintColor()
//        postButton.layer.cornerRadius = 10
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


