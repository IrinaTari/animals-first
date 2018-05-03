//
//  RegisterViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/2/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        adjustViewFontsAndSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountButtonAction(_ sender: Any) {

        guard let lastName = lastNameTextField.text, let firstName = firstNameTextField.text, let email = emailTextField.text, let phone = phoneTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else{
            showEmptyTextFieldsAlert()
            return
        }

        if password == repeatPassword {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user: User?, error) in
            if error != nil {
                    print(error!)
                    return
            }
            // success
            let ref = FirebaseDatabase.DatabaseReference().database.reference(fromURL: "https://animalsfirst-12b83.firebaseio.com/")
                let values = ["lastName" : lastName, "firstName" : firstName, "email" : email, "phone" : phone, "password" : password]
            ref.updateChildValues(values)
            })
        } else {
            print("inequal passwords")
        }
    }

    @objc func backAction(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

    func adjustViewFontsAndSubviews() {
        // make round corners for buttons
        cancelButton.layer.cornerRadius = 5.0
        createAccountButton.layer.cornerRadius = 5.0
        //adjust text
        cancelButton.titleLabel?.adjustTextUsingDynamicType()
        createAccountButton.titleLabel?.adjustTextUsingDynamicType()
        lastNameTextField.adjustTextUsingDynamicType()
        firstNameTextField.adjustTextUsingDynamicType()
        emailTextField.adjustTextUsingDynamicType()
        phoneTextField.adjustTextUsingDynamicType()
    }

    func showEmptyTextFieldsAlert() {
        let alert = UIAlertController(title: "Nu s-a putut crea contul", message: "Toate campurile trebuie completate cu date corecte pentru a crea un cont...", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

}
