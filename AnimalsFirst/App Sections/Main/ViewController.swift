//
//  ViewController.swift
//  AnimalsFirst
//
//  Created by Irina Tari on 6/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let currentUser = Auth.auth().currentUser
        if (currentUser != nil) {
            for userInfo in (currentUser?.providerData)! {
                if (userInfo.providerID == "facebook.com") {
                    print("User is signed in with Facebook");
                    StoryboardNavigator.showAppropriateScreen(userType: AFConstants.UserTypes.client, controller: self)
                } else {
                 StoryboardNavigator.findUserAndShowAppropriateScreen(controller: self)
                }
            }
        } else {
            StoryboardNavigator.showAppropriateScreen(userType: "", controller: self)
        }
    }
}
