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
        
        performCommand(cmd){
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
    
    func performCommand(command: LoginCommand, completion: (response: LoginResponse?, error: String?)->Void){
        
        
        NetworkAdapter.performJsonRequest("http://ttdc.us/restful/login", json: command.toJSON()!, completion:{(data, error) -> Void in
            
            func completeOnUiThread(response response: LoginResponse?, error: String?){
                dispatch_async(dispatch_get_main_queue()) {
                    completion(response: response, error: error)
                }
            }
            
            if let data = data {
                var json: [String: AnyObject]!
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
                } catch {
                    completeOnUiThread(response: nil, error: "Failed to parse json request.")
                }
                
                guard let loginResponse = LoginResponse(json: json) else {
                    completeOnUiThread(response: nil, error: "Failed to parse json response.")
                    return;
                }
                
                completeOnUiThread(response: loginResponse, error: nil)
            
            } else {
                completeOnUiThread(response: nil, error: "Login failed.")
            }
            
        })
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
