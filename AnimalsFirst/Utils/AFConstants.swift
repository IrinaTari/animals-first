//
//  AFConstants.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/21/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

class AFConstants: NSObject {
    struct Colors {
        static let green = UIColor(red: 0/255, green: 179/255, blue: 60/255, alpha: 1)
        static let purple = UIColor(red: 98/255, green: 62/255, blue: 142/255, alpha: 1)
        static let gray = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        static let darkGray = UIColor(red: 106/255, green: 107/255, blue: 106/255, alpha: 1)
    }

    struct Path {
        static let databaseRef = "https://animalsfirst-12b83.firebaseio.com/"
    }

    struct Collection {
        static let firstTitle = "Programari pentru sterilizare"
        static let secondTitle = "Adoptii"
        static let thirdTitle = "Foster"
        static let fourthTitle = "Istoric"
        static let fifthTitle = "Contact"
        static let array = [firstTitle, secondTitle, thirdTitle, fourthTitle, fifthTitle]
    }

    struct UserTypes {
        static let client = "clients"
        static let doctor = "doctors"
        static let admin = "admins"
    }

    static func allTypes() -> [String] {
        //add doctor to string
        return [AFConstants.UserTypes.client, AFConstants.UserTypes.admin]
    }

    struct DayCapacity {
        static let maxDogNr = 10
        static let maxCatNr = 10
        static let maxNrAnimals = 10
        static let maxNrOfMaleCats = 6
    }

    enum AnimalType: String {
        case dog = "Caine"
        case cat = "Pisica"
        case maleCat = "Motan"
        case bothCatAndDog = "Pisica si Caine"
    }
}
