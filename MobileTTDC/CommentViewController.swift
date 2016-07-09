//
//  CommentViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/9/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var threadSummaryLabel: UILabel!
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
//    var item : AutoCompleteItem? {
//        didSet{
//            threadTitle = item.displayTitle
//            threadSummaryLabel = "debug: todo..."
//            //just let this controller get all detail by retriving the post. Hm.  Needs more thought because creation has to handle new posts.
//        }
//    }
    
    var post : Post? {
        didSet{
            threadTitle.text = post?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postComment(sender: AnyObject) {
        print(commentTextArea.text)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
