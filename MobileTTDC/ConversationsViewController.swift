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
    
    
    
}

extension ConversationsViewController : PostCollectionViewDelegate {
    func loadPosts(completion: @escaping ([Post]?) -> Void){
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
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
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

}

