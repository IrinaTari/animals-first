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
import FBSDKCoreKit
import FirebaseDatabase

class ClientViewController: UIViewController {
    @IBOutlet weak var clientLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let clientName = Auth.auth().currentUser?.email
        clientLabel.text = clientName
        fetchUserProfileIfIsFBConnected()

    }

    override func viewDidAppear(_ animated: Bool) {
        fetchUserProfileIfIsFBConnected()
    }

    //MARK: Buttons action
    @IBAction func handleLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        guard let loginViewController = UIViewController.login as? LoginViewController else {
            fatalError("Login View Controller initialization failed")
        }
        self.present(loginViewController, animated: true, completion: nil)
    }

    func fetchUserProfileIfIsFBConnected()
    {
        if FBSDKAccessToken.current() == nil {
            return
        }

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, phone"], tokenString: UserDefaults.standard.value(forKey: "fb_token") as! String, version: nil, httpMethod: nil)

        graphRequest.start(completionHandler: { (connection, result, error) -> Void in

            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]

                print("Print entire fetched result: \(String(describing: result))")

                guard let userName = data["name"] as? String, let email = data["email"] as? String, let phone = data["phone"] as? String, let id : String = data["id"] as? String else {
                    return
                }

                  print("User ID is: \(id)")
                // save in database
                // add condition of user was saved already not to do this
                let ref = Database.database().reference(fromURL: "https://animalsfirst-12b83.firebaseio.com/")

                let values = ["name" : userName, "email" : email, "phone" : phone]
                let usersRef = ref.child("users")
                let clientUserRef = usersRef.child("clients").child(id)
                clientUserRef.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    // client saved
                    print("client saved")
                })
            }
        })
    }
}
