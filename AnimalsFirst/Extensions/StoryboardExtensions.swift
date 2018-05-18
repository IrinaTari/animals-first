//
//  StoryboardExtensions.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/14/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum StoryboardType: String {
    case login = "Login"
    case register = "Register"
    case client = "Client"
    case doctor = "Doctor"
    case admin = "Admin"
}

// MARK: - static computed vars
extension UIStoryboard {
    static var login: UIStoryboard {
        return storyboard(for: .login)
    }
    static var register: UIStoryboard {
        return storyboard(for: .register)
    }
    static var client: UIStoryboard {
        return storyboard(for: .client)
    }
    static var doctor: UIStoryboard {
        return storyboard(for: .doctor)
    }
    static var admin: UIStoryboard {
        return storyboard(for: .admin)
    }
}

// MARK: - helper methods
fileprivate extension UIStoryboard {
    static func storyboard(for type: StoryboardType) -> UIStoryboard {
        return UIStoryboard(name: type.rawValue, bundle: nil)
    }
}