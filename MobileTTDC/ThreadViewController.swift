//
//  ThreadViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

public class ThreadViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var post : Post!{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var rootPostId : String! {
        didSet{
            fetchPost(rootPostId)
        }
    }
    
    func fetchPost(postId : String){
        let cmd = PostCrudCommand(postId: postId)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message)
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            self.invokeLater{
                self.post = (response?.post)!
            }
        };
    }
    
}

extension ThreadViewController : UICollectionViewDelegate {
    
}

extension ThreadViewController : UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


