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
    
    fileprivate func fetchPostTopic(_ postId : String, pageNumber: Int = 1, completion: @escaping ([Post]?, Bool) -> Void){
        
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId, pageNumber: pageNumber)
        
        let postCount = pageNumber * cmd.pageSize
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard let r = response else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                completion(nil, false)
                return;
            }
            
            self.invokeLater{
                let remaining = postCount < r.totalResults
                completion(r.list.flattenPosts(), remaining)
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
        
        getApplicationContext().broadcaster.subscribe(consumer: self)
        getApplicationContext().broadcaster.subscribeForPostAdd(consumer: self)
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
    
    override func allowHierarchy() -> Bool {
        return true
    }
}

extension ThreadViewController : PostCollectionViewDelegate {
    func loadPosts(completion: @escaping ([Post]?, Bool) -> Void) {
        fetchPost(rootPostId){
            rootPost in
            self.fetchPostTopic(self.rootPostId) {
                (replies, remaining) in
                var posts : [Post] = []
                posts.append(rootPost!)
                posts.append(contentsOf: replies!)
                completion(posts, remaining)
            }
        }
    }
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?, Bool) -> Void) {
        self.fetchPostTopic(self.rootPostId, pageNumber: pageNumber) {
            (replies, remaining) in
            completion(replies, remaining)
        }
    }
}

extension ThreadViewController: BroadcastEventConsumer {
    func observingPostId(postId: String) -> Bool {
        return true
    }
    func onPostUpdated(post : Post) {
        guard let index = posts.indexOfPost(sourcePost: post) else {
            return
        }
        
        posts[index] = post
        let path = IndexPath(item: index, section: 0)
        if let cell = getCollectionView()?.cellForItem(at: path) as? BaseCollectionViewCell {
            cell.post = post
        }
        
    }
}

extension ThreadViewController: BroadcastPostAddConsumer {
    func onPostAdded(post : Post) {
        //Find out if this post belongs in your hierarchy and respond acordingly.
        for p in posts {
            if(p.postId == post.parentPostId) {
                //TODO, let the user know that the data changed.  Dont auto refresh.
                loadFirstPage()
            }
        }
    }
    func reloadPosts(){
        loadFirstPage()
    }
}


