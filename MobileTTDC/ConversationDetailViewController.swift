//
//  ConversationViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationDetailViewController: PostBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
  private var posts : [Post] = []
    var post : Post! {
        didSet{
            loadConversationPostDataFromWebservice(post.postId)
        }
    }
    
    
    /*
    private var closeBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(closeButtonClicked(_:)))
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self //For the layout delegate
        
        
//        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
//        
//        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
//        
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifiers.EMPTY_HEADER_VIEW)
        
        
//        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay
        
        

//        self.splitViewController.preferredDisplayMode = 
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone){
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
        } else {
            //Forcing the master to be visible all the time on ipad
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            //Expanding icon functionality.  If this runs on the iphone you have no button to navigate to the master view
            self.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem();
        }
 
        
        
    }
    
    //This is here so that the layout will adjust when you "maximize"
    override func viewWillLayoutSubviews() {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: PostDetailViewController")
        
        coordinator.animateAlongsideTransition({ context in
            // do whatever with your context
            context.viewControllerForKey(UITransitionContextFromViewControllerKey)
            }, completion: {context in
                self.collectionView?.collectionViewLayout.invalidateLayout()
                
            }
        )
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print("prep for unwind")
    }

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return false
    }
}

extension ConversationDetailViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
//        
//        return CGSize(width: collectionView.frame.width, height: height)
        
        return prototypeCellSize(post: posts[indexPath.row])
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        if post == nil {
//            return CGSizeZero
//        }
//        
//        sectionHeaderPrototype.post = post
//        let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
//        return CGSize(width: collectionView.frame.width, height: height)
//        
//    }
}

extension ConversationDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
//        cell.post = posts[indexPath.row]
//        return cell
        
        return dequeueCell(posts[indexPath.row], indexPath: indexPath, allowHierarchy: true)
    
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
//                                                                               withReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW,
//                                                                               forIndexPath: indexPath) as! PostInHeaderCollectionReusableView
//        headerView.post = post
//        
//        return headerView
//    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
}

//Custom methods and logic.
extension ConversationDetailViewController {
    
//    private func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
//        let nib = UINib(nibName: withName, bundle: nil)
//        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
//        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
//    }
//    
//    private func registerAndCreatePrototypeHeaderViewFromNib(withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
//        let nib = UINib(nibName: withName, bundle: nil)
//        self.collectionView!.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
//        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionReusableView
//    }
    
    private func loadConversationPostDataFromWebservice(postId : String){
        let cmd = TopicCommand(type: .CONVERSATION, postId: postId)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.posts = (response?.list)!
            
            self.collectionView.reloadData()
            
        };
    }
}


