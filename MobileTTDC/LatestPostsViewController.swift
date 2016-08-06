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
    
    @IBAction func presentCommentCreationView(sender: UIBarButtonItem) {
        
        //http://www.appcoda.com/presentation-controllers-tutorial/
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CommentCreator") as! UINavigationController
//        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        popover.delegate = self
//        popover.barButtonItem = sender
        
//        popover.sourceView = modeSegmentedControl
//        popover.sourceView = self.view
//        let center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
//        popover.sourceRect = CGRect(origin: center, size: CGSize(width: 10, height: 10))
        
//        popover.sourceRect = CGRect(x: view.bounds.width / 2 - 200, y: view.bounds.height / 2, width: 1, height: 1)
//        
//        presentViewController(vc, animated: true, completion:nil)
        
        vc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        presentViewController(vc, animated: true, completion:nil)

//        vc.modalPresentationStyle = UIModalPresentationStyle.PageSheet
//        presentViewController(vc, animated: true, completion:nil)

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        guard let indexPath = sender as? NSIndexPath else {
//            return
//        }
//        
        guard let nav = segue.destinationViewController as? UINavigationController else {
            return
        }
        
        guard let vc = nav.topViewController as? ConversationWithReplyViewController else {
            return
        }
//
//        
//        var threadId : String!
//        switch (getApplicationContext().displayMode) {
//            case .LatestFlat:
//            let post = getApplicationContext().latestPosts()[indexPath.row]
//            threadId = post.threadId
//            
//            case .LatestGrouped:
//            let post = getApplicationContext().latestPosts()[indexPath.section].posts![indexPath.row]
//            threadId = post.threadId
//        }
        
        let dict = sender as! [String: String]
        
//        let threadId = sender as! String
        
        print(dict["threadId"])
    
//        vc.postId = dict["threadId"]
        
        vc.postId = dict["threadId"]
        if let postId = dict["postId"] {
            vc.replyToPostId = postId
        }
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
    
    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        switch (getApplicationContext().displayMode) {
        
//        performSegueWithIdentifier("ConversationWithReplyView", sender: indexPath)
            
//        case .LatestFlat:
//            let post = getApplicationContext().latestPosts()[indexPath.row]
//            print(post.postId)
//            
//            performSegueWithIdentifier("ConversationWithReplyView", sender: indexPath)
//            
//        case .LatestGrouped:
//            let post = getApplicationContext().latestPosts()[indexPath.section].posts![indexPath.row]
//            print(post.postId)
//        }
    }
 */
    
//    func collec
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch (getApplicationContext().displayMode) {
        case .LatestFlat:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.FLAT_POST_CELL, forIndexPath: indexPath) as! FlatCollectionViewCell
            cell.post = getApplicationContext().latestPosts()[indexPath.row]
            cell.delegate = self
            return cell
            
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

extension LatestPostsViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        print("Am i only caled on the iphone?")
        return UIModalPresentationStyle.FullScreen
//         return UIModalPresentationStyle.None
    }
//    
//    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
////        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
//////        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
//////        navigationController.topViewController.navigationItem.rightBarButtonItem = btnDone
////        
////        print("Compact?")
////        
////        return navigationController
//        
//
////        return controller
//        
//        return controller.presentingViewController
//    }
}

extension LatestPostsViewController : PostViewCellDelegate{
    func likePost(post: Post){
        
    }
    func viewComments(post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)
    }
    func commentOnPost(post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        dict["postId"] = post.postId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)
    }
}