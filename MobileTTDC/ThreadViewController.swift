//
//  ThreadViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ThreadViewController: CommonBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var rootPostId : String!
    
    override func loadPosts(completion: @escaping ([Post]?) -> Void) {
        fetchPost(rootPostId){
            rootPost in
            self.fetchPostTopic(self.rootPostId) {
                replies in
                var posts : [Post] = []
                posts.append(rootPost!)
                posts.append(contentsOf: replies!)
                completion(posts)
            }
        }
    }
    
    override func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
        self.fetchPostTopic(self.rootPostId, pageNumber: pageNumber) {
            replies in
            completion(replies)
        }
    }
    
    fileprivate func fetchPostTopic(_ postId : String, pageNumber: Int = 1, completion: @escaping ([Post]?) -> Void){
        
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId, pageNumber: pageNumber)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                completion(nil)
                return;
            }
            
            self.invokeLater{
                completion((response?.list)!.flattenPosts())
            }
        };
    }
    
    fileprivate func fetchPost(_ postId : String, completion: @escaping (Post?) -> Void) {
        //Not sure if this actually works.
        let cmd = PostCrudCommand(postId: postId, loadRootAncestor: true)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                completion(nil)
                return;
            }
            
            self.invokeLater{
                completion(response?.post)
            }
        };
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForStyleUpdates()
        
        loadFirstPage()
    }
    
    override func refreshStyle() {
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
    }

    
    @IBAction func doneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
}


