//
//  mainViewController.swift
//  Instogrom
//
//  Created by Eddey on 2016/11/14.
//  Copyright © 2016年 EDiOS275. All rights reserved.
//

import UIKit
import Firebase

class mainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    @IBOutlet weak var pickImageView: UIImageView!
    
    @IBAction func signOutTapped(_ sender: Any) {
    
        try! FIRAuth.auth()?.signOut()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ref = FIRDatabase.database().reference()
        
        storageRef = FIRStorage.storage().reference(forURL: "gs://edios275-b81a5.appspot.com")
        
        
    
    }
    
    
    @IBAction func pichPhotoTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "拍照", style: .default) {action in
            
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                
                self.present(picker, animated: true, completion: nil)
                
                }

            
        alertController.addAction(cameraAction)
        }
        let pickAction = UIAlertAction(title: "選取照片", style: .default) {action in
        
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                
                self.present(picker, animated: true, completion: nil)
                
            }

        
        }
        alertController.addAction(pickAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pickImageView.image = pickImage
        
        
        if let imageData = UIImageJPEGRepresentation(pickImage, 0.5){ //photo品質(%)
        
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jepg"
            
            let postsRef = ref.child("posts")  //存入post 底下
            let postRef = postsRef.childByAutoId()
            
            let imagePath = "images/\(postRef.key).jpg"
            
            let photoRef = storageRef.child(imagePath) //存入storage路徑
            
            photoRef.put(imageData, metadata: metaData, completion: { (metaData, error) in
                if let error = error{
                    print("erroer:\(error)")
                }
                
                let downloadURL = (metaData!.downloadURL()?.absoluteString)!
                let currentUser = (FIRAuth.auth()?.currentUser)!
                let authorUID = currentUser.uid
                let email = currentUser.email!
                let postDate = Int(Date().timeIntervalSince1970 * 1000)
                
                let postDict: [String: Any] = [
                
                    "authorUID": authorUID,
                    "email": email,
                    "imagePath": imagePath,
                    "imageURL": downloadURL,
                    "postDate": postDate
                    
                ]
                
                postRef.updateChildValues(postDict)
                print("照片上傳完成")
            })
        
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }

    @IBAction func addNewDataTapped(_ sender: Any) {
        

        let usersRef = ref.child("users")

        let userRef = usersRef.childByAutoId()
        
        userRef.updateChildValues([
            "Name": "Eddey",
            "EMail": "eddey@msi.com",
            "Phone": "0975877878"
            
            ])
    }
    
    
    
    @IBAction func userSettingTapped(_ sender: Any) {
        
        
    }
    


}
