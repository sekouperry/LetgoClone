//
//  SSignUpViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/23/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit

class SSignUpViewController: UIViewController , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate {
    
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
    
    @IBOutlet weak var reenterPasswordTextField: CustomizableTextfields! {
        didSet{
            reenterPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var firstnameTextField: CustomizableTextfields!{
        didSet{
            firstnameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var lastnameTextField: CustomizableTextfields! {
        didSet{
            lastnameTextField.delegate = self
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var networkingService = NetworkingServices()
    
    @IBOutlet weak var createAccountButton: CustomizableButtons!
    
    @IBOutlet weak var userProfileImageView: CustomizableImageViews! {
        didSet {
            userProfileImageView.alpha = 0
        }
    }
    
    @IBOutlet weak var profileswitch: UISwitch!
    
    
    
    var countryArrays: [String] = []
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setTapGestureRecognizerOnView()
        setSwipeGestureRecognizerOnView()
        
    }
    
    @IBAction func Uploadpictures(_ sender: UISwitch) {
        
        if profileswitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.userProfileImageView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.userProfileImageView.alpha = 0
            })
        }
    }
    
    
    
    
    
    @IBAction func createAccountAction(_ sender: CustomizableButtons) {
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!
        let reenterPassword = reenterPasswordTextField.text!
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        
        let data = UIImageJPEGRepresentation(userProfileImageView.image!, 0.2)!
        
        
        
        if finalEmail.isEmpty || password.isEmpty || reenterPassword.isEmpty || firstname.isEmpty || lastname.isEmpty {
            let alert = SCLAlertView()
            _ = alert.showWarning("OH LA LA NO 🙈!", subTitle: "One or more fields have not been filled. Please try again.")
        }else {
            //sign in user
            if password == reenterPassword {
                
                if isValidEmail(email: finalEmail) {
                    self.networkingService.signUp(firstname: firstname, lastname: lastname, email: finalEmail, pictureData: data, password: password, type: 0)
                }
                //show error
            } else {
                let alert = SCLAlertView()
                _ = alert.showError("OOPS🙊", subTitle: "Passwords do not match. Please try again.")
            }
            
        }
        
        self.view.endEditing(true)
        
    }
    
}

extension SSignUpViewController {
    
    
    
    @IBAction func choosePictureAction(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.modalPresentationStyle = .popover
        pickerController.popoverPresentationController?.delegate = self
        pickerController.popoverPresentationController?.sourceView = userProfileImageView
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userProfileImageView.image = chosenImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
        lastnameTextField.resignFirstResponder()
        reenterPasswordTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 30)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            30)
    }
    
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SSignUpViewController.hideKeyboardOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func setSwipeGestureRecognizerOnView(){
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SSignUpViewController.hideKeyboardOnTap))
        swipDown.direction = .down
        self.view.addGestureRecognizer(swipDown)
    }
    
    
    
    
    
    
    
    
    
    
    
}
