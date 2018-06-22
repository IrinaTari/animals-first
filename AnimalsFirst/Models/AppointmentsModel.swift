//
//  AppointmentsModel.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/13/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import Firebase

class AppointmentsModel: NSObject {
    var day = AFDayModel(index: 0, month: 0, year: 0)
    var client = UserModel()
    var animalType: [[AFConstants.AnimalType : Int]] = [[:]]
    var returnDay: String = ""
    var bringDay: String = ""
    var dayString : String {
        return "\(day.index)/\(day.month)/\(day.year)"
    }
    var animalTypeString: [String] {
        var animalsString: [String] = []
        for index in self.animalType {
            for (type, number) in index {
                animalsString.append("\(type.rawValue) x \(number)")
            }
        }
        return animalsString
    }
}
