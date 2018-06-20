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
    case adoptions = "AdoptionsViewController"
    case appointments = "AppointmentsViewController"
    case foster = "FosterViewController"
    case appointmentsDetails = "AppointmentsDetailViewController"

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
        case .adoptions:
            return UIStoryboard.adoptions
        case .appointments:
            return UIStoryboard.appointments
        case .foster:
            return UIStoryboard.foster
        case .appointmentsDetails:
            return UIStoryboard.appointments
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
    static var adoptions: UIViewController? {
        return self.viewController(for: .adoptions)
    }
    static var appointments: UIViewController? {
        return self.viewController(for: .appointments)
    }
    static var foster: UIViewController? {
        return self.viewController(for: .foster)
    }
    static var appointmentsDetail: UIViewController? {
        return self.viewController(for: .appointmentsDetails)
    }
}

// MARK: - helper methods
fileprivate extension UIViewController {
    static func viewController(for type: ViewControllerType) -> UIViewController? {
        return type.storyboard.instantiateViewController(withIdentifier: type.rawValue)
    }
}
