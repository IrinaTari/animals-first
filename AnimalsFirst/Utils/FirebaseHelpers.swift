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

    static func fetchAppointment() -> [AppointmentsModel] {
        var appointments: [AppointmentsModel] = []
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let userID = Auth.auth().currentUser?.uid
        ref.child("appointments").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.childrenCount) // I got the expected number of items
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                print(child.value!)
                let year = child.key
                for yearChild in child.children.allObjects as! [DataSnapshot] {
                    let month = yearChild.key
                    for monthChild in yearChild.children.allObjects as! [DataSnapshot] {
                        let day = monthChild.key
                        let appointment = AppointmentsModel()
                        if let dictionary = monthChild.value as? [String : AnyObject] {
                            appointment.bringDay = dictionary["dropOffDay"] as? String ?? ""
                            appointment.returnDay = dictionary["pickUpDay"] as? String ?? ""
                            appointment.client.name = dictionary["name"] as? String ?? ""
                            appointment.client.uid = userID!
                            appointment.day.index = Int(day)
                            appointment.day.month = Int(month)
                            appointment.day.year = Int(year)
                            let animalListString = dictionary["animal"] as? String ?? ""
                            if animalListString.contains("\n") {
                                let animalsAndNumbers = animalListString.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: true)
                                for string in animalsAndNumbers {
                                    let newArray = string.split(separator: "x", maxSplits: Int.max, omittingEmptySubsequences: true)
                                    let animal = newArray[0].trimmingCharacters(in: CharacterSet.whitespaces)
                                    let number = newArray[1].trimmingCharacters(in: CharacterSet.whitespaces)
                                    var animalType = AFConstants.AnimalType.dog
                                    switch animal {
                                    case "Caine":
                                        animalType = AFConstants.AnimalType.dog
                                    case "Pisica":
                                        animalType = AFConstants.AnimalType.cat
                                    case "Motan":
                                        animalType = AFConstants.AnimalType.maleCat
                                    default:
                                        animalType = AFConstants.AnimalType.dog
                                    }
                                    let animalDictionary = [animalType : Int(number)!]
                                    appointment.animalType.append(animalDictionary)
                                }
                            }
                            appointments.append(appointment)
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    return appointments
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
