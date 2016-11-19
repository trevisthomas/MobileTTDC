//
//  SearchViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class SearchViewController : CommonBaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var transactionId : Int = 0;
    
    fileprivate var autoCompleteItems : [AutoCompleteItem] = []
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AutoCompleteTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        registerForStyleUpdates()
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        collectionView.backgroundColor = style.postBackgroundColor()
        collectionView.indicatorStyle = style.scrollBarStyle()
        searchBar.backgroundColor = style.navigationBackgroundColor()
        searchBar.tintColor = style.navigationColor()
        
        searchBar.barTintColor = style.navigationBackgroundColor()
        searchBar.setTextColor(style.navigationColor())
        searchBar.setTextBackgroundColor(style.searchBackgroundColor())

        
        view.backgroundColor = style.navigationBackgroundColor()

        tableView.backgroundColor = style.postBackgroundColor()
        tableView.separatorColor = style.headerDetailTextColor()
        tableView.tintColor = style.tintColor()
    }
    
    func switchToTable(){
        autoCompleteItems.removeAll()
        removeAllPosts()
        
        tableView.isHidden = false
        collectionView.isHidden = true
        
        tableView.reloadData()
    }
    
    func switchToCollectionView(){
        autoCompleteItems.removeAll()
        
        tableView.isHidden = true
        collectionView.isHidden = false
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadFirstPage()
    }
    
}

extension SearchViewController {
    //This concept is a copy from ChooseThreadViewController.  Sad copy reuse.
    func performQuery(_ query: String){
        
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
                
                DispatchQueue.main.async {
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
    
    
    
    func performSearch(_ phrase: String, pageNumber : Int = 1, completion: @escaping ([Post]?) -> Void){
        let cmd = SearchCommand(phrase: phrase, postSearchType: SearchCommand.PostSearchType.ALL, pageNumber: pageNumber, sortOrder: SearchCommand.SortOrder.BY_DATE, sortDirection: SearchCommand.SortDirection.DESC)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print("Search failed")
                self.switchToCollectionView()
                completion([])
                return;
            }
            
            
                
            DispatchQueue.main.async {
                self.switchToCollectionView()

                completion(response?.list)
            }
                
        };
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard sender != nil else {
            return
        }
        
        let threadId = sender as! String
        
        let vc = segue.destination.childViewControllers.first as! ThreadViewController
        
        vc.rootPostId = threadId
        
        
    }
}


extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = autoCompleteItems[indexPath.row]
        
        print(item.displayTitle)
        
        performSegue(withIdentifier: "ThreadView", sender: item.postId)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL, for: indexPath) as! AutoCompleteTableViewCell
        //Caught an out of range exception below.  How was that possible? (10/8)
        cell.item = autoCompleteItems[indexPath.row]
        
        return cell
    }
}

extension SearchViewController : PostCollectionViewDelegate{
    func loadPosts(completion: @escaping ([Post]?) -> Void) {
        performSearch(searchBar.text!, completion: completion)
    }
    
    func loadMorePosts(pageNumber: Int, completion: @escaping ([Post]?) -> Void) {
        performSearch(searchBar.text!, pageNumber: pageNumber, completion: completion)
    }
}
