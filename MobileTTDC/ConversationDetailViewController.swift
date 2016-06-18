//
//  ConversationDetailViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationDetailViewController: UIViewController {

    var post : Post! {
        didSet{
            //Load it!
        }
    }
    private var posts : [Post] = []
    @IBOutlet weak var collectionView: UICollectionView!
    private var sizingCellPrototype : ReplyCollectionViewCell!
    
    var closeBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(ConversationDetailViewController.closeButtonClicked(_:)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReplyCollectionViewCell", bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL)
        collectionView?.delegate = self //For the layout delegate
        
        sizingCellPrototype = nib.instantiateWithOwner(nil, options: nil)[0] as! ReplyCollectionViewCell
        
        if post != nil {
            loadDataFromWebservice()
        }
        
        self.navigationItem.rightBarButtonItem = closeBarButtonItem
        
        //trying to get expandable functionlality
        self.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem();
        
    }

    func loadDataFromWebservice(){
        let cmd = TopicCommand(type: .CONVERSATION, postId: post.postId)
        
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
    
    func closeButtonClicked(sender : UIButton){
        print("Sup, playuh")
        
//        let detailNav = splitViewController?.viewControllers.last as! UINavigationController
////        detailNav.popViewControllerAnimated(true)
//        detailNav.popToRootViewControllerAnimated(true)
        
//        let detailNav = splitViewController?.viewControllers.first as! UINavigationController
//        //        detailNav.popViewControllerAnimated(true)
//        detailNav.popToRootViewControllerAnimated(true)
        
//        let detail = storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as!  MainViewController
//        let conversations = storyboard?.instantiateViewControllerWithIdentifier("ConversationsViewController") as!  ConversationsViewController
        let detailNav = splitViewController?.viewControllers.last as! UINavigationController
        let masterNav = splitViewController?.viewControllers.first as! UINavigationController
//        masterNav.setViewControllers([conversations], animated: true)
//        detailNav.setViewControllers([detail], animated: true)
        
        
        
        
        
        
        masterNav.popToRootViewControllerAnimated(true)
        detailNav.popToRootViewControllerAnimated(true)
        
//        detailNav.pushViewController(vc, animated: true)
//        detailNav.popToViewController(vc, animated: true)
//        detailNav.setViewControllers([vc], animated: true)
        
//        detailNav.popToRootViewControllerAnimated(false)
//        detailNav.pushViewController(vc, animated: true)
        
        
        
        
    }

}

extension ConversationDetailViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        sizingCellPrototype.post = posts[indexPath.row]
        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
        
        cell.post = posts[indexPath.row]
        return cell
    }
    
}


