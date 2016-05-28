//
//  LoginViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: UIButton) {
        print("Perform login")
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag+1;

        if let loginButton = textField.superview?.viewWithTag(nextTag) as? UIButton!{
            loginButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        } else if let nextResponder=textField.superview?.viewWithTag(nextTag) as UIResponder!{
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        loginTextField.becomeFirstResponder()
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
