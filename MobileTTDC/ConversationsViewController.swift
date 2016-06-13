//
//  ConversationsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {
    
    private var posts : [Post] = []
    private var sizingCellPrototype : ConversationCollectionViewCell!
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ConversationCollectionViewCell", bundle: nil)
        
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.CONVERSATION_POST_CELL)
        
        collectionView?.delegate = self //For the layout delegate
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIInterfaceOrientation, object: nil)
        
        
        sizingCellPrototype = nib.instantiateWithOwner(nil, options: nil)[0] as! ConversationCollectionViewCell
        
        loadDataFromWebservice()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout() //Just incase the orientation changed when you werent visible
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: ConversationsViewController")
        collectionView?.collectionViewLayout.invalidateLayout()
    }

 
}

extension ConversationsViewController{
    
    
    func loadDataFromWebservice(){
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.posts = (response?.list)!
            
            self.collectionView?.reloadData()
            
            //            print(response!.totalResults)
            //
            //            for post in response!.list {
            //                print("\(post.postId) at \(post.date) by \(post.creator.login) : \(post.creator.image?.name)" )
            //            }
        };
    }
}

extension ConversationsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        sizingCellPrototype.post = posts[indexPath.row]
        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
    }
}


extension ConversationsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.CONVERSATION_POST_CELL, forIndexPath: indexPath) as! ConversationCollectionViewCell
        
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
//        let nav = storyboard?.instantiateViewControllerWithIdentifier("ConversationDetail") as!  UINavigationController
//        let detail = nav.viewControllers.first as! ConversationDetailViewController
//        detail.post = posts[indexPath.row]
//        splitViewController?.showDetailViewController(detail, sender: self)
        
        //ConversationDetailViewController
        //MainViewController
        
//        let detail = storyboard?.instantiateViewControllerWithIdentifier("ConversationDetailViewController") as!  ConversationDetailViewController
//        detail.post = posts[indexPath.row]
//        splitViewController?.viewControllers.last?.presentViewController(detail, animated: true, completion: nil)
        
        let detail = storyboard?.instantiateViewControllerWithIdentifier("ConversationDetailViewController") as!  ConversationDetailViewController
        detail.post = posts[indexPath.row]
        
        let detailNav = splitViewController?.viewControllers.last as! UINavigationController
        detailNav.pushViewController(detail, animated: true)

    }
}
