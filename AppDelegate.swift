//
//  AppDelegate.swift
//  Instogrom
//
//  Created by Denny Tsai on 11/10/16.
//  Copyright © 2016 iOSD275. All rights reserved.
//

import UIKit
import Firebase





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        setupAuthStateDidChangeListener()
        
        
        
        return true
    }


    func setupAuthStateDidChangeListener(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)     //Bundle.main不是storboard
    
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("user\(user.email) login")
                
                self.window?.rootViewController = storyboard.instantiateInitialViewController()
                
            }
            else{
                
                print("No User Login!")
                
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginFllow")
                
            }
        })
    
    }
    

}

