//
//  ContactViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/21/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
}

