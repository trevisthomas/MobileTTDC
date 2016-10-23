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
    
    @IBOutlet weak var collectionView: UICollectionView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self //For the layout delegate
        
        self.title = "Conversations"
        
        getApplicationContext().latestConversationsObserver = self
        
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
        
        let post = getApplicationContext().latestConversations()[indexPath.row]
        
        return prototypeCellSize(post: post, allowHierarchy: false)
    }
}


extension ConversationsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return getApplicationContext().latestConversations().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let post = getApplicationContext().latestConversations()[indexPath.row]
        
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
