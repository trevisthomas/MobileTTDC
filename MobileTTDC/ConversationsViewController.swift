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

//    let label : UILabel = UILabel(frame: CGRectMake(50, 700, 100, 100))
    
    var dataLoadingInProgress : Bool = false
    var pageNumber : Int = 1
    var posts : [Post] = []
    
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
        loadLatestConversations()
        
        
        
    }
    
    override func onCurrentUserChanged() {
        posts = []
        collectionView.reloadData()
        loadLatestConversations()
    }
    
    override func refreshStyle() {
        
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout() //Just incase the orientation changed when you werent visible
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
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
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        sizingCellPrototype.post = getApplicationContext().latestConversations()[indexPath.row]
//        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
//        return CGSize(width: collectionView.frame.width, height: height)
        
//        if (indexPath.row >= posts.count) {
//            
//            return CGSizeMake(self.collectionView.frame.width , self.loadingMessageCell.frame.height)
//        }
//        
//        let post = posts[indexPath.row]
//        
//        return prototypeCellSize(post: post, allowHierarchy: false)
        
        if (indexPath.row < posts.count) {
            let post = posts[indexPath.row]
            
            return prototypeCellSize(post: post, allowHierarchy: false)
        } else {
            return prototypeLoadingCellSize()
        }
        
        
    }
}


extension ConversationsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        if collectionView.isScrollingNeeded() {
//            return getApplicationContext().latestConversations().count + 1
//        } else {
//            return getApplicationContext().latestConversations().count
//        }
        return posts.count + 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (indexPath.row >= posts.count) {
            return collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.LOADING_CELL, forIndexPath: indexPath)
        }
        
        let post = posts[indexPath.row]
        
        return dequeueCell(post, indexPath: indexPath, allowHierarchy: false)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = getApplicationContext().latestConversations()[indexPath.row]
//        performSegueWithIdentifier("ConversationDetailSegue", sender: self)
        
        var dict = [String: String]()
        dict["threadId"] = post.threadId
//        dict["postId"] = post.postId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)
        
        
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
    
    func loadLatestConversations(){
        pageNumber = 1
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageNumber: pageNumber)
        
        self.dataLoadingInProgress = true
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            self.dataLoadingInProgress = false
            guard (response != nil) else {
                //Error
                self.presentAlert("Error", message: message!)
                return;
            }
            self.posts = (response?.list)!
            self.collectionView.reloadData()
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
//            self.getApplicationContext()._latestConversations.appendContentsOf((response?.list)!)
            self.posts.appendContentsOf((response?.list)!)
            self.collectionView.reloadData()
            
        };
    }
    
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
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
                collectionView.reloadData()
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


extension ConversationsViewController : LatestConversationsObserver {
    func latestConversationsUpdated() {
        self.collectionView?.reloadData()
    }
    func networkError(error: String) {
        self.presentAlert("Sorry", message: error)
    }
    func authenticatedUserChanged() {
        print("Conversations VC sees that the user changed.")
    }
}
