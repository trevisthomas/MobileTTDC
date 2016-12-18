//
//  CommonBaseViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/13/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class CommonBaseViewController: UIViewController {
    private var replyPrototypeCell : PostReplyCollectionViewCell!
    private var postPrototypeCell : PostCollectionViewCell!
    private var reviewPostPrototypeCell : ReviewPostCollectionViewCell!
    private var moviePostPrototypeCell : MoviePostCollectionViewCell!
    private var rootPostPrototypeCell : RootPostCollectionViewCell!
    private var loadingMessageCell : LoadingCollectionViewCell!
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var posts : [Post] = []
    
//    var posts : [Post] = [] {
//        didSet {
//            print("I'm the asshole")
//            getCollectionView()?.reloadData()
//        }
//    }
    fileprivate var dataLoadingInProgress : Bool = false
    private var pageNumber : Int = 1
    fileprivate var morePostsRemaining : Bool = true
    
    private var delegate : PostCollectionViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self as! PostCollectionViewDelegate
//        getApplicationContext().broadcaster.subscribeForPostAdd(consumer: self)
//        getApplicationContext().latestPostsModel.addListener(listener: self)
    }
    
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
        
//        reload
        
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        }, completion: {context in
//            self.sizeCache = []
            self.loadSizeCache(posts: self.posts) {
//                   self.getCollectionView()?.collectionViewLayout.invalidateLayout()
                self.getCollectionView()?.performBatchUpdates(nil, completion: nil)
            }
        }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? CommentViewController {
            let dict = sender as! [String: String]
            
            destVC.parentId = dict["postId"]
            return
        }
        
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
        getApplicationContext().latestPostsModel.invalidate()
        
        loadFirstPage() {
            refreshControl.endRefreshing()
        }
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
        } else if (allowHierarchy() && !p.threadPost && !p.isRootPost) {
            replyPrototypeCell.post = p
            height = replyPrototypeCell.preferredHeight(frameSize.width)
        } else if (p.isReview) {
            reviewPostPrototypeCell.post = p
            height = reviewPostPrototypeCell.preferredHeight(frameSize.width)
        } else if (p.isRootPost) {
            rootPostPrototypeCell.post = p
            height = rootPostPrototypeCell.preferredHeight(frameSize.width)
        } else {
            postPrototypeCell.post = p
            height = postPrototypeCell.preferredHeight(frameSize.width)
        }
        
        return CGSize(width: frameSize.width, height: height)
    }
    
    func loadFirstPage(completion: @escaping (() -> Void) = {}) {
        self.dataLoadingInProgress = true
        
        pageNumber = 1
        
        delegate.loadPosts() {
            (posts, remaining) -> Void in
            self.dataLoadingInProgress = false
            self.morePostsRemaining = remaining
            guard (posts != nil) else {
                completion()
                return;
            }
            self.posts = posts!
            
            //TODO: What is going on here?  Two reloads?
            self.getCollectionView()?.reloadData()
            
            self.loadSizeCache(posts: self.posts){
                self.getCollectionView()?.reloadData()
                completion()
            }
            
        }
    }
    
    func loadNextPage(completion: @escaping (() -> Void) = {}){
        pageNumber += 1
        
        delegate.loadMorePosts(pageNumber: pageNumber) {
            (posts, remaining) -> Void in
            self.morePostsRemaining = remaining
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
            
           
// Anoying crash
//            self.posts.append(contentsOf: list)
//            
//            self.loadSizeCache(posts: self.posts){
//                self.getCollectionView()?.insertItems(at: paths)
//                completion()                
//            }
            
        }
        
    }
    func loadSizeCache(posts : [Post], completion: (@escaping () -> Swift.Void) = {}){
        DispatchQueue.main.async {
            for p in self.posts {
                let size = self.prototypeCellSize(post: p)
                p.size = size.toTuple()
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

            //This is a thought that i had for generating the size if for somereason it wasnt here. (because i'm thinking that if the model is loaded outside of this class that they wont be set.
            let post = posts[indexPath.row]
            
            if post.size == nil {
                let size = self.prototypeCellSize(post: post)
                post.size = size.toTuple()
            }
            return CGSize.fromTuple(tuple: post.size!)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
    //Spacing between cells.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
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
            
            if(!dataLoadingInProgress && self.morePostsRemaining) {
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
        if self.morePostsRemaining {
            return posts.count + 1
        } else {
            return posts.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row >= posts.count) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.LOADING_CELL, for: indexPath)
        }
        
        
        let post = posts[indexPath.row]
        
        return dequeueCell(post, indexPath: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //This mighht need more thought.  Probably not needed if the post hasnt changed.
        guard let postCell = cell as? BaseCollectionViewCell else {
            return
        }
        
        postCell.post = posts[indexPath.row]
        
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


extension CommonBaseViewController : PostViewCellDelegate {
    func likePost(_ post: Post){
        guard getApplicationContext().isAuthenticated() else {
            self.presentAlert("Hey Guest", message: "You must be logged in to like posts.")
            return
        }
        
        let cmd = LikeCommand(postId: post.postId)
        Network.performLikeCommand(cmd) {
            (response, message) in
            if let error = message {
                self.presentAlert("Sorry", message: error)
            }

            if let post = response?.tagAssociation.post {
                self.getApplicationContext().broadcaster.postUpdated(post: post)
            }

        }
    }
    
    func viewComments(_ post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
    }
    func commentOnPost(_ post: Post){
        
        guard getApplicationContext().isAuthenticated() else {
            self.presentAlert("Hey Guest", message: "You must be logged in to post comments.")
            return
        }
        
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        dict["postId"] = post.postId
        if(post.isRootPost) {
            performSegue(withIdentifier: "CommentViewController", sender: dict)
        } else {
            performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
        }
    }
    func viewThread(_ post: Post) {
        performSegue(withIdentifier: "ThreadView", sender: post.postId)
    }

}

//extension CommonBaseViewController : PostUpdateListener {
//    func getDisplayMode() -> DisplayMode {
//        return getApplicationContext().displayMode
//    }
//    
//    func onPostUpdated(post : Post, index : Int) {
//        let path = IndexPath(item: index, section: 0)
//        if let cell = getCollectionView()?.cellForItem(at: path) as? BaseCollectionViewCell {
//            cell.post = post
//        }
//    }
//
//}


//http://stackoverflow.com/questions/32105957/swift-calling-subclasss-overridden-method-from-superclass/40558606#40558606
//Trevis, WTF.  Adding this method to the PostBase* class directly and then calling it from that classes implementation doesnt call the overriden verison from the sub!  WTF!
//extension CommonBaseViewController : CommonBaseViewControllerDelegate {
//    internal func loadFirstPage(completion: @escaping () -> Void) {
//        abort()
//    }
//}
