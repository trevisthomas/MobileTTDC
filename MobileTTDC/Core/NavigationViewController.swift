//
//  NavigationViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/31/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForStyleUpdates()
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()

        navigationBar.isTranslucent = false
        navigationBar.tintColor = style.navigationColor()
//        navigationBar.barTintColor = style.navigationBackgroundColor()
        navigationBar.barTintColor = style.tintColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: style.navigationColor()]
        
        
    }

}
