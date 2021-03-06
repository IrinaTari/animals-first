//
//  AppointmentsDetailViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/20/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class AppointmentsDetailViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bringSameDayCheckBox: UIButton!
    @IBOutlet weak var bringPreviousDayCheckBox: UIButton!
    @IBOutlet weak var returnSameDayCheckBox: UIButton!
    @IBOutlet weak var returnNextDayCheckBox: UIButton!
    @IBOutlet weak var bringSameDayLabel: UILabel!
    @IBOutlet weak var bringPreviousDayLabel: UILabel!
    @IBOutlet weak var returnSameDayLabel: UILabel!
    @IBOutlet weak var returnNextDayLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    let appointmentModel = AppointmentsModel()
    var dateString = ""
    var previousDayString = ""
    var nextDayString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        bringSameDayCheckBox.tag = 1
        bringPreviousDayCheckBox.tag = 2
        returnSameDayCheckBox.tag = 3
        returnNextDayCheckBox.tag = 4
        bringSameDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        bringPreviousDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        returnSameDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        returnNextDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        dateString = "\(appointmentModel.day.index!)/\(appointmentModel.day.month!)/\(appointmentModel.day.year!)"
        previousDayString = "\(appointmentModel.day.index! - 1)/\(appointmentModel.day.month!)/\(appointmentModel.day.year!)"
        nextDayString = "\(appointmentModel.day.index! + 1)/\(appointmentModel.day.month!)/\(appointmentModel.day.year!)"
        let clientString = " Nume: \(self.appointmentModel.client.name) \n Email: \(self.appointmentModel.client.email) \n Telefon: \(self.appointmentModel.client.phone) \n"
        var animalsString = ""
        for index in self.appointmentModel.animalType {
            for (type, number) in index {
                animalsString.append("      Animal: \(type.rawValue), numar: \(number)\n")
            }
        }
        self.infoLabel.text = "\(clientString) \n Data: \(self.dateString) \n Pacient(i):\n\(animalsString) "
        bringSameDayLabel.text = "\(dateString) 8:00 - 9:00"
        bringPreviousDayLabel.text = "\(previousDayString) 16:00 - 17:00"
        returnSameDayLabel.text = "\(dateString) 16:00 - 17:00"
        returnNextDayLabel.text = "\(nextDayString) 8:00 - 9:00"
        if appointmentModel.day.weekDay == 2 {
            bringPreviousDayLabel.isHidden = true
            bringPreviousDayLabel.isUserInteractionEnabled = false
            bringPreviousDayCheckBox.isHidden = true
            bringPreviousDayCheckBox.isUserInteractionEnabled = false
        }
        if appointmentModel.day.weekDay == 6 {
            returnNextDayLabel.isHidden = true
            returnNextDayLabel.isUserInteractionEnabled = false
            returnNextDayCheckBox.isHidden = true
            returnNextDayCheckBox.isUserInteractionEnabled = false
        }
    }

    @objc func toggleCheckBox(sender: UIButton) {
        if (sender.isSelected == true) {
            UIView.animate(withDuration: 1) {
                sender.setBackgroundImage(UIImage(named: "box"), for: .normal)
                sender.isSelected = false
            }
        }
        else {
            UIView.animate(withDuration: 1) {
                sender.setBackgroundImage(UIImage(named: "checkBox"), for: .normal)
                sender.isSelected = true
                switch sender.tag {
                case 1:
                    self.bringPreviousDayCheckBox.isSelected = false
                    self.bringPreviousDayCheckBox.setBackgroundImage(UIImage(named: "box"), for: .normal)
                case 2:
                    self.bringSameDayCheckBox.isSelected = false
                    self.bringSameDayCheckBox.setBackgroundImage(UIImage(named: "box"), for: .normal)
                case 3:
                    self.returnNextDayCheckBox.isSelected = false
                    self.returnNextDayCheckBox.setBackgroundImage(UIImage(named: "box"), for: .normal)
                case 4:
                    self.returnSameDayCheckBox.isSelected = false
                    self.returnSameDayCheckBox.setBackgroundImage(UIImage(named: "box"), for: .normal)
                default:
                    return
                }
            }
        }
    }

    @IBAction func confirmAppointmentAction(_ sender: Any) {
        if returnNextDayCheckBox.isSelected == false && returnSameDayCheckBox.isSelected == false || bringSameDayCheckBox.isSelected == false && bringPreviousDayCheckBox.isSelected == false {
            AFAlert.showNoDateSelectionAlert(self)
        } else {
            if returnSameDayCheckBox.isSelected {
                appointmentModel.returnDay = "\(dateString) 16:00 - 17:00"
            }
            if returnNextDayCheckBox.isSelected {
                appointmentModel.returnDay = "\(nextDayString) 16:00 - 17:00"
            }
            if bringSameDayCheckBox.isSelected {
                appointmentModel.bringDay = "\(dateString) 16:00 - 17:00"
            }
            if bringPreviousDayCheckBox.isSelected {
                appointmentModel.bringDay = "\(previousDayString) 16:00 - 17:00"
            }
            // save in db
            FirebaseHelpers.saveAppointment(appointment: appointmentModel, controller: self)
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.appointments as? AppointmentsViewController else {
            fatalError("AppointmentsViewController failed to init")
        }
        self.present(viewController, animated: false, completion: nil)
    }

    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // make round corners for buttons
        confirmButton.layer.cornerRadius = 5.0
        //adjust text
        confirmButton.titleLabel?.adjustTextUsingDynamicType()
        bringSameDayLabel.adjustTextUsingDynamicType()
        bringPreviousDayLabel.adjustTextUsingDynamicType()
        returnSameDayLabel.adjustTextUsingDynamicType()
        infoLabel.adjustTextUsingDynamicType()
        returnNextDayLabel.adjustTextUsingDynamicType()
        confirmButton.titleLabel?.textColor = AFConstants.Colors.purple
    }
}
