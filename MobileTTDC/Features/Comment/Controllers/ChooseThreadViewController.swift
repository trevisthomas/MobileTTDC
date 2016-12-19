//
//  CommentViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ChooseThreadViewController: UIViewController{

    fileprivate var transactionId : Int = 0;
    @IBOutlet weak var topicSelectorTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    fileprivate var autoCompleteItems : [AutoCompleteItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        
        let nib = UINib(nibName: "AutoCompleteTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL)
        
        //topicSelectorTextField.delegate = self
        
        searchBar.delegate = self
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentViewController.dismissKeyboard))
//       tableView.addGestureRecognizer(tap)
        registerForStyleUpdates()
        
        tableView.delegate = self
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        searchBar.backgroundColor = style.postBackgroundColor()
        searchBar.tintColor = style.navigationColor()
        
        searchBar.barTintColor = style.underneath()
        searchBar.setTextColor(style.navigationColor())
        searchBar.setTextBackgroundColor(style.searchBackgroundColor())
        
        
        view.backgroundColor = style.underneath()
        
        tableView.backgroundColor = style.postBackgroundColor()
        tableView.separatorColor = style.headerDetailTextColor()
        tableView.tintColor = style.tintColor()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseThreadViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseThreadViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
//        topicSelectorTextField.text = ""
//        autoCompleteItems = []
//        tableView.reloadData()
        
        searchBar.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        
      
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
        
        if let vc = segue.destination as? CommentViewController {
            let item = autoCompleteItems[indexPath.row]
            vc.parentId = item.postId
        } else if let vc = segue.destination as? TopicCreationViewController {
            let item = autoCompleteItems[indexPath.row]
            vc.topicTitle = item.displayTitle
        }
        
    }
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChooseThreadViewController {
    //Keyboard stuff
//    @IBAction func textFieldTextChanged(sender: UITextField) {
//        performQuery(sender.text!)
//        
//    }
    
    func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
//            invokeLater {
//                //Trevis, this works on iphone, but is bad news on ipad.  For now i'm disabling it and just hiding the keyboard when the user tries to scroll
//                self.bottomConstraintTableView.constant = keyboardFrame.height
//            }
//        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
//        invokeLater {
//            self.bottomConstraintTableView.constant = 0.0
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
}

extension ChooseThreadViewController {
    
    func performQuery(_ query: String){
        
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
                
                DispatchQueue.main.async {
                    self.autoCompleteItems.removeAll()
                    self.tableView.reloadData()
                }
                
                
                return;
            }
            
            if (self.transactionId == response?.transactionId){
                
                DispatchQueue.main.async {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissKeyboard()
        let item = autoCompleteItems[indexPath.row]
        
        if(item.postId == nil) {
            performSegue(withIdentifier: "TopicCreationViewController", sender: indexPath)
        } else {
            performSegue(withIdentifier: "CommentViewController", sender: indexPath)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL, for: indexPath) as! AutoCompleteTableViewCell
        
        cell.item = autoCompleteItems[indexPath.row]
        
        return cell
    }
}
extension ChooseThreadViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        performQuery(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(searchText)
    }
    
//    searchBarD
}

extension ChooseThreadViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension ChooseThreadViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
