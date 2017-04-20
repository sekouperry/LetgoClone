//
//  SignInViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/23/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit



class SignInViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: CustomizableTextfields! {
        didSet{
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: CustomizableTextfields!{
        didSet{
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var forgotDetailButton: UIButton!
    @IBOutlet weak var signInButton: CustomizableButtons!
    
    var networkingService = NetworkingServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setTapGestureRecognizerOnView()
        setSwipeGestureRecognizerOnView()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func signInAction(_ sender: CustomizableButtons) {
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!
        
        if finalEmail.isEmpty || password.isEmpty {
            let alert = SCLAlertView()
            _ = alert.showWarning("OH LA LA NO 🙈!", subTitle: "One or more fields have not been filled. Please try again.")
        }else {
            if isValidEmail(email: finalEmail) {
                self.networkingService.signIn(email: finalEmail, password: password)
            }
        }
        self.view.endEditing(true)
    }
    
    
    
    
    
}

extension SignInViewController {
    
    @IBAction func unwindToLogin(_ storyboardSegue: UIStoryboardSegue){}
    
    private func hideForgotDetailButton(isHidden: Bool){
        self.forgotDetailButton.isHidden = isHidden
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        hideForgotDetailButton(isHidden: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            80)
        hideForgotDetailButton(isHidden: false)
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
        
    }
    
    @objc private func hideKeyboardOnTap(){
        self.view.endEditing(true)
        
    }
    
    func setTapGestureRecognizerOnView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.hideKeyboardOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    func setSwipeGestureRecognizerOnView(){
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SignInViewController.hideKeyboardOnTap))
        swipDown.direction = .down
        self.view.addGestureRecognizer(swipDown)
    }
}
