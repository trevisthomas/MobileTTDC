//
//  ConversationsViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit


protocol DetailSelectionDelegate: class {
    func changeDetail(post: Post?)
}

class ConversationsViewController: UIViewController {
    
    private var posts : [Post] = []
    private var sizingCellPrototype : ConversationCollectionViewCell!
    private(set) var postForSegue : Post! = nil //OUTSTANDING!
//    private weak var detailDelegate : DetailSelectionDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView?

    var closeBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(closeButtonClicked(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ConversationCollectionViewCell", bundle: nil)
        
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: ReuseIdentifiers.CONVERSATION_POST_CELL)
        
        collectionView?.delegate = self //For the layout delegate
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIInterfaceOrientation, object: nil)
        
        
        sizingCellPrototype = nib.instantiateWithOwner(nil, options: nil)[0] as! ConversationCollectionViewCell
        
        loadDataFromWebservice()
        
        self.navigationItem.rightBarButtonItem = closeBarButtonItem
        
        self.title = "Conversations"
        
        //Setting the title of the back button
        let converstionButton = UIBarButtonItem(title: "Conversations", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = converstionButton;
        
        getDetailViewController()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout() //Just incase the orientation changed when you werent visible
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: ConversationsViewController")
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func closeButtonClicked(sender : UIButton){
        print("Sup, playuh")
//
//        let detailNav = splitViewController?.viewControllers.last as! UINavigationController
//        detailNav.popViewControllerAnimated(true)
//
//        postForSegue = nil
//        performSegueWithIdentifier("Main", sender: self)
        
        
        
//        self.navigationController?.popToRootViewControllerAnimated(true)
//        self.navigationController?.popViewControllerAnimated(true)
        
        
//        let vc = storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as!  MainViewController
//        let detailNav = splitViewController?.viewControllers.last as! UINavigationController
//        detailNav.pushViewController(vc, animated: true)
        
    }
    
    private func getDetailViewController() -> PostDetailViewController {
        let detailNavigation = self.splitViewController?.viewControllers.last as! UINavigationController
        let detailVC = detailNavigation.visibleViewController as! PostDetailViewController
        
        print( detailVC.debugDescription )
        return detailVC
    }
 
}

extension ConversationsViewController{
    
    
    func loadDataFromWebservice(){
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.posts = (response?.list)!
            
            self.collectionView?.reloadData()
            
            //            print(response!.totalResults)
            //
            //            for post in response!.list {
            //                print("\(post.postId) at \(post.date) by \(post.creator.login) : \(post.creator.image?.name)" )
            //            }
        };
    }
}

extension ConversationsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        sizingCellPrototype.post = posts[indexPath.row]
        let height = sizingCellPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
    }
}


extension ConversationsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.CONVERSATION_POST_CELL, forIndexPath: indexPath) as! ConversationCollectionViewCell
        
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let detail = storyboard?.instantiateViewControllerWithIdentifier("ConversationDetailViewController") as!  ConversationDetailViewController
//        detail.post = posts[indexPath.row]
//        
//        let detailNav = splitViewController?.viewControllers.last as! UINavigationController
//        detailNav.pushViewController(detail, animated: true)
        
        getDetailViewController().changeDisplayMode(PostDetailViewController.DisplayMode.SingleConverstaion, withContext: posts[indexPath.row])

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        
//        guard (postForSegue != nil) else{
//            return;
//        }
        
        if postForSegue == nil {
            return;
        }
        
        if let navcon = destination as? UINavigationController{
            destination = navcon.visibleViewController!
            
            navcon.performSegueWithIdentifier("ConversationDetail", sender: self)
        }
        
        
//        //ConversationDetail
//        if let hvc = destination as? ConversationDetailViewController {
//            if let identifier = segue.identifier {
//                print(segue.identifier)
////                switch identifier{
////                case "Sad": hvc.happiness = 0
////                case "Happy": hvc.happiness = 100
////                case "Nothing" : hvc.happiness = 75
////                default: hvc.happiness = 50
////                }
//            }
//        }
    }
}
