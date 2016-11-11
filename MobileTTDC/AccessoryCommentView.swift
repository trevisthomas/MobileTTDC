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
    
    var defaultText: NSAttributedString! {
        didSet{
             postTextView.attributedText = self.defaultText
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
        super.becomeFirstResponder() //Maybe?
        return postTextView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder() // Shrug
        return postTextView.resignFirstResponder()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
