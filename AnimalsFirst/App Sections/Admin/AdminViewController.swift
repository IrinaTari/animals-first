//
//  AdminViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 4/25/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func handleLogoutButton(_ sender: Any) {
        FirebaseHelpers.firebaseSignOut()
        guard let loginViewController = UIViewController.login as? LoginViewController else {
            fatalError("Login View Controller initialization failed")
        }
        self.present(loginViewController, animated: true, completion: nil)
    }
}
