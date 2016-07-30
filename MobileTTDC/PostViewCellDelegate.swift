//
//  PostViewCellDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

protocol PostViewCellDelegate {
    func likePost(post: Post)
    func viewComments(post: Post)
    func commentOnPost(post: Post)
}