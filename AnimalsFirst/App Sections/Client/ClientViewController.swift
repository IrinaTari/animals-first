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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ClientCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClientCollectionViewCell")
        //collectionView.register(ClientCollectionViewCell.self, forCellWithReuseIdentifier: "ClientCollectionViewCell")
        //let clientName = Auth.auth().currentUser?.email
        fetchUserProfileIfIsFBConnected()
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchUserProfileIfIsFBConnected()
    }

    //MARK: Buttons action
    @IBAction func handleLogoutButton(_ sender: Any) {
        FirebaseHelpers.firebaseSignOut()
        guard let loginViewController = UIViewController.login as? LoginViewController else {
            fatalError("Login View Controller initialization failed")
        }
        self.present(loginViewController, animated: true, completion: nil)
    }

    func fetchUserProfileIfIsFBConnected()
    {
        if FBSDKAccessToken.current() == nil {
            return
        }

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, phone"], tokenString: UserDefaults.standard.value(forKey: "fb_token") as! String, version: nil, httpMethod: nil)

        graphRequest.start(completionHandler: { (connection, result, error) -> Void in

            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]

                print("Print entire fetched result: \(String(describing: result))")

                guard let userName = data["name"] as? String, let email = data["email"] as? String, let phone = data["phone"] as? String, let id : String = data["id"] as? String else {
                    return
                }

                  print("User ID is: \(id)")
                // save in database
                // add condition of user was saved already not to do this
                let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)

                let values = ["name" : userName, "email" : email, "phone" : phone]
                let usersRef = ref.child("users")
                let clientUserRef = usersRef.child("clients").child(id)
                clientUserRef.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    // client saved
                    print("client saved")
                })
            }
        })
    }
}

// MARK: UICollectionViewDelegate
extension ClientViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            break
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientCollectionViewCell", for: indexPath) as? ClientCollectionViewCell else {
            fatalError()
        }
        cell.titleLabel.text = AFConstants.Collection.array[indexPath.item]
        cell.contentView.backgroundColor = UIColor.generateRandomColor()
        cell.contentView.backgroundColor = cell.contentView.backgroundColor?.withAlphaComponent(0.7)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AFConstants.Collection.array.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size.width/2
        return CGSize(width: size, height: size)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
