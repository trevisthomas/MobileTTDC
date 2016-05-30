//
//  LoginViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var tap : UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(animated: Bool) {
        loginTextField.becomeFirstResponder()
        
        loginTextField.text = nil
        passwordTextField.text = nil
    }
    
    @IBAction func loginButton(sender: UIButton) {
        let cmd = LoginCommand(login: loginTextField.text!, password: passwordTextField.text!)
        
        Network.performLogin(cmd){
            (response, message) -> Void in
                guard (response != nil) else {
                    self.presentAlert("Sorry", message: "Invalid login or password")
                    return;
                }
                self.presentAlert("Welcome", message: "Welcome back, \((response?.person?.name)!)")
            
        };
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer){
        //Trevis: Find out why there isnt a way to get the current first respnder from the view!
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func presentAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension LoginViewController : UITextFieldDelegate {
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
}
