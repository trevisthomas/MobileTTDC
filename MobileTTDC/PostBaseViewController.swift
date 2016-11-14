//
//  PostBaseViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostBaseViewController: UIViewController, PostViewCellDelegate {
    
    var replyPrototypeCell : PostReplyCollectionViewCell!
    var postPrototypeCell : PostCollectionViewCell!
    var reviewPostPrototypeCell : ReviewPostCollectionViewCell!
    var moviePostPrototypeCell : MoviePostCollectionViewCell!
    var rootPostPrototypeCell : RootPostCollectionViewCell!
    var loadingMessageCell : LoadingCollectionViewCell!
    var refreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerPrototypeCells()
        
        refreshControl.addTarget(self, action: #selector(PostBaseViewController.performDataRefresh(_:)), for: .valueChanged)
        
        getCollectionView()?.refreshControl = refreshControl
    }
    
    func registerPrototypeCells() {
        postPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_CELL, forReuseIdentifier: ReuseIdentifiers.POST_CELL) as! PostCollectionViewCell
        
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_REPLY_CELL, forReuseIdentifier: ReuseIdentifiers.POST_REPLY_CELL) as! PostReplyCollectionViewCell
        
        reviewPostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_REVIEW_CELL, forReuseIdentifier: ReuseIdentifiers.POST_REVIEW_CELL) as! ReviewPostCollectionViewCell
        
        moviePostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.MOVIE_POST_CELL, forReuseIdentifier: ReuseIdentifiers.MOVIE_POST_CELL) as! MoviePostCollectionViewCell
        
        rootPostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.ROOT_POST_CELL, forReuseIdentifier: ReuseIdentifiers.ROOT_POST_CELL) as! RootPostCollectionViewCell
        
        loadingMessageCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.LOADING_CELL, forReuseIdentifier: ReuseIdentifiers.LOADING_CELL) as! LoadingCollectionViewCell
    }

//    func refreshData(completion: @escaping () -> Void) {
////        abort()
//    }
    
    func performDataRefresh(_ refreshControl: UIRefreshControl) {
        refreshData() {
            refreshControl.endRefreshing()
        }
    }


    func likePost(_ post: Post){
        
    }
    
    func viewComments(_ post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
    }
    func commentOnPost(_ post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        dict["postId"] = post.postId
        performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
    }
    func viewThread(_ post: Post) {
        performSegue(withIdentifier: "ThreadView", sender: post.postId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nav = segue.destination as? UINavigationController else {
            return
        }
        
        if let destVC = nav.topViewController as? ThreadViewController {
            let postId = sender as! String
            destVC.rootPostId = postId
            return
        }
        
        guard let vc = nav.topViewController as? ConversationWithReplyViewController else {
            return
        }
        
        let dict = sender as! [String: String]
        
        print(dict["threadId"]!)
        
        vc.postId = dict["threadId"]
        if let postId = dict["postId"] {
            vc.replyToPostId = postId
        }
    }

    func dequeueCell(_ post : Post, indexPath : IndexPath, allowHierarchy : Bool = false) -> UICollectionViewCell {
        if post.isMovie {
            let cell =  self.getCollectionView()!.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.MOVIE_POST_CELL, for: indexPath) as! MoviePostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        } else if post.isRootPost {
            let cell =  self.getCollectionView()!.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.ROOT_POST_CELL, for: indexPath) as! RootPostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        } else if allowHierarchy && !post.threadPost {
            let cell =  self.getCollectionView()!.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.POST_REPLY_CELL, for: indexPath) as! PostReplyCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        } else if (post.isReview) {
            let cell = self.getCollectionView()!.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.POST_REVIEW_CELL, for: indexPath) as! ReviewPostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        }
        else {
            let cell = self.getCollectionView()!.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.POST_CELL, for: indexPath) as! PostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        }
    }
    
    func prototypeLoadingCellSize() -> CGSize {
//        let frameSize = getCollectionView()!.frame.size
//        return CGSizeMake(self.collectionView.frame.width, self.loadingMessageCell.frame.height)
        return loadingMessageCell.frame.size
    }
    
    func prototypeCellSize(post p: Post, allowHierarchy : Bool = false) -> CGSize {

        let height : CGFloat
        let frameSize = getCollectionView()!.frame.size
        
        if p.isMovie{
            moviePostPrototypeCell.post = p
            height = moviePostPrototypeCell.preferredHeight(frameSize.width)
        } else if (allowHierarchy && !p.threadPost) {
            replyPrototypeCell.post = p
            height = replyPrototypeCell.preferredHeight(frameSize.width)
        } else if (p.isReview) {
            reviewPostPrototypeCell.post = p
            height = reviewPostPrototypeCell.preferredHeight(frameSize.width)
        }else {
            postPrototypeCell.post = p
            height = postPrototypeCell.preferredHeight(frameSize.width)
        }
        
        return CGSize(width: frameSize.width, height: height)
    }

}

protocol DynamicData {
    func refreshData(completion: @escaping () -> Void)
}

//http://stackoverflow.com/questions/32105957/swift-calling-subclasss-overridden-method-from-superclass/40558606#40558606
//Trevis, WTF.  Adding this method to the PostBase* class directly and then calling it from that classes implementation doesnt call the overriden verison from the sub!  WTF!
extension PostBaseViewController : DynamicData {
    internal func refreshData(completion: @escaping () -> Void) {
        abort()
    }
}



