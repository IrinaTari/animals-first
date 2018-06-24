//
//  AFDateModel.swift
//  AnimalsFirst
//
//  Created by Irina Tari on 6/14/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class AFDayModel: NSObject {
    var index: Int!
    var month: Int!
    var year: Int!
    var isEnabled = false
    var isFull = false
    var totalNrOfAnimals = 0
    var numberOfCats = 0
    var numberOfDogs = 0
    var numberOfMaleCats = 0
    var weekDay: Int {
        guard let newDate = Date().setDate(day: index, month: month, year: year) else {
            fatalError()
        }
        return Calendar.current.component(.weekday, from: newDate)
    }
    var daysInMonth: Int {
        guard let newDate = Date().setDate(day: index, month: month, year: year) else {
            fatalError()
        }
        return Calendar.current.range(of: .day, in: .month, for: newDate)!.count
    }
    
    convenience init(index: Int, month: Int, year: Int) {
        self.init()
        self.index = index
        self.month = month
        self.year = year
    }

    func updateNumberOfAnimals(animalType: AFConstants.AnimalType, numberOfDogs: Int, numberOfCats: Int, numberOfMaleCats: Int) {
        switch animalType {
        case .dog:
            self.numberOfDogs += numberOfDogs
            totalNrOfAnimals += numberOfDogs
        case .cat:
            self.numberOfCats += numberOfCats
            totalNrOfAnimals += numberOfCats
        case .maleCat:
            self.numberOfMaleCats += numberOfMaleCats
        case .bothCatAndDog:
            totalNrOfAnimals = 0
        }
    }

    func checkDayCapacity(animalType: AFConstants.AnimalType, numberOfDogs: Int, numberOfCats: Int, numberOfMaleCats: Int) -> Bool {
        var full = false
        if self.numberOfDogs > AFConstants.DayCapacity.maxDogNr - numberOfDogs || totalNrOfAnimals > AFConstants.DayCapacity.maxNrAnimals - numberOfCats - numberOfDogs || self.numberOfMaleCats > AFConstants.DayCapacity.maxNrOfMaleCats - numberOfMaleCats || self.numberOfCats > AFConstants.DayCapacity.maxCatNr - numberOfCats {
            full = true
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

class AFMonthModel: NSObject {
    var index: Int!
    var days: [AFDayModel]!
    
    convenience init(index: Int, days: [AFDayModel]) {
        self.init()
        self.index = index
        self.days = days
    }
}

enum PreferredTime: String {
    case morning = "08:00"
    case evening = "17:00"
}
