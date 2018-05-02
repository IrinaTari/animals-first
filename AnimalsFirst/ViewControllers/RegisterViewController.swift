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

class RegisterViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        adjustViewFontsAndSubviews()

        var ref: DatabaseReference!

        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountButtonAction(_ sender: Any) {
        if (lastNameTextField.text?.isEmpty)! || (firstNameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (phoneTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Nu s-a putut crea contul", message: "Toate campurile trebuie completate cu date corecte pentru a crea un cont...", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
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

}
