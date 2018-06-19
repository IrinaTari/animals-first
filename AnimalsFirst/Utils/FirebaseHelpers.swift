//
//  FirebaseHelperMethods.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseDatabase

class FirebaseHelpers: UIViewController {

    static func firebaseSignOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    static func fetchFBUserAndSaveInDB()
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
                let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)

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

    static func saveAppointment() {

    }

    static func fetchAppointment() {

    }

    static func saveDoctorUser() {

    }

    static func fetchDoctorUser() {

    }

    static func saveClientUser() {

    }

    static func fetchClientUser(){
        let currentUser = Auth.auth().currentUser
        let ref = Database.database().reference()
        ref.child("users").child(AFConstants.UserTypes.client).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            guard let dictionary = snapshot.value as? [String : Any] else {
                fatalError()
            }
            for key in (dictionary.keys) {
                if key == currentUser?.uid {
                    // user exists
                    // return user details
                    return
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
