//
//  SignUpViewController.swift
//  Instogrom
//
//  Created by Eddey on 2016/11/10.
//  Copyright © 2016年 EDiOS275. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    @IBAction func register(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text, let confirmPassword = confirmPasswordField.text{
        
                if password != confirmPassword{
                
                let confirmAlert = UIAlertController(title: "Confirm Password is wrong", message: nil, preferredStyle: .alert)
                confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(confirmAlert, animated: true, completion: nil)
                
                print("wrong")
                return  //early return 後面不執行
            }
            
            print("start")
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                    let emailAlert = UIAlertController(title: "\(error.localizedDescription)", message: nil, preferredStyle: .alert)
                    emailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(emailAlert, animated: true, completion: nil)
                    
                    print("register fail, \(error)")
                    return
                }
                                
                print("register sucess, user email:\(user?.email)")
                
            })
        
        }
        
        
        
    }
    
    @IBAction func backToSignInTapped(_ sender: Any) {
        //_忽略結果
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailField.endEditing(true)
        passwordField.endEditing(true)
        confirmPasswordField.endEditing(true)
    }
    
}
