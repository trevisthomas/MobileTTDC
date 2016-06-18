//
//  ConverstionSplitViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConverstionSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

extension ConversationsViewController: UISplitViewControllerDelegate{
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if (svc.displayMode == UISplitViewControllerDisplayMode.PrimaryOverlay || svc.displayMode == UISplitViewControllerDisplayMode.PrimaryHidden) {
            return UISplitViewControllerDisplayMode.AllVisible;
        }
        return UISplitViewControllerDisplayMode.PrimaryHidden;
    }
}
