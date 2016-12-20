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
    @IBOutlet weak var privateStarView: StarRatingView!
    @IBOutlet weak var webLinkButtonStackView: UIStackView!
    @IBOutlet weak var bioTextView: UITextView!
    
    var person : Person!
    
    var personId : String! {
        didSet{
            //load person
            //TODO: Really load the person from a webservice.
            person = getApplicationContext().currentUser()!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        registerForStyleUpdates()
        
        

        
    }
    
    private func setup(){
        if person == nil {  //This way, if the VC is launched from the tab, it will just populate with the authenticated user.
            person = getApplicationContext().currentUser()
        }
        
        
//        //Configure the view for edit or for view based on person id
//        if (getApplicationContext().currentUser()?.personId == person.personId) {
//            //Display update components
//        } else {
//            //Hide updatable stuff
//        }
        
        titleLabel.text = person.login
        if let bio = person.bio {
            bioTextView.setHtmlText(bio)
        } else {
            bioTextView.setHtmlText("")
        }
        
        if let url = person.image?.name {
            profilePicImageView.downloadedFrom(link: url, contentMode: .scaleAspectFit)
        }
        
        if let _ = person.privateAccessAccount {
            privateStarView.isHidden = false
        } else {
            privateStarView.isHidden = true
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
        titleLabel.textColor = style.entryTextColor()

        self.view.backgroundColor = style.postBackgroundColor()
        
        self.bioTextView.backgroundColor = style.underneath()
        self.bioTextView.textColor = style.entryTextColor()
        
        
//        lightDarkSegmentedControl.tintColor = style.tintColor()
//        lightDarkSegmentedControl.selectedSegmentIndex = getApplicationContext().isStyleLight() ? 0 : 1
    }
    
    @IBAction func lightDarkSegmentedControlAction(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            getApplicationContext().setStyleLight()
        } else {
            getApplicationContext().setStyleDark()
        }
    }
    @IBAction func logoutAction(_ sender: AnyObject) {
        getApplicationContext().logoff()
        tabBarController?.selectedIndex = 0
    }

}
