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

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        adjustViewFontsAndSubviews()
    }

    // MARK: buttons action

    @IBAction func cancelButton(_ sender: Any) {
        emptyAllTextFields()
    }

    @IBAction func createAccountButtonAction(_ sender: Any) {

        guard let lastName = lastNameTextField.text, let firstName = firstNameTextField.text, let email = emailTextField.text, let phone = phoneTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else {
            AFAlert.showEmptyTextFieldsAlert(self, completionBlock: {_ in 
                self.passwordTextField.text = ""
                self.repeatPasswordTextField.text = ""
            })
            return
        }

        if lastName.isEmpty || firstName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty {
            AFAlert.showEmptyTextFieldsAlert(self, completionBlock: {_ in
                self.passwordTextField.text = ""
                self.repeatPasswordTextField.text = ""

            })
            return
        }

        if password == repeatPassword {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user: User?, error) in
            if error != nil {
                print(error!)
                AFAlert.showAccFailAlert(self, error: error!, completionBlock: {_ in
                    self.emptyAllTextFields()
                })
                return
            }
            // success
            let ref = Database.database().reference(fromURL: "https://animalsfirst-12b83.firebaseio.com/")
            let fullName = firstName.appending(" ").appending(lastName)
            print(fullName)
            let values = ["name" : fullName, "email" : email, "phone" : phone]
            let usersRef = ref.child("users")
            let clientUserRef = usersRef.child("clients")
            clientUserRef.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err!)
                    AFAlert.showAccFailAlert(self, error: error!, completionBlock: {_ in
                        self.emptyAllTextFields()
                    })
                    return
                }
                AFAlert.showAccSuccessAlert(self, completionBlock: {_ in
                    self.emptyAllTextFields()
                    self.goToScreen(withStoryboardName: "Main", andVCIdentifier: "Login")
                    self.firebaseSignOut()
                })
                })
            })
        } else {
            // password != repeat password alert
            AFAlert.showInequalPasswordAlert(self, completionBlock: {_ in
                self.passwordTextField.text = ""
                self.repeatPasswordTextField.text = ""
            })
            print("inequal passwords")
        }
    }

    // MARK: textField Delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.count)! < 10
    }

}

// MARK: extension
extension RegisterViewController {

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

    func emptyAllTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }

    func firebaseSignOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

