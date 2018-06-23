//
//  ContactViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/21/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import MapKit

class ContactViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func phoneCallAction(_ sender: Any) {
        let text = phoneNumberButton.titleLabel?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let phoneURL = NSURL(string: "TEL://" + text!) else {
            return
        }
        if UIApplication.shared.canOpenURL(phoneURL as URL) {
            UIApplication.shared.open(phoneURL as URL, options: [:]) { (success) in
                if !success {
                    let alert = UIAlertController(title: "Nu se poate suna", message: "Din pacate, ceva a functionat gresit in functia de apel.", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func sendEmailAction(_ sender: Any) {
        let text = emailButton.titleLabel?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let emailURL = NSURL(string: "mailto:" + text!) else {
            return
        }
        if UIApplication.shared.canOpenURL(emailURL as URL) {
            UIApplication.shared.open(emailURL as URL, options: [:]) { (success) in
                if !success {
                    let alert = UIAlertController(title: "Nu se poate trimite email", message: "Din pacate, ceva a functionat gresit in functia de trimitere email.", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}


