//
//  PostViewCellDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

protocol PostViewCellDelegate {
    func likePost(_ post: Post)
    func viewComments(_ post: Post)
    func commentOnPost(_ post: Post)
    func viewThread(_ post: Post)
    func presentCreator(_ personId: String)
}
