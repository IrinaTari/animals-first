//
//  AdoptionsViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class AdoptionsViewController: UIViewController {
    @IBOutlet weak var adoptionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        adoptionsTableView.delegate = self
        adoptionsTableView.dataSource = self
        adoptionsTableView.register(UINib(nibName: "AdoptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdoptionsTableViewCell")
    }
    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension AdoptionsViewController: UITableViewDelegate {

}

// MARK: UITableViewDataSource
extension AdoptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionsTableViewCell", for: indexPath)
        return cell
    }
}
