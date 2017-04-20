//
//  MUCommentController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/25/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase

class MUCommentController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentImageView: UIImageView! {
        didSet{
            self.commentImageView.alpha = 0
        }
    }
    
    
    @IBOutlet weak var commentSwitch: UISwitch!
    
    var netService = NetworkingServices()
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func commentSwitchAction(_ sender: UISwitch) {
        
        if commentSwitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.commentImageView.alpha = 1.0
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.commentImageView.alpha = 0
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.commentImageView.image = chosenImage
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveComment(_ sender:MUCustomizableButtons){
        self.view.endEditing(true)
        
        if commentSwitch.isOn {
            
            var commentText = ""
            if let text = commentTextView.text{
                commentText = text
            }
            
            let commentId = NSUUID().uuidString
            let commentDate = NSDate().timeIntervalSince1970 as NSNumber
            
            if let image = self.commentImageView.image {
                
                if let imageData = UIImageJPEGRepresentation(image, CGFloat(0.35)){
                    
                    self.netService.uploadImageToFirebase(postId: commentId, imageData: imageData, completion: { (url) in
                        let comment = Comments(commentId: commentId, userId: FIRAuth.auth()!.currentUser!.uid, commentText: commentText, postId: self.postId, commentImageURL: String(describing:url), commentDate: commentDate, type: "IMAGE")
                        self.netService.MUsaveCommentToDB(comment: comment, completed: {
                            self.dismiss(animated: true, completion: nil)
                        })
                        
                        
                        
                    })
                    
                    
                }
                
            }
            
            
        }else {
            
            var commentText = ""
            
            if let text = commentTextView.text {
                commentText = text
            }
            
            let commentId = NSUUID().uuidString
            let commentDate = NSDate().timeIntervalSince1970 as NSNumber
            let comment = Comments(commentId: commentId, userId: FIRAuth.auth()!.currentUser!.uid, commentText: commentText, postId: self.postId, commentImageURL: "", commentDate: commentDate, type: "TEXT")
            
            self.netService.MUsaveCommentToDB(comment: comment, completed: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
        
    }
    

    
}
