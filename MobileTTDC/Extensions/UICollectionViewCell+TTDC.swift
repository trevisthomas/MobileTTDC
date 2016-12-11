//
//  UICollectionViewCell+TTDC.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell : UITextViewDelegate {
    //http://stackoverflow.com/questions/20541676/ios-uitextview-or-uilabel-with-clickable-links-to-actions
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("\(URL.absoluteString)")
        return true;
    }
    
    
}


extension UICollectionViewCell {
    func configureLikeButton(post : Post, button : UIButton) {
        if let currentUser = getApplicationContext().currentUser() {
//            button.isEnabled = true
            
            if post.isLikedByMe(personId: currentUser.personId) {
                button.setTitle("Unlike", for: .normal)
            } else {
                button.setTitle("Like", for: .normal)
            }
            
        } else {
//            button.isEnabled = false
            button.setTitle("Like", for: .normal)
        }
        
    }
    
    func formatLikesString(post: Post) -> String {
        
        guard post.howManyLikes() > 0 else {
            return ""
        }
        var likes = ""
        for tagAss in post.tagAssociations! {
            if(tagAss.tag.type == "LIKE"){
                if (!likes.isEmpty){
                    likes.append(", ")
                }
                likes.append(tagAss.creator.login)
            }
        }
        return "Liked by: \(likes)"
    }
}

//extension UICollectionViewCell : PostUpdateListener {
//    
//}

