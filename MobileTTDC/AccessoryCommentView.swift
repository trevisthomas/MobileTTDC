//
//  AccessoryCommentView.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/14/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

protocol AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText commentText: String)
}

class AccessoryCommentView: UIView {
    var delegate : AccessoryCommentViewDelegate!
    var postId : String!
    
    var defaultText: NSAttributedString! {
        didSet{
             postTextView.attributedText = self.defaultText
        }
    }
    
    @IBOutlet weak var postTextView: UITextView!
    @IBAction func photoButtonAction(sender: AnyObject) {
    }
   
    @IBAction func postButtonAction(sender: UIButton) {
        delegate.accessoryCommentView(commentText: postTextView.text)
        postTextView.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder() //Maybe?
        return postTextView.becomeFirstResponder()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
