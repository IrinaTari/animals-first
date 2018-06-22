//
//  ClientViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 4/23/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseDatabase

class ClientViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray = [UIImage(named: "appointments"), UIImage(named: "adoptions"), UIImage(named: "foster"), UIImage(named: "history"), UIImage(named: "contact")] as! [UIImage]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ClientCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClientCollectionViewCell")
    }

    //MARK: Buttons action
    @IBAction func handleLogoutButton(_ sender: Any) {
        FirebaseHelpers.firebaseSignOut()
        guard let loginViewController = UIViewController.login as? LoginViewController else {
            fatalError("Login View Controller initialization failed")
        }
        self.present(loginViewController, animated: false, completion: nil)
    }
}

// MARK: UICollectionViewDelegate
extension ClientViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        StoryboardNavigator.showAppropriateScreenFromClientMenu(indexPath: indexPath, controller: self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientCollectionViewCell", for: indexPath) as? ClientCollectionViewCell else {
            fatalError()
        }
        cell.titleLabel.text = AFConstants.Collection.array[indexPath.item]
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.font = cell.titleLabel.font.withSize(23)
        //cell.titleLabel.adjustTextUsingDynamicType()
        cell.backgroundColorView.backgroundColor = UIColor.generateRandomColor()
        cell.backgroundImageView.image = imageArray[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AFConstants.Collection.array.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size.width/2 - 2
        return CGSize(width: size * 2, height: size)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
