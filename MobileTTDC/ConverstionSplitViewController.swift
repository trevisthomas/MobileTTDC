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
        self.delegate = self //For some reason interface builder refused to let me wire this.
    }
}

extension ConverstionSplitViewController: UISplitViewControllerDelegate{
    
    //Trevis: I'm not 100% sure that this is doing anything
//    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
////        if (svc.displayMode == UISplitViewControllerDisplayMode.PrimaryOverlay || svc.displayMode == UISplitViewControllerDisplayMode.PrimaryHidden) {
////            return UISplitViewControllerDisplayMode.AllVisible;
////        }
////        return UISplitViewControllerDisplayMode.PrimaryHidden;
//        return UISplitViewControllerDisplayMode.AllVisible
//    }
    
    //Amazingly, this seems to be the only way to make the master appear first.
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}
