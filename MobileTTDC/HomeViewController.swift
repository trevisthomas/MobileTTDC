//
//  HomeViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private struct ReuseIdentifiers{
        static let FLAT_POST_CELL = "FlatPostCell"
        static let GROUPED_POST_CELL = "GroupedPostCell"
    }

    @IBOutlet weak var collectionView: UICollectionView!
    private var posts : [Post] = []
    
    override func viewDidLoad() {
        self.collectionView!.registerNib(UINib(nibName: "FlatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL)
        
        collectionView.delegate = self //For the layout delegate
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIInterfaceOrientation, object: nil)
        
        
        loadDataFromWebservice()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation")
        
        coordinator.animateAlongsideTransition(nil, completion:  { (UIViewControllerTransitionCoordinatorContext) -> () in
//            self.collectionView.invalidateIntrinsicContentSize()
            self.collectionView.performBatchUpdates(nil, completion: nil) //This invalidates the CollectionView sizes
        })
        
//        self.collectionView.invalidateIntrinsicContentSize()
//        self.collectionView.performBatchUpdates(nil, completion: nil) //This invalidates the CollectionView sizes
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        // Configure the cell
        
        print("Create reusable for \(indexPath)")
        
        cell.post = posts[indexPath.row]
        return cell
    }

}

extension HomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        print("Size for \(indexPath.row)")
        
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}

//Business logic helpers
extension HomeViewController{
    
    
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

