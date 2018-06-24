//
//  HistoryViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/21/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HistoryViewController: UIViewController {
    @IBOutlet weak var historyTableView: UITableView!
    var appointments = [AppointmentsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        fetchAppointment()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
    
    func fetchAppointment() {
        let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
        let userID = Auth.auth().currentUser?.uid
        ref.child("appointments").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.childrenCount) // I got the expected number of items
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                print(child.value!)
                let year = child.key
                for yearChild in child.children.allObjects as! [DataSnapshot] {
                    let month = yearChild.key
                    for monthChild in yearChild.children.allObjects as! [DataSnapshot] {
                        let day = monthChild.key
                        
                        if let dictionary = monthChild.value as? [String : AnyObject] {
                            let appointment = AppointmentsModel()
                            appointment.bringDay = dictionary["dropOffDay"] as? String ?? ""
                            appointment.returnDay = dictionary["pickUpDay"] as? String ?? ""
                            appointment.client.name = dictionary["name"] as? String ?? ""
                            appointment.client.uid = userID!
                            appointment.day.index = Int(day)
                            appointment.day.month = Int(month)
                            appointment.day.year = Int(year)
                            let animalListString = dictionary["animal"] as? String ?? ""
                            if animalListString.contains("\n") {
                                let animalsAndNumbers = animalListString.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: true)
                                for string in animalsAndNumbers {
                                    let newArray = string.split(separator: "x", maxSplits: Int.max, omittingEmptySubsequences: true)
                                    let animal = newArray[0].trimmingCharacters(in: CharacterSet.whitespaces)
                                    let number = newArray[1].trimmingCharacters(in: CharacterSet.whitespaces)
                                    var animalType = AFConstants.AnimalType.dog
                                    switch animal {
                                    case "Caine":
                                        animalType = AFConstants.AnimalType.dog
                                    case "Pisica":
                                        animalType = AFConstants.AnimalType.cat
                                    case "Motan":
                                        animalType = AFConstants.AnimalType.maleCat
                                    default:
                                        animalType = AFConstants.AnimalType.dog
                                    }
                                    let animalDictionary = [animalType : Int(number)!]
                                    appointment.animalType.append(animalDictionary)
                                }
                            }
                            self.appointments.append(appointment)
                            DispatchQueue.main.async {
                                self.historyTableView.reloadData()
                            }

                        }
   
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            fatalError()
        }
        let appointmentDay = "\(self.appointments[indexPath.row].day.index!)/\(self.appointments[indexPath.row].day.month!)/\(self.appointments[indexPath.row].day.year!)"
        cell.appointmentLabel?.text = appointmentDay
        cell.dropOffLabel?.text = self.appointments[indexPath.row].bringDay
        cell.pickUpLabel?.text = self.appointments[indexPath.row].returnDay
        // delete this when adding functionality
        cell.isUserInteractionEnabled = false
        return cell
    }
}
