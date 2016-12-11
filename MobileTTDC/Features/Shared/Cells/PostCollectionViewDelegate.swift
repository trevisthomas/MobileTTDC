//
//  PostCollectionViewDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/20/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

protocol PostCollectionViewDelegate {
    func loadPosts(completion: @escaping ([Post]?, _ remaining: Bool) -> Void)
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?,  _ remaining: Bool) -> Void)
}

