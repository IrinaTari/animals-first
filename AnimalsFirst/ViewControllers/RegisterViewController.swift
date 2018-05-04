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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        adjustViewFontsAndSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountButtonAction(_ sender: Any) {

        guard let lastName = lastNameTextField.text, let firstName = firstNameTextField.text, let email = emailTextField.text, let phone = phoneTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else {
            showEmptyTextFieldsAlert()
            return
        }

        if lastName.isEmpty || firstName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty {
            showEmptyTextFieldsAlert()
            return
        }

        if password == repeatPassword {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user: User?, error) in
            if error != nil {
                print(error!)
                self.createAccFailAlert(error: error!)
                return
            }
            // success
            let ref = Database.database().reference(fromURL: "https://animalsfirst-12b83.firebaseio.com/")
            let fullName = firstName.appending(" ").appending(lastName)
            print(fullName)
            let values = ["name" : fullName, "email" : email, "phone" : phone]
            let usersRef = ref.child("users")
            let clientUserRef = usersRef.child("client type users")
            clientUserRef.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err!)
                    self.createAccFailAlert(error: err!)
                    return
                }
                self.createAccSuccessAlert()
                self.emptyAllTextFields()
                _ = self.navigationController?.popViewController(animated: true)
                })
            })
        } else {
            // password != repeat password alert
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
        infoLabel.adjustTextUsingDynamicType()
    }

    func showEmptyTextFieldsAlert() {
        let alert = UIAlertController(title: "Nu s-a putut crea contul", message: "Toate campurile trebuie completate cu date corecte.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    func createAccFailAlert(error: Error) {
        let alert = UIAlertController(title: "Nu s-a putut crea contul", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    func createAccSuccessAlert() {
        let alert = UIAlertController(title: "Cont creat cu success!", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    func emptyAllTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }

    // MARK: textField Delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.count)! < 10
    }

}

