//
//  settingViewController.swift
//  Instogrom
//
//  Created by Eddey on 2016/11/18.
//  Copyright © 2016年 EDiOS275. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class settingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var userMailLabel: UILabel!
    
    var userRef: FIRDatabaseReference!
    var userRef2: FIRDatabaseReference!
    var userStorageRef: FIRStorageReference!
    
    
    
    let user = FIRAuth.auth()?.currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userRef = FIRDatabase.database().reference().child("userPhoto")
        userRef2 = FIRDatabase.database().reference()
        userStorageRef = FIRStorage.storage().reference(forURL: "gs://edios275-b81a5.appspot.com")
        
        let currentUser = (FIRAuth.auth()?.currentUser)!
        userMailLabel.text = currentUser.email
        
        DispatchQueue.main.async {
            self.loadUserPhoto()
        }
    }
    
    
    
    func loadUserPhoto() {
    
        
        userRef.observeSingleEvent(of: .value, with: {snapshot in
            
            if let userPhotoDict = snapshot.value as? NSDictionary {
            
                let currentUser = (FIRAuth.auth()?.currentUser)!
                let authorUID = currentUser.uid
                
                
                if let userUID = (userPhotoDict["\(authorUID)"]as? NSDictionary) {
                
                    let userImageURL = URL(string: userUID["imageURL"]as! String)!
                    print(userImageURL)
                    self.userPhotoImage.sd_setImage(with: userImageURL)
                    
                    
                }
                
              
            }


            
        })
    
        
        
    }
    
    @IBAction func photoChangeTapped(_ sender: Any) {
        
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
    
    
    
    @IBAction func changePasswordTapped(_ sender: Any) {
    
        //var newPassword = getRandomSecurePassword()
        
        if let  newPassword = newPasswordField.text{
        
            user?.updatePassword(newPassword, completion: { (error) in
                
                if let error = error{
                
                    print(error)
                    let reloginAlert = UIAlertController(title: "Alert", message: "Need re-login", preferredStyle: .alert)
                    
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) {action in
                        
                        try! FIRAuth.auth()?.signOut()
                        
                        
                    }
                    reloginAlert.addAction(okAction)
                    self.present(reloginAlert, animated: true, completion: nil)
                    
                    
                
                }
                else{
                
                    print("Password updated")
                
                }
            })
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
        if let imageData = UIImageJPEGRepresentation(pickImage, 0.5){ //photo品質(%)
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jepg"
            
            let currentUser = (FIRAuth.auth()?.currentUser)!
            let authorUID = currentUser.uid
            let postsRef = userRef2.child("userPhoto/\(authorUID)")  
            //let postRef = postsRef.childByAutoId()
            
            let imagePath = "userPhoto/\((currentUser.email)!).jpg"
            
            let photoRef = userStorageRef.child(imagePath) //存入storage路徑
            
            photoRef.put(imageData, metadata: metaData, completion: { (metaData, error) in
                if let error = error{
                    print("erroer:\(error)")
                }
                
                let downloadURL = (metaData!.downloadURL()?.absoluteString)!
                
                let postDict: [String: Any] = [
                    
                    "imagePath": imagePath,
                    "imageURL": downloadURL,
                    
                ]
                
                postsRef.updateChildValues(postDict)
                print("使用者照片上傳完成")
                
                self.loadUserPhoto()
                
            })
            
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }

    
    
    @IBAction func logoutTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        newPasswordField.endEditing(true)
        
    }
    
    
    
}
