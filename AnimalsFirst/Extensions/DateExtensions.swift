//
//  DateExtensions.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/13/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

extension Date {

    // Year
    var currentYear: String? {
        return getDateComponent(dateFormat: "yyyy")
    }

    // Month
    var currentMonth: String? {
        return getDateComponent(dateFormat: "MM")
    }

    // Day
    var currentDay: String? {
        return getDateComponent(dateFormat: "dd")
    }

    func getDateComponent(dateFormat: String) -> String? {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        return format.string(from: self)
    }

    // set date with int values
    func setDate(day: Int, month: Int, year: Int) -> Date? {
        var components = DateComponents()
        components.setValue(day, for: .day)
        components.setValue(month, for: .month)
        components.setValue(year, for: .year)
        let date = Calendar.current.date(from: components)
        return date
    }
}
