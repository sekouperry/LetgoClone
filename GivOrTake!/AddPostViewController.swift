//
//  AddPostViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/21/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var itsfreelabel: UILabel! {
        didSet {
            self.itsfreelabel.alpha = 0
        }
    }
    
    
    
    
    @IBOutlet weak var postImageView: UIImageView! {
        didSet{
            self.postImageView.alpha = 0
        }
        
    }
    
    @IBOutlet weak var postSwitch: UISwitch!
    @IBOutlet weak var freeswitch: UISwitch!
    
    var netService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postSwitchAction(_ sender: UISwitch) {
        
        if postSwitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.postImageView.alpha = 1.0
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.postImageView.alpha = 0
            })
        }
        
    }
    
    @IBAction func freeswitch(_sender: UISwitch) {
        if freeswitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.itsfreelabel.alpha = 1.0
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.itsfreelabel.alpha = 0
            })
        }
    }
    
    @IBAction func choosePostPicture(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismiss(animated: true, completion: nil)
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.postImageView.image = chosenImage
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePost(_ sender: CustomizableButton){
        self.view.endEditing(true)
        
        if postSwitch.isOn {
            
            var postText = ""
            if let text = postTextView.text{
                postText = text
            }
            
            let postId = NSUUID().uuidString
            let postDate = NSDate().timeIntervalSince1970 as NSNumber
            
            if let image = self.postImageView.image {
                
                if let imageData = UIImageJPEGRepresentation(image, CGFloat(0.35)){
                    
                    self.netService.uploadImageToFirebase(postId: postId, imageData: imageData, completion: { (url) in
                        
                        let post = Post(postId: postId, userId: FIRAuth.auth()!.currentUser!.uid, postText: postText, postImageURL: String(describing:url), postDate: postDate, type:"IMAGE")
                        self.netService.savePostToDB(post: post, completed: {
                            self.dismiss(animated: true, completion: nil)
                        })
                        
                        
                        
                    })
                    
                    
                }
                
            }
            
            
        }else {
            
            var postText = ""
            
            if let text = postTextView.text {
                postText = text
            }
            
            let postId = NSUUID().uuidString
            let postDate = NSDate().timeIntervalSince1970 as NSNumber
            
            let post = Post(postId: postId, userId: FIRAuth.auth()!.currentUser!.uid, postText: postText, postImageURL: "", postDate: postDate, type: "TEXT")
            self.netService.savePostToDB(post: post, completed: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
        
    }
    


}
