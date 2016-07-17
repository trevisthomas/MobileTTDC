//
//  CommentViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ChooseThreadViewController: UIViewController {

    private var transactionId : Int = 0;
    @IBOutlet weak var topicSelectorTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    private var autoCompleteItems : [AutoCompleteItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        
        let nib = UINib(nibName: "AutoCompleteTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL)
        
        //topicSelectorTextField.delegate = self
        
        searchBar.delegate = self
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentViewController.dismissKeyboard))
//       tableView.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        topicSelectorTextField.endEditing(true)
        searchBar.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChooseThreadViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChooseThreadViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
//        topicSelectorTextField.text = ""
//        autoCompleteItems = []
//        tableView.reloadData()
        
        searchBar.becomeFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = sender as! NSIndexPath
        
      
//        let nav = segue.destinationViewController as! UINavigationController
//
//        guard let nav = segue.destinationViewController as? UINavigationController else {
//            return
//        }
//        
//        guard let vc = nav.viewControllers.last as? CommentViewController else {
//            return
//        }
        
//        let nav = segue.destinationViewController as! UINavigationController
//        let vc = nav.viewControllers.first as! CommentViewController

        
        
//     
//        guard let vc = segue.destinationViewController as? CommentViewController else {
//            return
//        }
        
        if let vc = segue.destinationViewController as? CommentViewController {
            let item = autoCompleteItems[indexPath.row]
            vc.parentId = item.postId
        } else if let vc = segue.destinationViewController as? TopicCreationViewController {
            let item = autoCompleteItems[indexPath.row]
            vc.topicTitle = item.displayTitle
        }
        
    }
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ChooseThreadViewController {
    //Keyboard stuff
//    @IBAction func textFieldTextChanged(sender: UITextField) {
//        performQuery(sender.text!)
//        
//    }
    
    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
//            invokeLater {
//                self.bottomConstraintTableView.constant = keyboardFrame.height - 50 //Hm, is this 50px becaues of tabbar?!
//            }
//        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
//        invokeLater {
//            self.bottomConstraintTableView.constant = 0.0
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
}

extension ChooseThreadViewController {
    
    func performQuery(query: String){
        
        if query.isEmpty {
            self.autoCompleteItems.removeAll()
            self.tableView.reloadData()
            return
        }
        
        transactionId = transactionId + 1
        
        let cmd = AutoCompleteCommand(query: query, transactionId: transactionId)
        
        Network.performAutocompleteCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print("Autocomplete fail")
                
                self.autoCompleteItems.removeAll()
                self.tableView.reloadData()
                
                return;
            }
            
            if (self.transactionId == response?.transactionId){
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.autoCompleteItems = (response?.items)!
                    
                    let createNewTopicItem = AutoCompleteItem(displayTitle: query)
                    self.autoCompleteItems.append(createNewTopicItem)
                    self.tableView.reloadData()
                }
                
            }
            else {
                print("Response is not current. Discarding.")
            }
            
        };
    
    }
    
}

extension ChooseThreadViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteItems.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissKeyboard()
        let item = autoCompleteItems[indexPath.row]
        
        if(item.postId == nil) {
            performSegueWithIdentifier("TopicCreationViewController", sender: indexPath)
        } else {
            performSegueWithIdentifier("CommentViewController", sender: indexPath)
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifiers.AUTO_TOPIC_CELL, forIndexPath: indexPath) as! AutoCompleteTableViewCell
        
        cell.item = autoCompleteItems[indexPath.row]
        
        return cell
    }
}
extension ChooseThreadViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        performQuery(searchBar.text!)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(searchText)
    }
    
//    searchBarD
}

extension ChooseThreadViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}