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

class AccessoryCommentView: UIView {
    var delegate : AccessoryCommentViewDelegate!
    var postId : String!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    var defaultText: String! {
        didSet{
//            postTextView.keyboardAppearance = getApplicationContext().getCurrentStyle().keyboardAppearance()
//            postTextView.attributedText = self.defaultText
            postTextView.text = defaultText
        }
    }
    
    @IBOutlet weak var postTextView: UITextView!
    @IBAction func photoButtonAction(_ sender: AnyObject) {
    }
   
    @IBAction func postButtonAction(_ sender: UIButton) {
        postTextView.resignFirstResponder()
        delegate.accessoryCommentView(commentText: postTextView.text)
        
    }
    
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
        backgroundColor = style.navigationBackgroundColor()
        
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
