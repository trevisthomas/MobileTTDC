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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private struct ReuseIdentifiers{
        static let CONVERSATION_POST_CELL = "ConversationPostCell"
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ConversationCollectionViewCell", bundle: nil)
        
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.CONVERSATION_POST_CELL)
        
        collectionView.delegate = self //For the layout delegate
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIInterfaceOrientation, object: nil)
        
        
        sizingCellPrototype = nib.instantiateWithOwner(nil, options: nil)[0] as! ConversationCollectionViewCell
        
        loadDataFromWebservice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            self.collectionView.reloadData()
            
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
        
        //        sizingFlatCell.invalidateIntrinsicContentSize()
        //
        //        sizingFlatCell.contentView.setNeedsLayout()
        //        sizingFlatCell.contentView.layoutIfNeeded()
        
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
    
}
