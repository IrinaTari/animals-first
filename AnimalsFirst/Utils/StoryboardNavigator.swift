//
//  StoryboardNavigator.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class StoryboardNavigator: NSObject {

    // MARK: check user and present appropriate screen (for LOGIN step)
    static func showAppropriateScreen(userType: String, controller: UIViewController) {
        switch userType {
        case "clients":
            guard let viewController = UIViewController.client as? ClientViewController else {
                fatalError()
            }
            controller.present(viewController, animated: true, completion: nil)
        case "doctors":
            guard let viewController = UIViewController.doctor as? DoctorViewController else {
                fatalError()
            }
            controller.present(viewController, animated: true, completion: nil)
        case "admins":
            guard let viewController = UIViewController.admin as? AdminViewController else {
                fatalError()
            }
            controller.present(viewController, animated: true, completion: nil)
        default:
            break
        }
    }

    static func showAppropriateScreenFromClientMenu(indexPath: IndexPath, controller: UIViewController) {
        switch indexPath.item {
        case 0:
            guard let viewController = UIViewController.appointments as? AppointmentsViewController else {
                fatalError()
            }
            controller.present(viewController, animated: false, completion: nil)
        case 1:
            guard let viewController = UIViewController.adoptions as? AdoptionsViewController else {
                fatalError()
            }
            controller.present(viewController, animated: false, completion: nil)
        case 2:
            guard let viewController = UIViewController.foster as? FosterViewController else {
                fatalError()
            }
            controller.present(viewController, animated: false, completion: nil)
        default:
            break
        }
    }

    static func findUserAndShowAppropriateScreen(name: String, currentUser: User, controller: UIViewController) {

        let ref = Database.database().reference()
        ref.child("users").child(name).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot)
            guard let dictionary = snapshot.value as? [String : Any] else {
                fatalError()
            }
            for key in (dictionary.keys) {
                if key == currentUser.uid {
                    // user exists
                    self.showAppropriateScreen(userType: name, controller: controller)
                    return
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
