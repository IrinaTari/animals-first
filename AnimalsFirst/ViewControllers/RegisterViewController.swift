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

        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self

    }

    // MARK: buttons action
    @IBAction func cancelButton(_ sender: Any) {
        emptyAllTextFields()
        guard let loginViewController = UIViewController.login as? LoginViewController else {
            fatalError()
        }
        self.present(loginViewController, animated: true, completion: nil)
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
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(dataResult, error) in
                if error != nil {
                    print(error!)
                    AFAlert.showAccFailAlert(self, error: error!, completionBlock: {_ in
                        self.emptyAllTextFields()
                    })
                    return
                }

                guard let uid = dataResult?.user.uid else {
                    return
                }

                // success
                let ref = Database.database().reference(fromURL: AFConstants.Path.databaseRef)
                let fullName = firstName.appending(" ").appending(lastName)
                print(fullName)
                let values = ["name" : fullName, "email" : email, "phone" : phone]
                let usersRef = ref.child("users")
                let clientUserRef = usersRef.child("clients").child(uid)
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
                        guard let loginViewController = UIViewController.login as? LoginViewController else {
                            fatalError()
                        }
                        self.present(loginViewController, animated: true, completion: nil)
                        self.firebaseSignOut()
                    })
                })
            })
        } else {
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

    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
}

// MARK: extension
extension RegisterViewController {

     func emptyAllTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
}

