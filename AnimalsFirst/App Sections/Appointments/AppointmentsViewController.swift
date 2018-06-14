//
//  AppointmentsViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    private let appointmentsModel = AppointmentsModel()
    private var date = Date()
    private var year: Int!
    private var calendar = Calendar.current
    private var onceOnly = false
    private var currentCalendar: [AFMonthModel] = []
    private var weekday = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        year = Int(date.currentYear!)
        for i in 0 ... 11 {
            var dayModel = AFDayModel.init(index: 1, month: i + 1, year: year)
            let numberOfDays = dayModel.daysInMonth
            var days: [AFDayModel] = []
            for j in 0 ... numberOfDays - 1{
                dayModel = AFDayModel(index: j + 1, month: i + 1, year: year)
                days.append(dayModel)
            }
            let monthModel = AFMonthModel.init(index: i, days: days)
            currentCalendar.append(monthModel)
        }

        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        calendarCollectionView.register(UINib(nibName: "CalendarCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CalendarCollectionReusableView")
        
        rearrangeDaysInMonth()
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
    
    func updateMonth(sectionNumber: Int) -> String? {
        let monthNumber = sectionNumber
        let dateString = String(monthNumber)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM"
        guard let myDate = dateFormatter.date(from: dateString) else {
            return ""
        }
        dateFormatter.dateFormat = "MMMM"
        let stringFromDate = dateFormatter.string(from: myDate)
        
        return stringFromDate
    }
    
    func rearrangeDaysInMonth() {
        var count = 0
        for month in currentCalendar {
            let day = AFDayModel(index: 1, month: month.index + 1, year: year)
            print(day.month)
            print(day.weekDay)
            if day.weekDay > 1 {
                for _ in 1 ... day.weekDay - 1{
                    let newBlankDay = AFDayModel(index: 0, month: 0, year: 0)
                    currentCalendar[count].days.insert(newBlankDay, at: 0)
                }
              count += 1
            }
        }
    }
}

extension AppointmentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCalendar[section].days.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentCalendar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
            fatalError()
        }
        
        let dayModel = currentCalendar[indexPath.section].days[indexPath.row]
        
        
        if dayModel.index == 0 {
            cell.calendarLabel.text = ""
            cell.contentView.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.white
        } else {
            if dayModel.index == 1 {
                weekday = dayModel.weekDay
            }
            guard let newDate = date.setDate(day: indexPath.row + 2 - weekday, month: indexPath.section + 1, year: year) else {
                fatalError()
            }
            cell.calendarLabel.text = "\(indexPath.row + 2 - weekday)"
            let isEnabled = appointmentsModel.updateColor(forDate: newDate, calendar: calendar)
            cell.contentView.isUserInteractionEnabled = isEnabled
            cell.calendarLabel.isEnabled = isEnabled
            cell.backgroundColor = isEnabled ? AFConstants.Colors.green : AFConstants.Colors.darkGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size.width/7 - 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: 0, section: Int(date.currentMonth!)!)
            self.calendarCollectionView.scrollToItem(at: indexToScrollTo, at: .bottom, animated: false)
            onceOnly = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CalendarCollectionReusableView", for: indexPath) as! CalendarCollectionReusableView
        if let text = updateMonth(sectionNumber: indexPath.section + 1) {
            reusableView.sectionLabel.text = text + " " + date.currentYear!
        }
        return reusableView
    }
}
