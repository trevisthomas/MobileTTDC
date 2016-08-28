//
//  SearchViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var transactionId : Int = 0;
    
    private var autoCompleteItems : [AutoCompleteItem] = []
    private var posts : [Post] = []
    
    private var flatPrototypeCell : FlatCollectionViewCell!
    
    @IBAction func doneButtonAction(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
//        let nib = UINib(nibName: "AutoCompleteCollectionViewCell", bundle: nil)
//        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.AUTO_COLLECTION_CELL)
       
        flatPrototypeCell = registerAndCreatePrototypeCellFromNib("FlatCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.FLAT_POST_CELL) as! FlatCollectionViewCell

        let nib = UINib(nibName: "AutoCompleteTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL)
        
        searchBar.delegate = self
        
        searchBar.becomeFirstResponder()
    }
    
    private func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
    }
    
    func switchToTable(){
        autoCompleteItems.removeAll()
        posts.removeAll()
        
        tableView.hidden = false
        collectionView.hidden = true
    }
    
    func switchToCollectionView(){
        autoCompleteItems.removeAll()
        posts.removeAll()
        
        tableView.hidden = true
        collectionView.hidden = false
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch(searchBar.text!)
    }
    
}

extension SearchViewController {
    //This concept is a copy from ChooseThreadViewController.  Sad copy reuse.
    func performQuery(query: String){
        
        if query.isEmpty {
            self.switchToTable()
            return
        }
        
        transactionId = transactionId + 1
        
        let cmd = AutoCompleteCommand(query: query, transactionId: transactionId)
        
        Network.performAutocompleteCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print("Autocomplete fail")
                
                self.switchToTable()
                
                return;
            }
            
            if (self.transactionId == response?.transactionId){
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.switchToTable()
                    
                    self.autoCompleteItems = (response?.items)!
                    
//                    let createNewTopicItem = AutoCompleteItem(displayTitle: query)
//                    self.autoCompleteItems.append(createNewTopicItem)
//                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                }
                
            }
            else {
                print("Response is not current. Discarding.")
            }
            
        };
        
    }
    
    
    
    func performSearch(phrase: String){
        let cmd = SearchCommand(phrase: phrase, postSearchType: SearchCommand.PostSearchType.ALL, pageNumber: 1, sortOrder: SearchCommand.SortOrder.BY_DATE, sortDirection: SearchCommand.SortDirection.DESC)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print("Search failed")
                
                self.switchToCollectionView()
                
                return;
            }
            
            
                
            dispatch_async(dispatch_get_main_queue()) {
                self.switchToCollectionView()
                        
                self.posts = (response?.list)! //Hm, what if this is zero?
                self.collectionView.reloadData()
            }
                
        };
    }
}

extension SearchViewController : UICollectionViewDelegate {
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteItems.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.dismissKeyboard()
        let item = autoCompleteItems[indexPath.row]
        
//        if(item.postId == nil) {
//            performSegueWithIdentifier("TopicCreationViewController", sender: indexPath)
//        } else {
//            performSegueWithIdentifier("CommentViewController", sender: indexPath)
//        }
        
        print(item.displayTitle)
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifiers.AUTO_TOPIC_CELL, forIndexPath: indexPath) as! AutoCompleteTableViewCell
        
        cell.item = autoCompleteItems[indexPath.row]
        
        return cell
    }
}

extension SearchViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.AUTO_COLLECTION_CELL, forIndexPath: indexPath) as! AutoCompleteCollectionViewCell
//        cell.threadTitleLabel.text = autoCompleteItems[indexPath.row].displayTitle
//        return cell
        
//        return UICollectionViewCell()
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.FLAT_POST_CELL, forIndexPath: indexPath) as! FlatCollectionViewCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height : CGFloat
        flatPrototypeCell.post = posts[indexPath.row]
        height = flatPrototypeCell.preferredHeight(collectionView.frame.width)
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
}


extension SearchViewController : PostViewCellDelegate {
    func likePost(post: Post){
        
    }
    func viewComments(post: Post){
        
    }
    func commentOnPost(post: Post){
        
    }
}
