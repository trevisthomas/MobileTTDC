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
    
    fileprivate var tap : UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        loginTextField.becomeFirstResponder()
        
        loginTextField.text = nil
        passwordTextField.text = nil
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        getApplicationContext().authenticate(loginTextField.text!, password: passwordTextField.text!){ (success, message) -> () in
            
            guard success else {
                self.presentAlert("Sorry", message: message)
                return
            }
//            self.tabBarController?.selectedIndex = 0
            
        };
    }
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer){
        //Trevis: Find out why there isnt a way to get the current first respnder from the view!
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag+1;
        
        if let loginButton = textField.superview?.viewWithTag(nextTag) as? UIButton!{
            loginButton.sendActions(for: UIControlEvents.touchUpInside)
        } else if let nextResponder=textField.superview?.viewWithTag(nextTag) as UIResponder!{
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
}
