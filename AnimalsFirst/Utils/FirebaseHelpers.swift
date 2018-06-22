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

    static func saveAppointment(appointment: AppointmentsModel, controller: UIViewController) {
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let userID = Auth.auth().currentUser?.uid
        var animalsString = ""
        for index in appointment.animalType {
            for (type, number) in index {
                animalsString.append("\(type.rawValue) x \(number) \n")
            }
        }
        let appointmentDay = "\(appointment.day.year!)/\(appointment.day.month!)/\(appointment.day.index!)"
        let values = ["client" : appointment.client.name, "day" : appointmentDay, "dropOffDay" : appointment.bringDay, "pickUpDay" : appointment.returnDay, "animal" : animalsString] as [String : Any]
        let appointmentRef = ref.child("appointments")
        let clientUserRef = appointmentRef.child(userID!).child(appointmentDay)
        clientUserRef.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil {
                print(err!)
                return
            }
            // appointment saved
            print("appointment saved")
            AFAlert.showAppointmentSavedAlert(controller, completionBlock: {_ in 
                guard let viewController = UIViewController.client as? ClientViewController else {
                    fatalError("ClientViewController failed to init")
                }
                controller.present(viewController, animated: false, completion: nil)
            })
        })
    }

    static func fetchAppointment(appointment: AppointmentsModel) {
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let userID = Auth.auth().currentUser?.uid
        let appointmentDay = "\(appointment.day.index!)/\(appointment.day.month!)/\(appointment.day.year!)"
        ref.child("appointments").child(userID!).child(appointmentDay).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            appointment.day = value?["day"] as! AFDayModel
            appointment.bringDay = value?["dropOffDay"] as? String ?? ""
            appointment.returnDay = value?["pickUpDay"] as? String ?? ""
            appointment.animalType = value?["animal"] as! [[AFConstants.AnimalType : Int]]
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    static func saveDoctorUser() {

    }

    static func fetchDoctorUser() {

    }

    static func saveClientUser(name: String, email: String, phone: String, id: String) {
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let values = ["name" : name, "email" : email, "phone" : phone]
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


    static func fetchClientUser(user: UserModel) {
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("clients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            user.name = value?["name"] as? String ?? ""
            user.email = value?["email"] as? String ?? ""
            user.phone = value?["phone"] as? String ?? ""
            user.type = "clients"
            user.uid = userID!
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
