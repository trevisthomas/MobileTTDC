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
    
    private var flatPrototypeCell : FlatCollectionViewCell!
    private var replyPrototypeCell : ReplyCollectionViewCell!
    private var sectionHeaderPrototype : PostInHeaderCollectionReusableView!
    
    private var originalHeight : CGFloat!
    private var originalTopOfDisapearingView : CGFloat!
    private var statusBarHeight : CGFloat!
    private var originalTopOfCollectionView : CGFloat!
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var modeSelectionView: UIView!
    
    @IBOutlet weak var modeSelectionHeightConstraint: NSLayoutConstraint!
    
    @IBAction func modeSelectSegmentedControll(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Selected flat")
            getApplicationContext().displayMode = .LatestFlat
        default:
            print("Selected grouped")
            getApplicationContext().displayMode = .LatestGrouped
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApplicationContext().latestPostsObserver = self
        collectionView.delegate = self //For the layout delegate
        
        flatPrototypeCell = registerAndCreatePrototypeCellFromNib("FlatCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL) as! FlatCollectionViewCell
        
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
        
        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifiers.EMPTY_HEADER_VIEW)
        
        handleModeChange()
//        getApplicationContext().displayMode = .LatestFlat
    }
    
    //This is here so that the layout will adjust when you "maximize"
    override func viewWillLayoutSubviews() {
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        originalTopOfCollectionView = collectionView.frame.origin.y
        originalTopOfDisapearingView = originalTopOfCollectionView - modeSelectionHeightConstraint.constant
        statusBarHeight = originalTopOfDisapearingView
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
        switch (getApplicationContext().displayMode) {
        case .LatestFlat:
            flatPrototypeCell.post = getApplicationContext().latestPosts()[indexPath.row]
            height = flatPrototypeCell.preferredHeight(collectionView.frame.width)
            
        case .LatestGrouped:
            replyPrototypeCell.post = getApplicationContext().latestPosts()[indexPath.section].posts![indexPath.row]
            height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        switch getApplicationContext().displayMode {
        case .LatestFlat:
            return CGSizeZero
        case .LatestGrouped:
            sectionHeaderPrototype.post = getApplicationContext().latestPosts()[section]
            let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        
        
    }
}

extension LatestPostsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        adjustHistoryViewBecauseScrollChangedAllTheWay()
    }
    
    func adjustHistoryViewBecauseScrollChangedAllTheWay(){
        let yOffset = collectionView.contentOffset.y
        
        if(yOffset <= 0){
            collectionView.frame.origin.y = originalTopOfCollectionView 
            modeSelectionView.frame.origin.y = originalTopOfDisapearingView
            
        } else if yOffset < modeSelectionHeightConstraint.constant + originalTopOfDisapearingView - statusBarHeight{
            collectionView.frame.origin.y = originalTopOfCollectionView - collectionView.contentOffset.y
            modeSelectionView.frame.origin.y = originalTopOfDisapearingView - collectionView.contentOffset.y
        } else {
            collectionView.frame.origin.y = 0 + statusBarHeight
            modeSelectionView.frame.origin.y = -modeSelectionHeightConstraint.constant + statusBarHeight
        }
    }
}

extension LatestPostsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        switch getApplicationContext().displayMode{
        case .LatestFlat:
            return 1
        case .LatestGrouped:
            return getApplicationContext().latestPosts().count
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getApplicationContext().displayMode{
        case .LatestFlat:
            return getApplicationContext().latestPosts().count
        case .LatestGrouped:
            return getApplicationContext().latestPosts()[section].posts!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch (getApplicationContext().displayMode) {
        case .LatestFlat:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.FLAT_POST_CELL, forIndexPath: indexPath) as! FlatCollectionViewCell
            cell.post = getApplicationContext().latestPosts()[indexPath.row]
            return cell;
            
        case .LatestGrouped:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
            cell.post = getApplicationContext().latestPosts()[indexPath.section].posts![indexPath.row]
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                               withReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW,
                                                                               forIndexPath: indexPath) as! PostInHeaderCollectionReusableView
        headerView.post = getApplicationContext().latestPosts()[indexPath.section]
        
        return headerView
    }
    
}

//Custom methods and logic.
extension LatestPostsViewController {
    
    func handleModeChange(){
        switch getApplicationContext().displayMode{
        case .LatestGrouped:
            self.navigationController?.navigationBar.topItem?.title = "Latest - Grouped"
            modeSegmentedControl.selectedSegmentIndex = 1
        case .LatestFlat:
            self.navigationController?.navigationBar.topItem?.title = "Latest - Flat"
            modeSegmentedControl.selectedSegmentIndex = 0
        }
        
    }
    
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
}

extension LatestPostsViewController : LatestPostsObserver {
    func latestPostsUpdated(){
        self.collectionView.reloadData()
    }
    func displayModeChanged(){
        handleModeChange()
    }
    func authenticatedUserChanged(){
        
    }
    func networkError(error : String){
        self.presentAlert("Sorry", message: error)
    }
}