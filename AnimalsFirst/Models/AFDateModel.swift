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
        switch animalType {
        case .dog:
            if numberOfDogs >= AFConstants.DayCapacity.maxDogNr - number || totalNrOfAnimals >= AFConstants.DayCapacity.maxNrAnimals - number {
                full = true
            }
        case .cat:
            if numberOfCats >= AFConstants.DayCapacity.maxCatNr - number || totalNrOfAnimals >= AFConstants.DayCapacity.maxNrAnimals - number {
                full = true
            }
        case .maleCat:
            if numberOfMaleCats >= AFConstants.DayCapacity.maxNrOfMaleCats - number {
                full = true
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
