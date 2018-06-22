//
//  FosterViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/24/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit

class FosterViewController: UIViewController {
    @IBOutlet weak var fosterTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fosterTableView.delegate = self
        fosterTableView.dataSource = self
        fosterTableView.register(UINib(nibName: "FosterTableViewCell", bundle: nil), forCellReuseIdentifier: "FosterTableViewCell")
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let viewController = UIViewController.client as? ClientViewController else {
            fatalError()
        }
        self.present(viewController, animated: false, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension FosterViewController: UITableViewDelegate {

}

// MARK: UITableViewDataSource
extension FosterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FosterTableViewCell", for: indexPath)
        return cell
    }
}
