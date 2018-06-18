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

    var totalNrOfAnimals = 0
    var numberOfCats = 0
    var numberOfDogs = 0
    var numberOfMaleCats = 0
    var clientList: [UserModel]!
    var animalType: AFConstants.AnimalType!

    func updateNumberOfAnimals(animalType: AFConstants.AnimalType, number: Int) {
        switch animalType {
        case .dog:
            numberOfDogs += number
            totalNrOfAnimals += number
        case .cat:
            numberOfCats += number
            totalNrOfAnimals += number
        case .maleCat:
            numberOfMaleCats += number
        }
    }

    func checkDayCapacity(animalType: AFConstants.AnimalType, number: Int) -> Bool {
        var full = false
        if totalNrOfAnimals < AFConstants.DayCapacity.maxNrAnimals {
            switch animalType {
            case .dog:
                if numberOfDogs <= AFConstants.DayCapacity.maxDogNr - number && totalNrOfAnimals <= AFConstants.DayCapacity.maxNrAnimals - number {
                    full = true
                }
            case .cat:
                if numberOfCats <= AFConstants.DayCapacity.maxCatNr - number && totalNrOfAnimals <= AFConstants.DayCapacity.maxNrAnimals - number {
                    full = true
                }
            case .maleCat:
                if numberOfMaleCats <= AFConstants.DayCapacity.maxNrOfMaleCats - number {
                    full = true
                }
            }
        }
        return full
    }

    func checkValidDate(forDate: Date, weekDayIndex: Int) -> Bool {
        var valid = false
        let date = Date()
        let compareResult = forDate.compare(date)
        if compareResult == ComparisonResult.orderedAscending || weekDayIndex == 1 || weekDayIndex == 7 {
            valid = false
        } else {
            valid = true
        }
        return valid
    }
}
