//
//  ClientViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 4/23/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ClientViewController: UIViewController {
    @IBOutlet weak var clientLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let clientName = Auth.auth().currentUser?.email
        clientLabel.text = clientName

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // buttons action
    @IBAction func handleLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Login")
        self.present(vc, animated: true, completion: nil)
    }
}
