//
//  LatestPostsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LatestPostsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var posts : [Post] = []
    private var flatPrototypeCell : FlatCollectionViewCell!
    private var replyPrototypeCell : ReplyCollectionViewCell!
    private var sectionHeaderPrototype : PostInHeaderCollectionReusableView!
    private var post : Post!
    private var displayMode : DisplayMode = .LatestFlat
    
    enum DisplayMode{
        case LatestFlat
        case LatestGrouped
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self //For the layout delegate
        
        flatPrototypeCell = registerAndCreatePrototypeCellFromNib("FlatCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL) as! FlatCollectionViewCell
        
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
        
        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifiers.EMPTY_HEADER_VIEW)
        
        loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT)
        
        /*
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone){
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
        } else {
            //Forcing the master to be visible all the time on ipad
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            //Expanding icon functionality.  If this runs on the iphone you have no button to navigate to the master view
            self.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem();
        }
 */
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
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true;
    }
}


extension LatestPostsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height : CGFloat
        switch (displayMode) {
        case .LatestFlat:
            flatPrototypeCell.post = posts[indexPath.row]
            height = flatPrototypeCell.preferredHeight(collectionView.frame.width)
            
        case .LatestGrouped:
            height = 100 // TODO
            
//        case .SingleConverstaion:
//            height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        /*
        switch displayMode{
        case .LatestFlat, .LatestGrouped:
            return CGSizeZero
        case .SingleConverstaion:
            sectionHeaderPrototype.post = post
            let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        */
        return CGSizeZero
        
    }
}

extension LatestPostsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch (displayMode) {
        case .LatestFlat:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.FLAT_POST_CELL, forIndexPath: indexPath) as! FlatCollectionViewCell
            cell.post = posts[indexPath.row]
            return cell;
            
        case .LatestGrouped:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
            cell.post = posts[indexPath.row]
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        guard let _ = post else{
            return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ReuseIdentifiers.EMPTY_HEADER_VIEW, forIndexPath: indexPath)
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                               withReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW,
                                                                               forIndexPath: indexPath) as! PostInHeaderCollectionReusableView
        
        headerView.post = post
        
        return headerView
    }
    
}

//Custom methods and logic.
extension LatestPostsViewController {
    
    
    private func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
    }
    
    private func registerAndCreatePrototypeHeaderViewFromNib(withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
        let nib = UINib(nibName: withName, bundle: nil)
        self.collectionView!.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionReusableView
    }
    
    private func loadlatestPostDataFromWebservice(action: PostCommand.Action){
        let cmd = PostCommand(action: action, pageNumber: 1)
        
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