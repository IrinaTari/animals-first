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


    func checkUserTypeAndPresentScreen(controller: UIViewController) {
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let currentUser = Auth.auth().currentUser
        if currentUser == ref.child("users").child((currentUser!.uid)) {
            guard let viewController = UIViewController.client as? ClientViewController else {
                fatalError("Client View Controller failed initialization")

            }
            controller.present(viewController, animated: true, completion: nil)
        } else {
            guard let viewController = UIViewController.admin as? AdminViewController else {
                fatalError("Admin View Controller failed initialization")

            }
            controller.present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - helper methods
fileprivate extension UIViewController {
    static func viewController(for type: ViewControllerType) -> UIViewController? {
        return type.storyboard.instantiateViewController(withIdentifier: type.rawValue)
    }
}
