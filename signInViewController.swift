//
//  signInViewController.swift
//  Instogrom
//
//  Created by Eddey on 2016/11/10.
//  Copyright © 2016年 EDiOS275. All rights reserved.
//

import UIKit
import Firebase

class signInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signIntapped(_ sender: Any) {
        print("start Login")
        
        if let email = emailField.text, let password = passwordField.text{
            
            signInButton.isEnabled = false
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password
                , completion: { (user, error) in
                    
                    DispatchQueue.main.async {
                        self.signInButton.isEnabled = true
                    }
                    
                    if let error = error{
                        
                        let loginAlert = UIAlertController(title: "\(error.localizedDescription)", message: nil, preferredStyle: .alert)
                        loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(loginAlert, animated: true, completion: nil)

                    
                        print("Login Fail, error:\(error)")
                        
                        return
                    }
                    
                    print("Success,user:\(user?.email)")
                    
            })
        
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailField.endEditing(true)
        passwordField.endEditing(true)
        
    }
    

    @IBAction func returnTosignInController(_ segue: UIStoryboardSegue){
    
    }
}
