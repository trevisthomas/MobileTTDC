//
//  PostDetailViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/18/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var posts : [Post] = []
    private var flatPrototypeCell : FlatCollectionViewCell!
    private var replyPrototypeCell : ReplyCollectionViewCell!
    private var post : Post!
    
    enum DisplayMode{
        case LatestFlat
        case LatestGrouped
        case SingleConverstaion
    }
    
    private var displayMode : DisplayMode = .LatestFlat{ //Trevis, xcode forced you to set a default.  Turns out that setting the default does not execute the didSet.  I would have rathered just defined displaymode as being an explicitly unwrapped optional but that does not compile with xcode 7.3.1
        didSet {
            self.navigationItem.rightBarButtonItem = nil
            switch displayMode {
            case .LatestFlat:
                loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT)
            case .LatestGrouped:
                loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED)
            case .SingleConverstaion:
                self.navigationItem.rightBarButtonItem = closeBarButtonItem
                loadConversationPostDataFromWebservice(post.postId)
            }
        }
    }
    
    private var closeBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(closeButtonClicked(_:)))
    }
    
    
    func changeDisplayMode(toDisplayMode: DisplayMode, withContext: Post? = nil) {
        post = withContext
        displayMode = toDisplayMode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self //For the layout delegate
        
        flatPrototypeCell = registerAndCreatePrototypeCellFromNib("FlatCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL) as! FlatCollectionViewCell
        
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
        
        displayMode = .LatestFlat
        
        
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

}

extension PostDetailViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height : CGFloat
        switch (displayMode) {
        case .LatestFlat:
            flatPrototypeCell.post = posts[indexPath.row]
            height = flatPrototypeCell.preferredHeight(collectionView.frame.width)
            
        case .LatestGrouped:
            height = 100 // TODO
            
        case .SingleConverstaion:
            height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
}

extension PostDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
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

        case .SingleConverstaion, .LatestGrouped:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
            cell.post = posts[indexPath.row]
            return cell
        }
    }
    
}

extension PostDetailViewController {
    
    func closeButtonClicked(sender : UIButton){
        displayMode = .LatestFlat //TODO! Once you add the spliter the close button should revert to what ever the state was before
    }
    
    private func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
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
