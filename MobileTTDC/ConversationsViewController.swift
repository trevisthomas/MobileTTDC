//
//  ConversationsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit


class ConversationsViewController: CommonBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Conversations"
        
        loadFirstPage()
    }
    
    override func refreshStyle() {
        
        collectionView.backgroundColor = getApplicationContext().getCurrentStyle().postBackgroundColor()
        
        collectionView.indicatorStyle = getApplicationContext().getCurrentStyle().scrollBarStyle()
        
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
    override func loadPosts(completion: @escaping ([Post]?) -> Void){
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageNumber: 1)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            guard (response != nil) else {
                self.presentAlert("Error", message: message!)
                completion(nil)
                return
            }
            completion((response?.list)!)
            
        };
    }
    
    override func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageNumber: pageNumber)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            guard (response != nil) else {
                self.presentAlert("Error", message: message!)
                completion(nil)
                return;
            }
            
            completion((response?.list)!)
            
        };
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
}

//TODO! Figure out why this is a redundant declaration!
extension CommonBaseViewController /*: UICollectionViewDelegate*/ {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = self.posts[indexPath.row]
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        performSegue(withIdentifier: "ConversationWithReplyView", sender: dict)
        
    }
}

