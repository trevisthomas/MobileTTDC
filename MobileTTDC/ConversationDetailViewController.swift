//
//  ConversationViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

//Deprecated?
class ConversationDetailViewController: PostBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
  fileprivate var posts : [Post] = []
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
        
        
        /*
         
         
         
         
         */
        assert(false)
        /*
         
         
         
         
         */
        
        super.viewDidLoad()
        
        collectionView.delegate = self //For the layout delegate
        
        
//        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
//        
//        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
//        
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifiers.EMPTY_HEADER_VIEW)
        
        
//        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay
        
        

//        self.splitViewController.preferredDisplayMode = 
        
        
        if (UIDevice.current.userInterfaceIdiom == .phone){
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
        } else {
            //Forcing the master to be visible all the time on ipad
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
            //Expanding icon functionality.  If this runs on the iphone you have no button to navigate to the master view
            self.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem;
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
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {
        print("prep for unwind")
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        return false
    }
}

extension ConversationDetailViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    fileprivate func loadConversationPostDataFromWebservice(_ postId : String){
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


