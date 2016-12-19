//
//  LoginViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    @IBOutlet weak var loginTextField: AnimatedLabelTextField!
    @IBOutlet weak var passwordTextField: AnimatedLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    fileprivate var tap : UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        registerForStyleUpdates()
        
//        loginButton.bo
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 3
    }

    override func viewDidAppear(_ animated: Bool) {
//        loginTextField.becomeFirstResponder()
        
        loginTextField.text = nil
        passwordTextField.text = nil
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        getApplicationContext().authenticate(loginTextField.text!, password: passwordTextField.text!){ (success, message) -> () in
            
            guard success else {
//                self.presentAlert("Sorry", message: message)
                
                self.loginFailedAnimation(component: self.passwordTextField)
                self.loginFailedAnimation(component: self.loginTextField)
                self.loginFailedAnimation(component: self.loginButton)
                return
            }
//            self.tabBarController?.selectedIndex = 0
            
        };
    }
    
    override func refreshStyle() {
        let style = getApplicationContext().getCurrentStyle()
        view.backgroundColor = style.underneath()
    
        styleTextField(field: loginTextField)
        styleTextField(field: passwordTextField)
        
        loginButton.setTitleColor(style.underneath(), for: .normal)
        loginButton.backgroundColor = style.headerDetailTextColor()
        
    }
    
    private func styleTextField(field : AnimatedLabelTextField){
        let style = getApplicationContext().getCurrentStyle()
        field.borderDefaultColor = style.entryTextColor()
        field.textColor = style.entryTextColor()
        field.backgroundColor = style.postBackgroundColor()
        field.borderHighlightColor = style.starFill()
        field.defaultBackgroundColor = style.postBackgroundColor()
        field.placeHolderColor = style.entryTextColor()

    }
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer){
        //Trevis: Find out why there isnt a way to get the current first respnder from the view!
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func loginFailedAnimation(component : UIView){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            //Restore state
        })
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        let offset : CGFloat = 16.0
        animation.fromValue = NSValue(cgPoint: CGPoint(x: component.center.x - offset, y: component.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: component.center.x + offset, y: component.center.y))
        animation.repeatCount = 5
        animation.autoreverses = true
        
        component.layer.add(animation, forKey: "position")
        
        CATransaction.commit()
    }
}

//extension LoginViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTag = textField.tag+1;
//        
//        if let loginButton = textField.superview?.viewWithTag(nextTag) as? UIButton!{
//            loginButton.sendActions(for: UIControlEvents.touchUpInside)
//        } else if let nextResponder=textField.superview?.viewWithTag(nextTag) as UIResponder!{
//            nextResponder.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//        return false // We do not want UITextField to insert line-breaks.
//    }
//}
