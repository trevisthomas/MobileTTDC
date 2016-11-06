//
//  ProfileViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var lightDarkSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForStyleUpdates()
        
        let person = getApplicationContext().currentUser()!
        
        titleLabel.text = person.login
        
        if let url = person.image?.name {
            profilePicImageView.downloadedFrom(link: url, contentMode: .ScaleAspectFit)
        }

    }
    
//    override func viewWillAppear(animated: Bool) {
//        lightDarkSegmentedControl.selectedSegmentIndex = getApplicationContext().isStyleLight() ? 0 : 1
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        titleLabel.textColor = style.headerDetailTextColor()
        lightDarkSegmentedControl.tintColor = style.tintColor()
        self.view.backgroundColor = style.postBackgroundColor()
        
        lightDarkSegmentedControl.selectedSegmentIndex = getApplicationContext().isStyleLight() ? 0 : 1
    }
    
    @IBAction func lightDarkSegmentedControlAction(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            getApplicationContext().setStyleLight()
        } else {
            getApplicationContext().setStyleDark()
        }
    }
    @IBAction func logoutAction(sender: AnyObject) {
        getApplicationContext().logoff()
    }

}
