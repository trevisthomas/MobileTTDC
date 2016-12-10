//
//  Sequence+.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/10/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

//Entending array so that it can flatten groupped posts
extension Sequence where Iterator.Element == Post {
    func flattenPosts() -> [Post]{
        var flatPosts : [Post] = []
        for post in self {
            flatPosts.append(post)
            guard (post.posts != nil) else {
                continue
            }
            for reply in post.posts! {
                flatPosts.append(reply)
            }
        }
        return flatPosts
    }
    
    
}

//extension Array where Element: Collection, Element.Iterator.Element == Post {
extension Sequence where Iterator.Element == Post {
    func indexOfPost(sourcePost : Post) -> Int?{
        let array = self as! [Post] //Weird that i had to do this.
        let index = array.index(){
            (post) -> Bool in
            return post.postId == sourcePost.postId
        }
        return index
    }
    
}
