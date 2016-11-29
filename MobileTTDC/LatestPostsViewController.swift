//
//  LatestPostsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LatestPostsViewController: CommonBaseViewController, BroadcastPostAddConsumer {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var originalHeight : CGFloat!
    fileprivate var originalTopOfDisapearingView : CGFloat!
    fileprivate var statusBarHeight : CGFloat!
    fileprivate var originalTopOfCollectionView : CGFloat!
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var modeSelectionView: UIView!
    
    @IBOutlet weak var modeSelectionHeightConstraint: NSLayoutConstraint!
    
    @IBAction func modeSelectSegmentedControll(_ sender: UISegmentedControl) {
        super.removeAllPosts()
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("Selected flat")
            getApplicationContext().displayMode = .latestFlat
        case 1:
            print("Selected grouped")
            getApplicationContext().displayMode = .latestGrouped
        case 2:
            getApplicationContext().displayMode = .latestConversations
        default:
            abort()
        }
//        handleModeChange()
        
//        removeAllPosts()
        
        loadFirstPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleModeChange()
        
        getApplicationContext().broadcaster.subscribeForPostAdd(consumer: self)
        
//        loadFirstPage()
    }
    
    
    override func refreshStyle() {
        modeSegmentedControl.tintColor = getApplicationContext().getCurrentStyle().tintColor()
        modeSelectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
//        modeSelectionView.backgroundColor = getApplicationContext().getCurrentStyle().underneath()
//        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().underneath()
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
        
    }
    
    //This is here so that the layout will adjust when you "maximize"
//    override func viewWillLayoutSubviews() {
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }
    
    override func viewDidLayoutSubviews() {
        originalTopOfCollectionView = collectionView.frame.origin.y
        originalTopOfDisapearingView = originalTopOfCollectionView - modeSelectionHeightConstraint.constant
        statusBarHeight = originalTopOfDisapearingView
    }
    
//    override func loadPosts(completion: @escaping ([Post]?) -> Void) {
//        print("Load Posts - latest")
//        switch getApplicationContext().displayMode {
//        case .latestGrouped:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, completion: completion)
//        case .latestFlat:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, completion: completion)
//        case .latestConversations:
//            loadlatestConversationsFromWebservice(pageNumber: 1, completion: completion)
//        }
//        
//    }
//    
//    override func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
//        print("Load More Posts - latest")
//        switch getApplicationContext().displayMode {
//        case .latestGrouped:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, pageNumber: pageNumber, completion: completion)
//        case .latestFlat:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, pageNumber: pageNumber, completion: completion)
//        case .latestConversations:
//            loadlatestConversationsFromWebservice(pageNumber: pageNumber, completion: completion)
//        }
//    }
    
    
    fileprivate func loadlatestPostDataFromWebservice(_ action: PostCommand.Action, pageNumber: Int = 1, completion: @escaping ([Post]?) -> Void){
        let cmd = PostCommand(action: action, pageNumber: pageNumber)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: message!)
                return;
            }
            
            let posts = (response?.list)!
            
            if self.getApplicationContext().displayMode == .latestGrouped {
                completion(posts.flattenPosts())
            } else {
                completion(posts)
            }
        };
    }
    
    fileprivate func loadlatestConversationsFromWebservice(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageNumber: pageNumber)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            guard (response != nil) else {
                self.presentAlert("Error", message: message!)
                completion(nil)
                return;
            }
            
            completion((response?.list)!)
            
        };
    }
    
    override func allowHierarchy() -> Bool {
        return getApplicationContext().displayMode == .latestGrouped
    }
    
    override func onCurrentUserChanged() {
        removeAllPosts()
        loadFirstPage()
    }
    
    @IBAction func presentCommentCreationView(_ sender: UIBarButtonItem) {
        
//        //http://www.appcoda.com/presentation-controllers-tutorial/
//        let storyboard : UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CommentCreator") as! UINavigationController
//        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
//        present(vc, animated: true, completion:nil)
        //loadFirstPage()
    }
    
    
    internal func onPostAdded(post: Post) {
        print("LatestVC sees post \(post.postId)")
        
        loadFirstPage()
        
//        switch getApplicationContext().displayMode{
//        case .latestConversations :
//            loadFirstPage()
//        case .latestGrouped:
//            loadFirstPage()
//        case .latestFlat:
//            //            self.navigationController?.navigationBar.topItem?.title = "Doesnt work anyway"
//            modeSegmentedControl.selectedSegmentIndex = 2
//        }

        //onPostAdded
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        
//        print("Orientation: PostDetailViewController")
//        
//        coordinator.animate(alongsideTransition: { context in
//            // do whatever with your context
//            context.viewController(forKey: UITransitionContextViewControllerKey.from)
//        }, completion: {context in
//            self.sizeCache = []
//            self.loadSizeCache(posts: self.posts) {
//                self.getCollectionView()?.collectionViewLayout.invalidateLayout()
//            }
//        }
//        )
//    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//    }
    
//    override func onPostUpdated(post: Post) {
//        print("VC sees post \(post.postId)")
//    }
    
    


}

extension LatestPostsViewController /*: UIScrollViewDelegate*/ {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
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


//Custom methods and logic.
extension LatestPostsViewController {
    
    func handleModeChange(){
        switch getApplicationContext().displayMode{
        case .latestConversations :
            modeSegmentedControl.selectedSegmentIndex = 0
        case .latestGrouped:
            modeSegmentedControl.selectedSegmentIndex = 1
        case .latestFlat:
//            self.navigationController?.navigationBar.topItem?.title = "Doesnt work anyway"
            modeSegmentedControl.selectedSegmentIndex = 2
        }
        
    }

    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
    }

extension LatestPostsViewController : PostCollectionViewDelegate {
    func loadPosts(completion: @escaping ([Post]?) -> Void) {
        print("Load Posts - latest")
        switch getApplicationContext().displayMode {
        case .latestGrouped:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, completion: completion)
        case .latestFlat:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, completion: completion)
        case .latestConversations:
            loadlatestConversationsFromWebservice(pageNumber: 1, completion: completion)
        }
        
    }
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
        print("Load More Posts - latest")
        switch getApplicationContext().displayMode {
        case .latestGrouped:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, pageNumber: pageNumber, completion: completion)
        case .latestFlat:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, pageNumber: pageNumber, completion: completion)
        case .latestConversations:
            loadlatestConversationsFromWebservice(pageNumber: pageNumber, completion: completion)
        }
    }
}


//extension LatestPostsViewController : LatestPostsObserver {
//    func latestPostsUpdated(){
//        self.collectionView.reloadData()
//    }
//    func displayModeChanged(){
//        handleModeChange()
//    }
//    func authenticatedUserChanged(){
//        
//    }
//    func networkError(_ error : String){
//        self.presentAlert("Sorry", message: error)
//    }
//}

//extension LatestPostsViewController : UIPopoverPresentationControllerDelegate {
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        print("Am i only caled on the iphone?")
//        return UIModalPresentationStyle.fullScreen
//    }
//}
