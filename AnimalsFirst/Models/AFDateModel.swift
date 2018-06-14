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
