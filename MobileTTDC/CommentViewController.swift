//
//  CommentViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    private var transactionId : Int = 0;
    @IBOutlet weak var topicSelectorTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var autoCompleteItems : [AutoCompleteItem] = []
    
//    private var keyboardObserver = KeyboardObserver(delegate: self, eventTypes: [.WillShow, .WillHide, .DidHide])
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let nib = UINib(nibName: "AutoCompleteViewCell", bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.AUTO_TOPIC_CELL)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentViewController.dismissKeyboard))
        collectionView.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        topicSelectorTextField.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        performQuery("ttdc")
//    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
}

extension CommentViewController {
    //Keyboard stuff
    @IBAction func textFieldTextChanged(sender: UITextField) {
//        print(sender.text)
        performQuery(sender.text!)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
            collectionView.contentInset.bottom = keyboardFrame.height
            
        }
        print("keyboard will show")
    }
    
    func keyboardDidHide(notification: NSNotification) {
        collectionView.contentInset.bottom = 0.0
        print("keyboard did hide")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
}

extension CommentViewController {
    
    func performQuery(query: String){
        
        if query.isEmpty {
            self.autoCompleteItems.removeAll()
            self.collectionView.reloadData()
            return
        }
        
        transactionId = transactionId + 1
        
        let cmd = AutoCompleteCommand(query: query, transactionId: transactionId)
        
        Network.performAutocompleteCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print("Autocomplete fail")
                
                self.autoCompleteItems.removeAll()
                self.collectionView.reloadData()
                
                return;
            }
            
            if (self.transactionId == response?.getTransactionId()){
//                self.autoCompleteItems.removeAll()
//                self.autoCompleteItems.appendContentsOf(response?.items)
                
                self.autoCompleteItems = (response?.items)!
                
                //Debug!
//                for item in (response?.items)! {
//                    print(item.displayTitle)
//                }
//                self.collectionView.re
                self.collectionView.reloadData()
            }
            else {
                print("Response is not current. Discarding.")
            }
            
        };
    
    }
    
}

extension CommentViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        sizingCellPrototype.post = getApplicationContext().latestConversations()[indexPath.row]
//        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
}

extension CommentViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return autoCompleteItems.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.AUTO_TOPIC_CELL, forIndexPath: indexPath) as! AutoCompleteViewCell
        
        
        cell.titleText = autoCompleteItems[indexPath.row].displayTitle
        
        print(cell.titleText)
        return cell
    }
    
    
}