//
//  ConversationsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit


class ConversationsViewController: PostBaseViewController {
    
   // private(set) var postForSegue : Post! = nil //OUTSTANDING!
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var refreshControl: UIRefreshControl = UIRefreshControl()

//    let label : UILabel = UILabel(frame: CGRectMake(50, 700, 100, 100))
    
    var dataLoadingInProgress : Bool = false
    var pageNumber : Int = 1
    var posts : [Post] = []
    var sizeCache : [CGSize] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self //For the layout delegate
        
        self.title = "Conversations"
        
//        getApplicationContext().latestConversationsObserver = self
        
        registerForStyleUpdates()
        
//        self.label.text = "Da fuq"
        
//        collectionView.refreshControl = label
        
//        collectionView.scro
//        scrollView.addSubview(label)
        
        registerForUserChangeUpdates()
        loadLatestConversations(){ () in return } //Hm, how do you make the completion handler optional?
        
        refreshControl.addTarget(self, action: #selector(ConversationsViewController.refreshData(_:)), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
        
        
    }
    
    override func onCurrentUserChanged() {
        posts = []
        collectionView.reloadData()
        loadLatestConversations() { () in return }
    }
    
    override func refreshStyle() {
        
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout() //Just incase the orientation changed when you werent visible
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: ConversationsViewController")
        collectionView?.collectionViewLayout.invalidateLayout()
        
//        coordinator.animateAlongsideTransition({ context in
//            // do whatever with your context
//            context.viewControllerForKey(UITransitionContextFromViewControllerKey)
//            }, completion: {context in
//                
//                if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact){
//                    print("Compact width")
//                    self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
//                } else {
//                    
//                    print("Regular width")
//                    //Forcing the master to be visible all the time on ipad
//                    self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
//                    //Expanding icon functionality.  If this runs on the iphone you have no button to navigate to the master view
//                    self.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem();
//                }
//                
//                
//            }
//        )

    }
 
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
}



extension ConversationsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.row < posts.count) {
//            let post = posts[indexPath.row]
            return sizeCache[indexPath.row]
//            return prototypeCellSize(post: post, allowHierarchy: false)

//            return CGSize(width: collectionView.frame.size.width, height: 200)
            
        } else {
            return prototypeLoadingCellSize()
        }
        
        
    }
}


extension ConversationsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        if collectionView.isScrollingNeeded() {
//            return getApplicationContext().latestConversations().count + 1
//        } else {
//            return getApplicationContext().latestConversations().count
//        }
        return posts.count + 1
        
//        return posts.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row >= posts.count) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.LOADING_CELL, for: indexPath)
        }
        
        let post = posts[indexPath.row]
        
        return dequeueCell(post, indexPath: indexPath, allowHierarchy: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let post = posts[indexPath.row]
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
//

//        let post = posts[indexPath.row]
//        DispatchQueue.main.async {
//            let v = self.prototypeCellSize(post: post, allowHierarchy: false)
//            print(v)
//        }
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if postForSegue == nil {
//            return
//        }
//        
//        switch segue.identifier! {
//            case "ConversationDetailSegue":
//                //During dev i had it seguing directly to the VC as well as the Nav.  The condition below is to handle both
//                if let destNav = segue.destinationViewController as? UINavigationController {
//                    let destinationVC = destNav.topViewController as! ConversationDetailViewController
//                    destinationVC.post = postForSegue
//                }
//                else {
//                    let destinationVC = segue.destinationViewController as! ConversationDetailViewController
//                    destinationVC.post = postForSegue
//                }
//            default:
//            break
//        }
//
//    }
    
    func refreshData(_ refreshControl: UIRefreshControl) {
        loadLatestConversations() {
            refreshControl.endRefreshing()
        }
    }
    
    //reloadDelegate : ReloadDelegate? = nil
    func loadLatestConversations(_ completion: @escaping () -> Void){
        pageNumber = 1
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageNumber: pageNumber)
        
        self.dataLoadingInProgress = true
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            self.dataLoadingInProgress = false
            guard (response != nil) else {
                //Error
                self.presentAlert("Error", message: message!)
                completion()
                return;
            }
//            self.posts = (response?.list)!
            self.posts = (response?.list)!
            
            self.loadSizeCache(posts: self.posts){
                self.collectionView.reloadData()
                completion()
            }
        };
   
    }
    func loadNextPage(){
        pageNumber += 1
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageNumber: pageNumber)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            self.dataLoadingInProgress = false
            guard (response != nil) else {
                self.presentAlert("Error", message: message!)
                return;
            }

//            self.posts.append(contentsOf: (response?.list)!)
//            self.collectionView.reloadData()
            
            // Hours of time wasted on what is below. Turns out the failure is in the attrbuted text thing.  The attributed text size thing that i do in my prototype doesnt work
            var count = self.posts.count - 1
            let list = (response?.list)!
            
            var paths : [IndexPath] = []
            for _ in list {
                let path = IndexPath(row: count, section: 0)
                paths.append(path)
                count = count + 1
            }
            
            self.posts.append(contentsOf: (response?.list)!)
            
            self.loadSizeCache(posts: self.posts){
                self.collectionView.insertItems(at: paths)
            }
            
            
            
            
        };
    }
    func loadSizeCache(posts : [Post], completion: @escaping () -> Swift.Void){
        sizeCache = []
        DispatchQueue.main.async {
            for p in self.posts {
                let size = self.prototypeCellSize(post: p, allowHierarchy: false)
                print(size)
                self.sizeCache.append(size)
            }
            completion()
        }
    }
    
//    func appendSizeCache(posts : [Post], completion: @escaping () -> Swift.Void){
//        DispatchQueue.main.async {
//            for p in posts {
//                let size = self.prototypeCellSize(post: p, allowHierarchy: false)
//                print(size)
//                self.sizeCache.append(size)
//            }
//            completion()
//        }
//    }

//    func loadSizeCache(posts : [Post], completion: @escaping () -> Swift.Void){
//        sizeCache = []
//        
//        appendSizeCache(posts: posts, completion: completion)
//    }
//    
//    func appendSizeCache(posts : [Post], completion: @escaping () -> Swift.Void){
//        DispatchQueue.main.async {
//            for p in posts {
//                let size = self.prototypeCellSize(post: p, allowHierarchy: false)
//                print(size)
//                self.sizeCache.append(size)
//            }
//            completion()
//        }
//    }
    
}
//
//extension ConversationsViewController{
//    
//    
//    func loadDataFromWebservice(){
//        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS)
//        
//        Network.performSearchCommand(cmd){
//            (response, message) -> Void in
//            guard (response != nil) else {
//                self.presentAlert("Sorry", message: "Webservice request failed.")
//                return;
//            }
//            
//            self.posts = (response?.list)!
//            self.collectionView?.reloadData()
//        };
//    }
//}

extension ConversationsViewController : UIScrollViewDelegate {
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
//                collectionView.reloadData()
                loadNextPage()
                
            }
            
            
            
            print("Bottom")
        }
        
        
        

        
    }
    
//    func adjustHistoryViewBecauseScrollChangedAllTheWay(){
//        let yOffset = collectionView.contentOffset.y
//        
//        if(yOffset <= 0){
//            collectionView.frame.origin.y = originalTopOfCollectionView
//            modeSelectionView.frame.origin.y = originalTopOfDisapearingView
//            
//        } else if yOffset < modeSelectionHeightConstraint.constant + originalTopOfDisapearingView - statusBarHeight{
//            collectionView.frame.origin.y = originalTopOfCollectionView - collectionView.contentOffset.y
//            modeSelectionView.frame.origin.y = originalTopOfDisapearingView - collectionView.contentOffset.y
//        } else {
//            collectionView.frame.origin.y = 0 + statusBarHeight
//            modeSelectionView.frame.origin.y = -modeSelectionHeightConstraint.constant + statusBarHeight
//        }
//    }
}


//extension ConversationsViewController : LatestConversationsObserver {
//    func latestConversationsUpdated() {
//        self.collectionView?.reloadData()
//    }
//    func networkError(_ error: String) {
//        self.presentAlert("Sorry", message: error)
//    }
//    func authenticatedUserChanged() {
//        print("Conversations VC sees that the user changed.")
//    }
//}
