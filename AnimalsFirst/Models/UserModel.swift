//
//  UserModel.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/22/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

class UserModel {
    var name = ""
    var email = ""
    var phone = ""
    var type = ""
    var uid = ""

    convenience init(name: String, email: String, phone: String, type: String) {
        self.init()
        self.name = name
        self.email = email
        self.phone = phone
        self.type = type
    }
}
