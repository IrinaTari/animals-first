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
    private var firstDayInMonthIsMonday: [Bool]!
    private var updatedMonth: [Bool]!
    private var numberOfDaysInMonth: [Int]!
    private var indexPathArray: [IndexPath]!

    override func viewDidLoad() {
        super.viewDidLoad()
        updatedMonth = []
        firstDayInMonthIsMonday = []
        numberOfDaysInMonth = []
        year = Int(date.currentYear!)
        for i in 1 ... 12 {
            let newDate = date.setDate(day: 1, month: i, year: year)
            let weekDay = calendar.component(.weekday, from: newDate!)
            numberOfDaysInMonth.append((Calendar.current.range(of: .day, in: .month, for: newDate!)?.count)!)
            if (weekDay != 1) {
                firstDayInMonthIsMonday.append(false)
            } else {
                firstDayInMonthIsMonday.append(true)
            }
            updatedMonth.append(false)
        }

        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        calendarCollectionView.register(UINib(nibName: "CalendarCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CalendarCollectionReusableView")
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
}

extension AppointmentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[section]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
            fatalError()
        }

        let newDate = date.setDate(day: indexPath.row + 1, month: indexPath.section + 1, year: year)
        let weekDay = calendar.component(.weekday, from: newDate!)

        if firstDayInMonthIsMonday[indexPath.section] == false {
            if updatedMonth[indexPath.section] == false {
                indexPathArray = []
                if calendarCollectionView.numberOfItems(inSection: indexPath.section) == 0 {
                    calendarCollectionView.reloadData()
                } else {
                    for i in 0 ... weekDay - 1 {
                        indexPathArray.append(IndexPath(row: i, section: indexPath.section))
                    }
                    self.numberOfDaysInMonth[indexPath.section] = self.numberOfDaysInMonth[indexPath.section] + weekDay
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: indexPathArray)
                    }, completion: nil)


                    self.updatedMonth[indexPath.section] = true
                    calendarCollectionView.reloadData()
                }
            }
            if indexPathArray.contains(indexPath) {
                cell.calendarLabel.text = ""
                cell.backgroundColor = UIColor.white
                cell.isUserInteractionEnabled = false
            } else {
                cell.calendarLabel.text = "\(indexPath.row + 1 - weekDay)"
                let isEnabled = appointmentsModel.updateColor(forDate: newDate!, calendar: calendar)
                cell.contentView.isUserInteractionEnabled = isEnabled
                cell.calendarLabel.isEnabled = isEnabled
                cell.backgroundColor = isEnabled ? AFConstants.Colors.green : AFConstants.Colors.darkGray
            }
        } else {
            cell.calendarLabel.text = "\(indexPath.row + 1)"
            let isEnabled = appointmentsModel.updateColor(forDate: newDate!, calendar: calendar)
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
