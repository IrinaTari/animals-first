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
    var imageArray: [UIImage] = []
    var firstTextArray: [String] = []
    var secondTextArray: [String] = []
    var thirdTextArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray = [UIImage(named: "cat6"), UIImage(named: "cat3"), UIImage(named: "dog3"), UIImage(named: "dog4"), UIImage(named: "dog5"), UIImage(named: "cat4")] as! [UIImage]
        firstTextArray = ["Pisica", "Pisica", "Caine", "Caine", "Caine", "Pisica"]
        secondTextArray = ["2 zile", "3 zile", "1 zi", "1 saptamana", "3 zile", "2 zile"]
        thirdTextArray = ["gasit pe strada", "gasit pe strada", "gasit pe strada", "gasit pe strada", "gasit pe strada", "gasit pe strada"]
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
        return imageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FosterTableViewCell", for: indexPath) as! FosterTableViewCell
        cell.fosterImageView.image = imageArray[indexPath.row]
        cell.fosterImageView.layer.borderWidth = 1
        cell.fosterImageView.layer.masksToBounds = false
        cell.fosterImageView.layer.cornerRadius = cell.fosterImageView.frame.height/2
        cell.fosterImageView.layer.borderColor = UIColor.white.cgColor
        cell.fosterImageView.clipsToBounds = true
        cell.colorView.layer.masksToBounds = false
        cell.colorView.layer.cornerRadius = cell.colorView.frame.height/2
        cell.nameLabel.text = firstTextArray[indexPath.row]
        cell.durationLabel.text = secondTextArray[indexPath.row]
        cell.descriptionLabel.text = thirdTextArray[indexPath.row]
        // delete this when adding functionality
        cell.isUserInteractionEnabled = false
        return cell
    }
}
