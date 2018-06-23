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
    var imageArray: [UIImage] = []
    var firstTextArray: [String] = []
    var secondTextArray: [String] = []
    var thirdTextArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
     imageArray = [UIImage(named: "cat1"), UIImage(named: "cat2"), UIImage(named: "dog1"), UIImage(named: "cat3"), UIImage(named: "dog2"), UIImage(named: "cat4")] as! [UIImage]
        firstTextArray = ["Pisica", "Pisica", "Caine", "Pisica", "Caine", "Pisica"]
        secondTextArray = ["Torontalului", "Mehala", "Zona Stadion", "Circumvalantiunii", "Complex", "Complex"]
        thirdTextArray = ["gasit pe strada", "gasit pe strada", "gasit pe strada", "gasit pe strada", "gasit pe strada", "gasit pe strada"]
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
        return imageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionsTableViewCell", for: indexPath) as! AdoptionsTableViewCell
        cell.adoptionsImageView.image = imageArray[indexPath.row]
        cell.adoptionsImageView.layer.borderWidth = 1
        cell.adoptionsImageView.layer.masksToBounds = false
        cell.adoptionsImageView.layer.cornerRadius = cell.adoptionsImageView.frame.height/2
        cell.adoptionsImageView.layer.borderColor = UIColor.white.cgColor
        cell.colorView.layer.masksToBounds = false
        cell.colorView.layer.cornerRadius = cell.colorView.frame.height/2
        cell.adoptionsImageView.clipsToBounds = true
        cell.nameLabel.text = firstTextArray[indexPath.row]
        cell.areaLabel.text = secondTextArray[indexPath.row]
        cell.descriptionLabel.text = thirdTextArray[indexPath.row]
        return cell
    }
}
