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
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var loadingViewBottomConstraint: NSLayoutConstraint!
    
    let loadingBottomConstantHidden : CGFloat = -100
    let loadingBottomConstantVisible : CGFloat = 30
    
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
        case 3:
            getApplicationContext().displayMode = .latestThreads
        default:
            abort()
        }
//        handleModeChange()
        
//        removeAllPosts()
        
//        loadFirstPage()
        
        getApplicationContext().saveState()
        
        loadDataFromModelOrFromService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.navigationController?.navigationBar.backgroundImage(for: .any, barMetrics: .default) = UIImage()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(
//            UIImage(),
//            for: .any,
//            barMetrics: .default)
//        
//        UINavigationBar.appearance().shadowImage = UIImage()
        
        
        tabBarController?.delegate = self
        
        handleModeChange()
        
        getApplicationContext().latestPostsModel.delegate = self
        
        getApplicationContext().broadcaster.subscribeForPostAdd(consumer: self)
        
//        loadFirstPage()
        
        loadDataFromModelOrFromService()
        
        loadingViewBottomConstraint.constant = loadingBottomConstantHidden
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getApplicationContext().latestPostsModel.addListener(listener: self)
        
        //This was added because I didnt want reload the data every time, because this is fired when you open and close a thread or a conversation.  
        if !getApplicationContext().latestPostsModel.dataChanged {
            return
        }
        
        if let posts = getApplicationContext().latestPostsModel.getPosts(forMode:  getApplicationContext().displayMode) {
            self.posts = posts
            getCollectionView()?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getApplicationContext().latestPostsModel.removeListener(listener: self)
    }
    
    
    private func loadDataFromModelOrFromService() {
        if let list = getApplicationContext().latestPostsModel.getPosts(forMode: getApplicationContext().displayMode) {
            self.posts = list
        } else {
            loadFirstPage()
        }

    }
    
    override func refreshStyle() {
        modeSegmentedControl.tintColor = getApplicationContext().getCurrentStyle().navigationTintColor()
        modeSelectionView.backgroundColor = getApplicationContext().getCurrentStyle().navigationBackgroundColor()
        
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().underneath()
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
        view.backgroundColor = getApplicationContext().getCurrentStyle().underneath()
        
        loadingView.layer.cornerRadius = 4
        loadingView.backgroundColor = getApplicationContext().getCurrentStyle().tabbarBackgroundColor().withAlphaComponent(0.6)
        loadingLabel.textColor = getApplicationContext().getCurrentStyle().entryTextColor()
        loadingActivity.color = getApplicationContext().getCurrentStyle().entryTextColor()
    }
    
    override func viewDidLayoutSubviews() {
        originalTopOfCollectionView = collectionView.frame.origin.y
        originalTopOfDisapearingView = originalTopOfCollectionView - modeSelectionHeightConstraint.constant
        statusBarHeight = originalTopOfDisapearingView
    }
    
    fileprivate func loadlatestPostDataFromWebservice(_ action: PostCommand.Action, pageNumber: Int = 1, completion: @escaping ([Post]?) -> Void){
        let cmd = PostCommand(action: action, pageNumber: pageNumber)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: message!)
                return;
            }
            
            let posts = (response?.list)!
            
            if getApplicationContext().displayMode == .latestGrouped {
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
    
    internal func reloadPosts() {
        loadFirstPage()
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
    
    
//    var prevYOffset : CGFloat = 0.0

}

extension LatestPostsViewController /*: UIScrollViewDelegate*/ {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        adjustHistoryViewBecauseScrollChangedAllTheWay()
    }
    
    func adjustHistoryViewBecauseScrollChangedAllTheWay(){
        let yOffset = collectionView.contentOffset.y
        /*
        if(yOffset < prevYOffset) {
            var distBack = prevYOffset - yOffset
            if (distBack <= originalTopOfCollectionView!) {
              //  print("Back \(distBack)")
            } else {
                distBack = originalTopOfCollectionView
                //print("Back capped \(originalTopOfCollectionView)")
            }
            print("Back \(distBack)")
        } else {
            prevYOffset = yOffset
        }
 
        print("\(yOffset)")
 */
        if(yOffset <= 0){
            collectionView.frame.origin.y = originalTopOfCollectionView 
            modeSelectionView.frame.origin.y = originalTopOfDisapearingView
            
        } else if yOffset < modeSelectionHeightConstraint.constant + originalTopOfDisapearingView - statusBarHeight{
            //print("Between")
            collectionView.frame.origin.y = originalTopOfCollectionView - collectionView.contentOffset.y
            modeSelectionView.frame.origin.y = originalTopOfDisapearingView - collectionView.contentOffset.y
        } else {
            
            //print("shut")
            collectionView.frame.origin.y = 0 + statusBarHeight
            modeSelectionView.frame.origin.y = -modeSelectionHeightConstraint.constant + statusBarHeight
        }
    }
    
    func showLoadingAnimation(){
//        self.loadingView.layoutIfNeeded()
        loadingViewBottomConstraint.constant = loadingBottomConstantVisible
//        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [.curveEaseIn], animations: {
//            self.loadingView.layoutIfNeeded()
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
    }
    
    func hideLoadingAnimation(){
//        self.loadingView.layoutIfNeeded()
        loadingViewBottomConstraint.constant = loadingBottomConstantHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}


//Custom methods and logic.
extension LatestPostsViewController {
    
    func handleModeChange(){
        switch getApplicationContext().displayMode{
        case .latestFlat:
            modeSegmentedControl.selectedSegmentIndex = 0
        case .latestGrouped:
            modeSegmentedControl.selectedSegmentIndex = 1
        case .latestConversations :
            modeSegmentedControl.selectedSegmentIndex = 2
        case .latestThreads:
            modeSegmentedControl.selectedSegmentIndex = 3
        }
        
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
}

//extension LatestPostsViewController : PostCollectionViewDelegate {
//    func loadPosts(completion: @escaping ([Post]?) -> Void) {
//        print("Load Posts - latest")
//        switch getApplicationContext().displayMode {
//        case .latestGrouped:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, completion: completion)
//        case .latestFlat:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, completion: completion)
//        case .latestConversations:
//            loadlatestConversationsFromWebservice(pageNumber: 1, completion: completion)
//        case .latestThreads:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_THREADS, completion: completion)
//        }
//        
//    }
//    
//    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
//        print("Load More Posts - latest")
//        switch getApplicationContext().displayMode {
//        case .latestGrouped:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, pageNumber: pageNumber, completion: completion)
//        case .latestFlat:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, pageNumber: pageNumber, completion: completion)
//        case .latestConversations:
//            loadlatestConversationsFromWebservice(pageNumber: pageNumber, completion: completion)
//        case .latestThreads:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_THREADS, pageNumber: pageNumber,completion: completion)
//        }
//    }
//}


extension LatestPostsViewController : PostCollectionViewDelegate {
    func loadPosts(completion: @escaping ([Post]?, Bool) -> Void) {
        getApplicationContext().latestPostsModel.loadFirstPage(displayMode: getApplicationContext().displayMode, completion: completion)
    }
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?, Bool) -> Void) {
        //Heads up!  Page number is ignored for latest! The model handles it.
        print("Load More Posts - latest")
        getApplicationContext().latestPostsModel.loadNextPage(displayMode: getApplicationContext().displayMode, completion: completion)
    }
}

extension LatestPostsViewController : LatestPostDelegate {
    func dataLoadError(message : String) {
        self.presentAlert("Sorry", message: message)
    }
    func dataUpdated(displayMode : DisplayMode, posts : [Post]) {
        if getApplicationContext().displayMode == displayMode {
            //The idea is that i'm just swapping out the list.  The length should be the same.  Size will be nil, but the base should be able to handle that and recalculate it.  Also, no need to reload the collection view because the Cell's are updated another way.  Is this the best idea?
            self.posts = posts
        }
        print("Data updated, or at leastt that's what the model says")
    }
    
    func willLoadData() {
        self.showLoadingAnimation()
    }
    
    func didLoadData() {
        self.hideLoadingAnimation()
    }
}

extension LatestPostsViewController : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let _ = tabBarController.selectedViewController?.childViewControllers.contains(self) {
            let indexPath = IndexPath(item: 0, section: 0)
            getCollectionView()?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
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


extension LatestPostsViewController : PostUpdateListener {
    func getDisplayMode() -> DisplayMode {
        return getApplicationContext().displayMode
    }
    
    func onPostUpdated(post : Post, index : Int) {
        invokeLater{
            self.posts[index] = post
            let path = IndexPath(item: index, section: 0)
            if let cell = self.getCollectionView()?.cellForItem(at: path) as? BaseCollectionViewCell {
                cell.post = post
            } /*else {
             _ = dequeueCell(post, indexPath: path)
             }*/
        }
    }
}
