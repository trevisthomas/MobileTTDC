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
    
    fileprivate var originalHeight : CGFloat!
    fileprivate var originalTopOfDisapearingView : CGFloat!
    fileprivate var statusBarHeight : CGFloat!
    fileprivate var originalTopOfCollectionView : CGFloat!
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var modeSelectionView: UIView!
    
    @IBOutlet weak var modeSelectionHeightConstraint: NSLayoutConstraint!
    
    @IBAction func modeSelectSegmentedControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Selected flat")
            getApplicationContext().displayMode = .latestFlat
        default:
            print("Selected grouped")
            getApplicationContext().displayMode = .latestGrouped
        }
        
    }
    
    @IBAction func presentCommentCreationView(_ sender: UIBarButtonItem) {
        
        //http://www.appcoda.com/presentation-controllers-tutorial/
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentCreator") as! UINavigationController
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
        
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(vc, animated: true, completion:nil)

//        vc.modalPresentationStyle = UIModalPresentationStyle.PageSheet
//        presentViewController(vc, animated: true, completion:nil)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApplicationContext().latestPostsObserver = self
        collectionView.delegate = self //For the layout delegate
        
        handleModeChange()
        
//        self.navigationController?.navigationBar.translucent = true
//        self.navigationController?.navigationBar.alpha = 0.5
//        self.navigationController?.navigationBar.tintColor = UIColor.greenColor()
//        self.navigationController?.navigationBar.barTintColor = UIColor.yellowColor()
        
        registerForStyleUpdates()
    }
    
    override func refreshStyle() {
        modeSegmentedControl.tintColor = getApplicationContext().getCurrentStyle().tintColor()
        
        modeSelectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        
//        collectionView.
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
        
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: PostDetailViewController")
        
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
            }, completion: {context in
                self.collectionView?.collectionViewLayout.invalidateLayout()
                
            }
        )
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        return true;
    }
    
    /*
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
 */
}


extension LatestPostsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let post = getApplicationContext().latestPosts()[indexPath.row]
        
        return prototypeCellSize(post: post, allowHierarchy: (getApplicationContext().displayMode == .latestGrouped))
    }
    
}

extension LatestPostsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getApplicationContext().latestPosts().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let post = getApplicationContext().latestPosts()[indexPath.row]
        
        return dequeueCell(post, indexPath: indexPath, allowHierarchy : (getApplicationContext().displayMode == .latestGrouped))
    }
    
    
   
}

//Custom methods and logic.
extension LatestPostsViewController {
    
    func handleModeChange(){
        switch getApplicationContext().displayMode{
        case .latestGrouped:
            self.navigationController?.navigationBar.topItem?.title = "Latest - Grouped"
            modeSegmentedControl.selectedSegmentIndex = 1
        case .latestFlat:
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
    func networkError(_ error : String){
        self.presentAlert("Sorry", message: error)
    }
}

extension LatestPostsViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        print("Am i only caled on the iphone?")
        return UIModalPresentationStyle.fullScreen
    }
}
