//
//  UIViewControllerExtensions.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/14/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

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
}

// MARK: - helper methods
fileprivate extension UIViewController {
    static func viewController(for type: ViewControllerType) -> UIViewController? {
        return type.storyboard.instantiateViewController(withIdentifier: type.rawValue)
    }
}
