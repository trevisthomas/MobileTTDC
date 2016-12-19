//
//  SplashViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/9/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var curtainView : UIView!
    @IBOutlet weak var navBarPlaceholderView: UIView!
    @IBOutlet weak var tabBarPlaceHolderView: UIView!
    @IBOutlet weak var segmentedControlPlaceholderView: UIView!
    @IBOutlet weak var segmenetdControl: UISegmentedControl!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Bootstrap process commencing")
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let applicationContext = ApplicationContext()
        
        applicationContext.loadStyle()
        let style = applicationContext.getCurrentStyle()
        view.backgroundColor = style.underneath()
        footerLabel.textColor = style.entryTextColor()
        welcomeLabel.textColor = style.tintColor()
        
        curtainView = UIView(frame: view.bounds)
        curtainView.backgroundColor = style.navigationBackgroundColor()
        view.addSubview(curtainView)
//        self.navigationController?.navigationBar.backgroundColor = style.tintColor()
        
        self.navBarPlaceholderView.backgroundColor = style.navigationBackgroundColor()
        self.navigationController?.navigationBar.barTintColor = style.navigationBackgroundColor()
        self.tabBarPlaceHolderView.backgroundColor = style.tabbarBackgroundColor()
        self.segmentedControlPlaceholderView.backgroundColor = style.navigationBackgroundColor()
        self.segmenetdControl.tintColor = style.navigationTintColor()
        
        animateCurtain()
        
        appDelegate.initialize(appContext: applicationContext) //This will try to get a device token and try to store it. No worries, he cant send it to the server if he doesnt have a ttdc token.
        
        //This will also try to save the device token after the user is authenticated.
        applicationContext.initialize() {
            (person) in
            
            self.welcomeLabel.text = "Hi, \(person.login)"
            print("Bootstrap complete.  Welcome \(person.login).")
            
            applicationContext.latestPostsModel.loadFirstPage(displayMode: applicationContext.displayMode, completion: {
                (_,_) in
                invokeLater {
                    self.performSegue(withIdentifier: "Main", sender: nil)
                }
                
            })
            
            
        }
        
        
        
        
    }
    
    private func animateCurtain(){
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut, animations: {
//            self.curtainView.center.y -= self.view.bounds.height
            self.curtainView.frame.origin.y -= self.view.bounds.height - 64
        }, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //        segue.source.navigationController?.setViewControllers([segue.destination], animated: true)
    //
    //        segue.source.parent?.childViewControllers.removeAll()
    ////        sourceViewController.navigationController?.setViewControllers([destinationViewController], animated: true)
    //    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalTransitionStyle = .crossDissolve
    }
    
    
}
