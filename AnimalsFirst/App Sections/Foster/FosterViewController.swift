//
//  FosterViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class FosterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
}
