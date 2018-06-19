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
    @IBOutlet weak var dogTextField: UITextField!
    @IBOutlet weak var catTextField: UITextField!
    @IBOutlet weak var maleCatTextField: UITextField!
    @IBOutlet weak var dogCheckBox: UIButton!
    @IBOutlet weak var catCheckBox: UIButton!
    @IBOutlet weak var maleCatCheckBox: UIButton!
    private var date = Date()
    private var year: Int!
    private var onceOnly = false
    private var currentCalendar: [AFMonthModel] = []
    private var weekday = 0
    private var animalType = AFConstants.AnimalType.dog
    private var number = 0
    private var showFilteredDay = false

    override func viewDidLoad() {
        super.viewDidLoad()
        dogCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        catCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        maleCatCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        dogTextField.delegate = self
        catTextField.delegate = self
        maleCatTextField.delegate = self
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        rearrangeDaysInMonth()
    }

    @objc func dismissKeyboard(sender: UIView) {
        self.view.endEditing(true)
        refreshCheckBoxButtons()
    }
    
    @objc func toggleCheckBox(sender: UIButton) {
        if (sender.isSelected == true) {
            sender.setBackgroundImage(UIImage(named: "box"), for: .normal)
            sender.isSelected = false;
        }
        else {
            sender.setBackgroundImage(UIImage(named: "checkBox"), for: .normal)
            sender.isSelected = true;
        }
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
        for month in currentCalendar {
            let day = AFDayModel(index: 1, month: month.index + 1, year: year)
            if day.weekDay > 1 {
                for _ in 1 ... day.weekDay - 1{
                    let newBlankDay = AFDayModel(index: 0, month: 0, year: 0)
                    currentCalendar[month.index].days.insert(newBlankDay, at: 0)
                }
            }
        }
    }
    
    func refreshCheckBoxButtons() {
        if (dogTextField.text?.isEmpty)! && dogCheckBox.isSelected == true {
            toggleCheckBox(sender: dogCheckBox)
        }
        if (catTextField.text?.isEmpty)! && catCheckBox.isSelected == true {
            toggleCheckBox(sender: catCheckBox)
        }
        if (maleCatTextField.text?.isEmpty)! && maleCatCheckBox.isSelected == true {
            toggleCheckBox(sender: maleCatCheckBox)
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
        
        if dayModel.index == 0 && dayModel.month == 0 {
            cell.calendarLabel.text = ""
            cell.contentView.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.white
        } else {
            if showFilteredDay == false {
                if dayModel.index == 1 {
                    weekday = dayModel.weekDay
                }
                guard let newDate = date.setDate(day: dayModel.index!, month: indexPath.section + 1, year: year) else {
                    fatalError()
                }
                dayModel.isEnabled = dayModel.checkValidDate(forDate: newDate, weekDayIndex: dayModel.weekDay)
            }
            cell.calendarLabel.text = "\(dayModel.index!)"
            cell.contentView.isUserInteractionEnabled = dayModel.isEnabled
            cell.calendarLabel.isEnabled = dayModel.isEnabled
            cell.backgroundColor = dayModel.isEnabled ? AFConstants.Colors.green : AFConstants.Colors.darkGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let dayModel = currentCalendar[indexPath.section].days[indexPath.row]

        if (dogTextField.text?.isEmpty)! && (catTextField.text?.isEmpty)! {
            AFAlert.showZeroAnimalsSelectedAlert(self)
        } else {
            AFAlert.showAppointmentDayAlert(self, day: dayModel) { (buttonIndex) in
                if buttonIndex == 0 {
                    AFAlert.showSterilizationInfoAlert(self, completionBlock: { (buttonIndex) in
                        if buttonIndex == 0 {
                            // save appointment info
                        }
                    })
                }
            }
        }
        
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

extension AppointmentsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var secondNumber = 0
        print(newText)
        if textField == catTextField {
            self.animalType = .cat
        } else if textField == dogTextField {
            self.animalType = .dog
            
        } else if textField == maleCatTextField {
            self.animalType = .maleCat
        }
        if !(catTextField.text?.isEmpty)! && !(dogTextField.text?.isEmpty)! {
            self.animalType = .bothCatAndDog
            if textField == catTextField {
                secondNumber = Int(dogTextField.text!)!
            } else {
                secondNumber = Int(catTextField.text!)!
            }
        }
        
        guard let number = Int(newText) else {
            showFilteredDay = false
            self.calendarCollectionView.reloadData()
            return true
        }
        showFilteredDay = true
        for month in currentCalendar {
            for day in month.days {
                guard let newDate = date.setDate(day: day.index!, month: day.month, year: year) else {
                    fatalError()
                }
                if day.checkValidDate(forDate: newDate, weekDayIndex: day.weekDay) {
                    day.isEnabled = !day.checkDayCapacity(animalType: self.animalType, number: number, secondNumber: secondNumber)
                } else {
                    day.isEnabled = false
                }
            }
        }
        self.calendarCollectionView.reloadData()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == catTextField {
            if !catCheckBox.isSelected {
                toggleCheckBox(sender: catCheckBox)
            }
            if (dogTextField.text?.isEmpty)! && dogCheckBox.isSelected == true {
                toggleCheckBox(sender: dogCheckBox)
            }
            if (maleCatTextField.text?.isEmpty)! && maleCatCheckBox.isSelected == true {
                toggleCheckBox(sender: maleCatCheckBox)
            }
        } else if textField == dogTextField {
            if !dogCheckBox.isSelected {
                toggleCheckBox(sender: dogCheckBox)
            }
            if (catTextField.text?.isEmpty)! && catCheckBox.isSelected == true {
                toggleCheckBox(sender: catCheckBox)
            }
            if (maleCatTextField.text?.isEmpty)! && maleCatCheckBox.isSelected == true {
                toggleCheckBox(sender: maleCatCheckBox)
            }
        } else {
            if !maleCatCheckBox.isSelected {
                toggleCheckBox(sender: maleCatCheckBox)
            }
            if (catTextField.text?.isEmpty)! && catCheckBox.isSelected == true {
                toggleCheckBox(sender: catCheckBox)
            }
            if (dogTextField.text?.isEmpty)! && dogCheckBox.isSelected == true {
                toggleCheckBox(sender: dogCheckBox)
            }
        }
        textField.keyboardType = UIKeyboardType.decimalPad
    }
}
