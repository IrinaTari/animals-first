//
//  UIViewControllerExtensions.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/14/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

fileprivate enum ViewControllerType: String {
    case login = "LoginViewController"
    case register = "RegisterViewController"
    case client = "ClientViewController"
    case doctor = "DoctorViewController"
    case admin = "AdminViewController"


    var storyboard: UIStoryboard {
        switch self {
        case .login:
            return UIStoryboard.login
        case .register:
            return UIStoryboard.register
        case .client:
            return UIStoryboard.client
        case .doctor:
            return UIStoryboard.doctor
        case .admin:
            return UIStoryboard.admin
        }
    }
}

// MARK: - static computed vars
extension UIViewController {
    static var login: UIViewController? {
        return self.viewController(for: .login)
    }
    static var register: UIViewController? {
        return self.viewController(for: .register)
    }
    static var client: UIViewController? {
        return self.viewController(for: .client)
    }
    static var doctor: UIViewController? {
        return self.viewController(for: .doctor)
    }
    static var admin: UIViewController? {
        return self.viewController(for: .admin)
    }

    // MARK: check user and present appropriate screen
    func showAppropriateScreen(userType: String, controller: UIViewController) {
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

    // MARK: random colors generator
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 1 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    // MARK: FIREBASE methods
    func handleLogout() {
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

    func findUserAndShowAppropriateScreen(name: String, currentUser: User, controller: UIViewController) {

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

    func firebaseSignOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

// MARK: - helper methods
fileprivate extension UIViewController {
    static func viewController(for type: ViewControllerType) -> UIViewController? {
        return type.storyboard.instantiateViewController(withIdentifier: type.rawValue)
    }
}
