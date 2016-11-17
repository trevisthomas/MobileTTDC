//
//  CommonBaseViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/13/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class CommonBaseViewController: UIViewController, PostViewCellDelegate {
    
    var replyPrototypeCell : PostReplyCollectionViewCell!
    var postPrototypeCell : PostCollectionViewCell!
    var reviewPostPrototypeCell : ReviewPostCollectionViewCell!
    var moviePostPrototypeCell : MoviePostCollectionViewCell!
    var rootPostPrototypeCell : RootPostCollectionViewCell!
    var loadingMessageCell : LoadingCollectionViewCell!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var posts : [Post] = []
    var sizeCache : [CGSize] = []
    var dataLoadingInProgress : Bool = false
    var pageNumber : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPrototypeCells()
        
        refreshControl.addTarget(self, action: #selector(CommonBaseViewController.performDataRefresh(_:)), for: .valueChanged)
        
        getCollectionView()?.refreshControl = refreshControl
        
        registerForStyleUpdates()
        registerForUserChangeUpdates()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: PostDetailViewController")
        
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        }, completion: {context in
            self.sizeCache = []
            self.loadSizeCache(posts: self.posts) {
                   self.getCollectionView()?.collectionViewLayout.invalidateLayout()
            }
        }
        )
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.getCollectionView()?.collectionViewLayout.invalidateLayout()
//        
//    }
    
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

    
    func registerPrototypeCells() {
        postPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_CELL, forReuseIdentifier: ReuseIdentifiers.POST_CELL) as! PostCollectionViewCell
        
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_REPLY_CELL, forReuseIdentifier: ReuseIdentifiers.POST_REPLY_CELL) as! PostReplyCollectionViewCell
        
        reviewPostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_REVIEW_CELL, forReuseIdentifier: ReuseIdentifiers.POST_REVIEW_CELL) as! ReviewPostCollectionViewCell
        
        moviePostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.MOVIE_POST_CELL, forReuseIdentifier: ReuseIdentifiers.MOVIE_POST_CELL) as! MoviePostCollectionViewCell
        
        rootPostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.ROOT_POST_CELL, forReuseIdentifier: ReuseIdentifiers.ROOT_POST_CELL) as! RootPostCollectionViewCell
        
        loadingMessageCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.LOADING_CELL, forReuseIdentifier: ReuseIdentifiers.LOADING_CELL) as! LoadingCollectionViewCell
    }
    
    
    func performDataRefresh(_ refreshControl: UIRefreshControl) {
        loadFirstPage() {
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
    
    func dequeueCell(_ post : Post, indexPath : IndexPath) -> UICollectionViewCell {
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
        } else if allowHierarchy() && !post.threadPost {
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
        return loadingMessageCell.frame.size
    }
    
    func prototypeCellSize(post p: Post) -> CGSize {
        
        let height : CGFloat
        let frameSize = getCollectionView()!.frame.size
        
        if p.isMovie{
            moviePostPrototypeCell.post = p
            height = moviePostPrototypeCell.preferredHeight(frameSize.width)
        } else if (allowHierarchy() && !p.threadPost) {
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
    
    func loadPosts(completion: @escaping ([Post]?) -> Void){
        abort()
    }
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
        abort()
    }
    
    func loadFirstPage(completion: @escaping (() -> Void) = {}) {
        self.dataLoadingInProgress = true
        loadPosts() {
            (posts) -> Void in
            self.dataLoadingInProgress = false
            guard (posts != nil) else {
                completion()
                return;
            }
            self.posts = posts!
            
            self.loadSizeCache(posts: self.posts){
                self.getCollectionView()?.reloadData()
                completion()
            }
            
        }
    }
    
    func loadNextPage(completion: @escaping (() -> Void) = {}){
        pageNumber += 1
        
        loadMorePosts(pageNumber: pageNumber) {
            (posts) -> Void in
            
            self.dataLoadingInProgress = false
            guard (posts != nil) else {
                completion()
                return;
            }

            
            // Hours of time wasted on what is below. Turns out the failure is in the attrbuted text thing.  The attributed text size thing that i do in my prototype doesnt work
            var count = self.posts.count - 1
            let list = posts!
            
            var paths : [IndexPath] = []
            for _ in list {
                let path = IndexPath(row: count, section: 0)
                paths.append(path)
                count = count + 1
            }
            
            self.posts.append(contentsOf: list)
            
            self.loadSizeCache(posts: self.posts){
                self.getCollectionView()?.reloadData()
                completion()
            }
        }
        
    }
    func loadSizeCache(posts : [Post], completion: (@escaping () -> Swift.Void) = {}){
        
        DispatchQueue.main.async {
            self.sizeCache = []
            for p in self.posts {
                let size = self.prototypeCellSize(post: p)
//                print(size)
                self.sizeCache.append(size)
            }
            completion()
        }
    }
    
    func allowHierarchy() -> Bool {
        return false
    }
    
    func removeAllPosts(){
        posts = []
        getCollectionView()?.reloadData()
    }
}

extension CommonBaseViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.row >= posts.count) {
            return prototypeLoadingCellSize()
        } else {
            return sizeCache[indexPath.row]
        }
    }
}

extension CommonBaseViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        if (scrollOffset == 0)
        {
            // then we are at the top
            print("Top!")
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
        {
            
            if(!dataLoadingInProgress) {
                dataLoadingInProgress = true
                loadNextPage()
            }
            print("Bottom")
        }
    }
}

extension CommonBaseViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row >= posts.count) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.LOADING_CELL, for: indexPath)
        }
        
        let post = posts[indexPath.row]
        
        return dequeueCell(post, indexPath: indexPath)
        
    }
    
}

//extension CommonBaseViewController : UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let post = self.posts[indexPath.row]
//        var dict = [String: String]()
//        dict["threadId"] = post.threadId
//        performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
//        
//    }
//}




//protocol CommonBaseViewControllerDelegate {
//    func loadFirstPage(completion: @escaping () -> Void)
//    
//}

//http://stackoverflow.com/questions/32105957/swift-calling-subclasss-overridden-method-from-superclass/40558606#40558606
//Trevis, WTF.  Adding this method to the PostBase* class directly and then calling it from that classes implementation doesnt call the overriden verison from the sub!  WTF!
//extension CommonBaseViewController : CommonBaseViewControllerDelegate {
//    internal func loadFirstPage(completion: @escaping () -> Void) {
//        abort()
//    }
//}
