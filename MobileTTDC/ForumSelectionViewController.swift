//
//  ForumSelectionViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/16/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

protocol ForumSelectionDelegate{
    func selectedForum(_ forum: Forum);
}

class ForumSelectionViewController: UIViewController {
    
    fileprivate var forums : [Forum] = []
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ForumSelectionDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadForums()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension ForumSelectionViewController{
    func loadForums(){
        let cmd = ForumCommand()
        
        Network.performForumCommand(cmd){
            (response, message) -> Void in
            guard let list = response?.list else {
                print(message ?? "Failed but message was nil")
                self.presentAlert("Error", message: "Failed to load forum list.")
                return;
            }
            
            self.invokeLater{
                self.forums = list
                self.tableView.reloadData()
            }
            
        };
    }
}

extension ForumSelectionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forums.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(forums[indexPath.row])
        
        self.dismiss(animated: true){
            self.delegate.selectedForum(self.forums[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForumTableCell")!
        
        cell.textLabel?.setHtmlText(forums[indexPath.row].displayValue, fuckingColor: "brown")
        
        return cell
    }
}
