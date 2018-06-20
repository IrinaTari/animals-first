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

    override func viewDidLoad() {
        super.viewDidLoad()
        bringSameDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        bringPreviousDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        returnSameDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        returnNextDayCheckBox.addTarget(self, action: #selector(toggleCheckBox), for: UIControlEvents.touchUpInside)
        let dateString = "\(appointmentModel.day.index!)/\(appointmentModel.day.month!)/\(appointmentModel.day.year!)"
        let previousDayString = "\(appointmentModel.day.index! - 1)/\(appointmentModel.day.month!)/\(appointmentModel.day.year!)"
        let nextDayString = "\(appointmentModel.day.index! + 1)/\(appointmentModel.day.month!)/\(appointmentModel.day.year!)"
        infoLabel.text = "Date personale: \(appointmentModel.client!) \n Data: \(dateString) \n Companion: \(appointmentModel.animalType!) "
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
            sender.setBackgroundImage(UIImage(named: "box"), for: .normal)
            sender.isSelected = false;
        }
        else {
            sender.setBackgroundImage(UIImage(named: "checkBox"), for: .normal)
            sender.isSelected = true;
        }
    }

    @IBAction func confirmAppointmentAction(_ sender: Any) {

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
