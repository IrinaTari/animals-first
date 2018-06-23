//
//  ViewController.swift
//  AnimalsFirst
//
//  Created by Irina Tari on 6/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // if user is logged in
        if let currentUser = Auth.auth().currentUser {
            print(currentUser)
            for userType in AFConstants.allTypes() {
                StoryboardNavigator.findUserAndShowAppropriateScreen(name: userType, currentUser: currentUser, controller: self)
            }
        } else {
            guard let viewController = UIViewController.login as? LoginViewController else {
                fatalError("LoginViewController failed at init")
            }
            self.present(viewController, animated: true, completion: nil)
            FirebaseHelpers.firebaseSignOut()
        }
    }
}
