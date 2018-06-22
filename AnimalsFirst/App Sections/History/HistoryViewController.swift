//
//  HistoryViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/21/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var historyTableView: UITableView!
    private var appointments: [AppointmentsModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
        appointments = FirebaseHelpers.fetchAppointment()
        print(appointments)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {

}

// MARK: UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var historyCell = HistoryTableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell {
            print("success!")
            historyCell = cell
            let appointmentDay = "\(self.appointments[indexPath.row].day.index!)/\(self.appointments[indexPath.row].day.month!)/\(self.appointments[indexPath.row].day.year!)"
            cell.appointmentLabel?.text = appointmentDay
            cell.dropOffLabel?.text = self.appointments[indexPath.row].bringDay
            cell.pickUpLabel?.text = self.appointments[indexPath.row].returnDay
        }
        return historyCell
    }
}
