//
//  MainViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/6/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var posts : [Post] = []
    private var sizingCellPrototype : FlatCollectionViewCell!
    
    override func viewDidLoad() {
        
        let nib = UINib(nibName: "FlatCollectionViewCell", bundle: nil)
        
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL)
        
        collectionView.delegate = self //For the layout delegate
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIInterfaceOrientation, object: nil)
        
        
        sizingCellPrototype = nib.instantiateWithOwner(nil, options: nil)[0] as! FlatCollectionViewCell
        
        loadDataFromWebservice()
        
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone){
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
        } else {
            //Forcing the master to be visible all the time on ipad
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            
            
            //Expanding icon functionality.  If this runs on the iphone you have no button to navigate to the master view
            self.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem();
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation")
        
        
    
        
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
//        coordinator.animateAlongsideTransition(nil, completion:  { (UIViewControllerTransitionCoordinatorContext) -> () in
//            //            self.collectionView.invalidateIntrinsicContentSize()
//            
//            self.collectionView.performBatchUpdates(nil, completion: nil) //This invalidates the CollectionView sizes
//            
//
//        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        
        //        guard (postForSegue != nil) else{
        //            return;
        //        }
        guard let converstionDetailController = destination as? ConversationDetailViewController else {
            return;
        }
        guard let covversationController = sender as? ConversationsViewController else {
            return;
        }
        
        converstionDetailController.post = covversationController.postForSegue
       
        
//        if postForSegue == nil {
//            return;
//        }
//        
//        if let navcon = destination as? UINavigationController{
//            destination = navcon.visibleViewController!
//            
//            navcon.performSegueWithIdentifier("ConversationDetail", sender: self)
//        }
        
        
        //        //ConversationDetail
        //        if let hvc = destination as? ConversationDetailViewController {
        //            if let identifier = segue.identifier {
        //                print(segue.identifier)
        ////                switch identifier{
        ////                case "Sad": hvc.happiness = 0
        ////                case "Happy": hvc.happiness = 100
        ////                case "Nothing" : hvc.happiness = 75
        ////                default: hvc.happiness = 50
        ////                }
        //            }
        //        }
    }
    
    
    //This is here so that the layout will adjust when you "maximize"
    override func viewWillLayoutSubviews() {
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.FLAT_POST_CELL, forIndexPath: indexPath) as! FlatCollectionViewCell
        
        cell.post = posts[indexPath.row]
        return cell
    }
    
}

extension MainViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        sizingCellPrototype.post = posts[indexPath.row]
//        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
//        return CGSize(width: collectionView.frame.width, height: height)
        
        sizingCellPrototype.post = posts[indexPath.row]
        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    
}

//Business logic helpers
extension MainViewController{
    
    
    func loadDataFromWebservice(){
        let cmd = PostCommand(action: PostCommand.Action.LATEST_FLAT, pageNumber: 1)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.posts = (response?.list)!
            
            self.collectionView.reloadData()
            
            //            print(response!.totalResults)
            //            
            //            for post in response!.list {
            //                print("\(post.postId) at \(post.date) by \(post.creator.login) : \(post.creator.image?.name)" )
            //            }
        };
    }
}

