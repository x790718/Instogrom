//
//  photoListViewController.swift
//  Instogrom
//
//  Created by Eddey on 2016/11/26.
//  Copyright © 2016年 EDiOS275. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


protocol CustomCellDelegate {
    func shareButtonTapped(cell: postcell)
    func likeButtonTapped(cell: postcell)
    func tapped(cell: postcell)
}


class photoListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomCellDelegate, UIGestureRecognizerDelegate{

    
    var ref: FIRDatabaseReference!
    //var ref2: FIRDatabaseReference!
    var posts = [[String: Any]]()
    var storageRef: FIRStorageReference!
    var items = [FIRDataSnapshot]()
    var testt = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference().child("posts")
        //ref2 = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference(forURL: "gs://edios275-b81a5.appspot.com")

    
        
        loadPosts()
        
    }
    
    
    func loadPosts() {
    
        ref.observeSingleEvent(of: .value, with: {snapshot in
            
            for child in snapshot.children{
                
                if let child = child as? FIRDataSnapshot, let post = child.value as? [String: Any]{
                
                    self.posts.append(post)
                    
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
            
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//                loadPosts()
//
//        print("1234")
//    
//    }
    
    
//    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapped:"))
//    self.addGestureRecognizer(tapGestureRecognizer)
//    
//    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPressed:"))
//    self..addGestureRecognizer(longPressRecognizer)
    
    
    
    
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count   //顯示幾個Row
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! postcell
        
        
        let post = posts[indexPath.row]
        
//        let test = post.values
//        print(test)
        cell.delegate = self
        

        cell.emailLabel.text = post["email"] as? String
        
        cell.likeCount.text = String(describing: post["likeCount"] as! Int)
        
        let imageURL = URL(string: post["imageURL"] as! String)!
        cell.photoImageView.tag = indexPath.row
        testt = cell.photoImageView.tag
        cell.photoImageView.sd_setImage(with: imageURL)
        
        cell.shareTapped.tag = indexPath.row
        
        cell.likeTapped.tag = indexPath.row
        
        

        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.tapped(cell:)))
        tapGestureRecognizer.delegate = self
        cell.photoImageView.isUserInteractionEnabled = true
        cell.photoImageView.addGestureRecognizer(tapGestureRecognizer)
        
    
        return cell
    }
    
    
//    func delTapped(cell: postcell) {
//    
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector(("tapped:")))
//        
//        cell.photoImageView.addGestureRecognizer(tapGestureRecognizer)
//        print("tapped")
//    }
    
    internal func tapped(cell: postcell)
    {
        

        //let testt = cell.photoImageView.tag
        print("\(self.testt)")
    }
    
        
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        print("longpressed")
    }

    
    
    internal func shareButtonTapped(cell: postcell) {
        
        
        print("Selected item in row \(cell.shareTapped.tag)")
        
        let shareButtonTag = cell.shareTapped.tag

        let sharePost = posts[shareButtonTag]
        print(sharePost)
        print(shareButtonTag)
        
        if let shareURL = sharePost["imageURL"] as? String {
            
            
            let alert = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (UIAlertAction) in
                
                UIPasteboard.general.string = shareURL
                print(shareURL)
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { (UIAlertAction) in
                
                let url = URL(string: shareURL)!
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "於LINE分享網址", style: .default, handler: { (UIAlertAction) in
                
                let url = URL(string: "line://msg/text\(shareURL)")!
                
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }

        
            }
    
    
    
    
    @IBAction func addPhoto(_ sender: Any) {
        
        
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
        
        
        
        if let imageData = UIImageJPEGRepresentation(pickImage, 0.5){ //photo品質(%)
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jepg"
            
            
            let postRef = ref.childByAutoId()
            
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
                let likeCount = 0
                
                let postDict: [String: Any] = [
                    
                    "authorUID": authorUID,
                    "email": email,
                    "imagePath": imagePath,
                    "imageURL": downloadURL,
                    "postDate": postDate,
                    "likeCount": likeCount,
                    "pathString": postRef.key
                
                    
                ]
                
                postRef.updateChildValues(postDict)
                print("照片上傳完成")
                
                
            })
            
        }
        
        
        dismiss(animated: true, completion: nil)

        
    }
    
    internal func likeButtonTapped(cell: postcell) {
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
        
            //var likePost = [String: Any]()
            
            for child in snapshot.children{
                
                if let child = child as? FIRDataSnapshot, let post = child.value as? [String: Any]{
                    
                    self.posts.append(post)
                    
                    
                    let likeButtonTag = cell.likeTapped.tag
                    let likePost = self.posts[likeButtonTag]
                    print(likePost)
                    
                    
                    let likeCount = likePost["likeCount"] as! Int
                    let pathString = likePost["pathString"] as! String
                    
                    let likePhotoCount = likeCount + 1
                    
                    let likePhotoDict: [String: Any] = [
                        
                        "likeCount": likePhotoCount
                        
                    ]
                    
                    let pathRef = self.ref.child(pathString)
                    
                    cell.likeCount.text = String(likePhotoCount)
                    pathRef.updateChildValues(likePhotoDict)
                    
                    print(likePhotoCount)
                    
                    
                    
                    return
                    
                    
                }
                
    
            }
 
        })
       
        
    }
    
    

    
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        try! FIRAuth.auth()?.signOut()
    }
    

}
