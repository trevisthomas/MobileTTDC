//
//  MainViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/6/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private struct ReuseIdentifiers{
        static let FLAT_POST_CELL = "FlatPostCell"
        
        static let GROUPED_POST_CELL = "GroupedPostCell"
        
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var posts : [Post] = []
    private var sizingFlatCell : FlatCollectionViewCell!
    
//    var sizeDictionary = [Int: CGSize]()
    
    override func viewDidLoad() {
        
        
        
        let nib = UINib(nibName: "FlatCollectionViewCell", bundle: nil)
        
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL)
        
        collectionView.delegate = self //For the layout delegate
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIInterfaceOrientation, object: nil)
        
        
        sizingFlatCell = nib.instantiateWithOwner(nil, options: nil)[0] as! FlatCollectionViewCell
        
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
        
        
        // Configure the cell
        
//        print("Create reusable for \(indexPath)")
        
        
        cell.post = posts[indexPath.row]
        //        cell.parentCollectionView = collectionView
        
        
//        print("cell dequeued")
        return cell
    }
    
}

extension MainViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //        if collectionView.numberOfSections() == 0 {
        //            return CGSize(width: collectionView.frame.width,height: 100);
        //        }
        
        //        if sizingFlatCell == nil {
        ////            sizingFlatCell = FlatCollectionViewCell()
        ////            sizingFlatCell.awakeFromNib()
        //
        //            sizingFlatCell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.FLAT_POST_CELL, forIndexPath: indexPath) as! FlatCollectionViewCell
        //        }
        
        //        print("Size for \(indexPath.row)")
        
        sizingFlatCell.post = posts[indexPath.row]
        
        sizingFlatCell.invalidateIntrinsicContentSize()
        
        sizingFlatCell.contentView.setNeedsLayout()
        sizingFlatCell.contentView.layoutIfNeeded()
        
        //        print("Size: \(sizingFlatCell.intrinsicContentSize())")
        //
        //        print("Size alt: \(sizingFlatCell.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize))")
        //
        //        let size = sizingFlatCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        //        let size = sizingFlatCell.preferredSize(collectionView.frame.size)
        
        
        
        //        print("Size from calc: \(size)")
        
        //        return size
        
        //        var size : CGSize = collectionView.frame.size
        
        let height = sizingFlatCell.preferredHeight(collectionView.frame.width)
       
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

