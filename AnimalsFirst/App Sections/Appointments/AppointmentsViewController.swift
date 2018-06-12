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
    private var date: Date!
    private var calendar: Calendar!
    private var year: Int!
    private var month: Int!
    private var day: Int!
    private var daysLeft = 0
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = Date()
        calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        dateFormatter.dateFormat = "LLLL"
        monthLabel.text = dateFormatter.string(from: Date())
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
    
    func updateMonth(sectionNumber: Int) -> String {
        let monthNumber = sectionNumber
        let dateString = String(monthNumber)
        
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
        return (Calendar.current.range(of: .day, in: .month, for: Date())?.count)!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (Calendar.current.range(of: .month, in: .year, for: Date())?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
            fatalError()
        }
        cell.calendarLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        monthLabel.text = updateMonth(sectionNumber: indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        monthLabel.text = updateMonth(sectionNumber: indexPath.section)
    }
}
