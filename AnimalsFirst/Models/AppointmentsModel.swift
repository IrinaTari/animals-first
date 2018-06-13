//
//  AppointmentsModel.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/13/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class AppointmentsModel: NSObject {
    var day = 0
    var month = 0
    var year = 0
    var isFull = false
    var color = UIColor.darkGray
    var totalNrOfAnimals = 0
    var numberOfCats = 0
    var numberOfDogs = 0
    var clientList: [UserModel]!
    var animalType: AFConstants.AnimalType!

    func updateNumberOfAnimals(animalType: AFConstants.AnimalType, forDay: Date) {
        if totalNrOfAnimals < AFConstants.DayCapacity.maxNrAnimals {
            switch animalType {
            case .dog:
                if numberOfDogs < AFConstants.DayCapacity.maxDogNr {
                    numberOfDogs += 1
                    totalNrOfAnimals += 1
                }
            case .cat:
                if numberOfCats < AFConstants.DayCapacity.maxCatNr {
                    numberOfCats += 1
                    totalNrOfAnimals += 1
                }
            }
        }
    }

    func updateColor(animalType: AFConstants.AnimalType) -> UIColor {
        if totalNrOfAnimals < AFConstants.DayCapacity.maxNrAnimals {
            switch animalType {
            case .dog:
                if numberOfDogs < AFConstants.DayCapacity.maxDogNr {
                    color = UIColor.green
                }
            case .cat:
                if numberOfCats < AFConstants.DayCapacity.maxCatNr {
                    color = UIColor.green
                }
            }
        }
        return color
    }

    func updateColor(forDate: Date, calendar: Calendar) -> UIColor {
        let date = Date()
        let compareResult = forDate.compare(date)
        if compareResult == ComparisonResult.orderedAscending || calendar.isDateInWeekend(forDate) {
            color = UIColor.darkGray
        } else {
            color = UIColor.green
        }
        return color
    }
}
