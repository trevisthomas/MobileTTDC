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
    
    private var person : Person! {
        didSet {
            setup()
        }
    }
    
    var personId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setup()

        registerForStyleUpdates()
        
        loadPerson(personId: personId)
    }
    
    private func setup(){
        
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
        
        refreshStyle()
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
        
//        self.bioTextView.backgroundColor = style.underneath()
//        self.bioTextView.textColor = style.entryTextColor()
        
        bioTextView.textColor = style.entryTextColor()
        bioTextView.backgroundColor = style.underneath()
        bioTextView.tintColor = style.headerDetailTextColor()
        
    }
    
    @IBAction func lightDarkSegmentedControlAction(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            getApplicationContext().setStyleLight()
        } else {
            getApplicationContext().setStyleDark()
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadPerson(personId : String) {
        let cmd = PersonCommand(personId: personId)
        
        
        Network.performPerson(cmd){
            (response, message) -> Void in
            
            guard let p = response?.person else {
                print("Failed to load person")
                return
            }
            
            invokeLater {
                self.person = p
                
            }
            
        };

    }
}
