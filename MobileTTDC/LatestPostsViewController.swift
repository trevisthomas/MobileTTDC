//
//  LatestPostsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LatestPostsViewController: PostBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        handleModeChange()
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
      
        guard let nav = segue.destinationViewController as? UINavigationController else {
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
        
        print(dict["threadId"])
    
        vc.postId = dict["threadId"]
        if let postId = dict["postId"] {
            vc.replyToPostId = postId
        }
    }
}


extension LatestPostsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let post = getApplicationContext().latestPosts()[indexPath.row]
        
        return prototypeCellSize(post: post, allowHierarchy: (getApplicationContext().displayMode == .LatestGrouped))
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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getApplicationContext().latestPosts().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let post = getApplicationContext().latestPosts()[indexPath.row]
        
        return dequeueCell(post, indexPath: indexPath, allowHierarchy : (getApplicationContext().displayMode == .LatestGrouped))
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

    override func getCollectionView() -> UICollectionView? {
        return collectionView
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
    }
}
