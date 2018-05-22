//
//  AFConstants.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/21/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation

class AFConstants: NSObject {
    struct Path {
        static let databaseRef = "https://animalsfirst-12b83.firebaseio.com/"
    }

    struct Collection {
        static let firstTitle = "Programari pentru sterilizare"
        static let secondTitle = "Adoptii"
        static let thirdTitle = "Foster"
        static let array = [firstTitle, secondTitle, thirdTitle]
    }

    struct UserTypes {
        static let client = "clients"
        static let doctor = "doctors"
        static let admin = "admins"
    }

    static func allTypes() -> [String] {
        return [AFConstants.UserTypes.client, AFConstants.UserTypes.doctor, AFConstants.UserTypes.admin]
    }
}

