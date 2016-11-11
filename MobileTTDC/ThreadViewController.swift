//
//  ThreadViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ThreadViewController: PostBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var rootPost : Post? {
        didSet{
            fetchPostTopic(rootPostId)
        }
    }
    
    var posts : [Post] = [] {
        didSet{
            posts.insert(rootPost!, at: 0)
            collectionView.reloadData()
        }
    }
    
    var rootPostId : String! {
        didSet{
            fetchPost(rootPostId)
        }
    }
    
    func fetchPostTopic(_ postId : String){
        
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.invokeLater{
                self.posts = (response?.list)!.flattenPosts()
            }
            
        };
    }
    
    func fetchPost(_ postId : String) {
        //Not sure if this actually works.
        let cmd = PostCrudCommand(postId: postId, loadRootAncestor: true)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.invokeLater{
                self.rootPost = response?.post
            }
            
        };
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForStyleUpdates()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nav = segue.destination as? UINavigationController else {
            return
        }
        
        if let destVC = nav.topViewController as? ThreadViewController {
            let postId = sender as! String
            destVC.rootPostId = postId
            return
        }
        
        guard let vc = nav.topViewController as? ConversationWithReplyViewController else {
            return
        }
        
        let dict = sender as! [String: String]
        
        print(dict["threadId"]!)
        
        vc.postId = dict["threadId"]
        if let postId = dict["postId"] {
            vc.replyToPostId = postId
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: PostDetailViewController")
        
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
            }, completion: {context in
                self.collectionView?.collectionViewLayout.invalidateLayout()
                
            }
        )
    }
}

extension ThreadViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueCell(posts[indexPath.row], indexPath: indexPath, allowHierarchy: true)
    }
}

extension ThreadViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let height = prototypeCellSize(post: posts[indexPath.row], indexPath: indexPath, width: collectionView.frame.width)
//        
//        return CGSize(width: collectionView.frame.width, height: height)
        
        return prototypeCellSize(post: posts[indexPath.row], allowHierarchy : true)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        sectionHeaderPrototype.post = posts[section]
//        
//        let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
//        return CGSize(width: collectionView.frame.width, height: height)
//    }
}
/*
extension ThreadViewController : PostViewCellDelegate {
    func likePost(post: Post){
        
    }
    func viewComments(post: Post){
        
    }
    func commentOnPost(post: Post){
        print("Comment on Post - ThreadViewController\(post.postId)")
        
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        dict["postId"] = post.postId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)

    }
    func viewThread(post: Post){
        
    }
    
}
*/

