//
//  ViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 4/23/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var FBLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var FBPlaceholderButton: UIButton!
    let fbbutton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // setup FB button
        fbbutton.frame = FBPlaceholderButton.frame
        FBPlaceholderButton.isHidden = true
        fbbutton.delegate = self
        self.view.addSubview(fbbutton)

        // read fb permissions
        fbbutton.readPermissions = ["public_profile", "email"]

        // if user is logged in
        if let currentUser = Auth.auth().currentUser {
            print(currentUser)
            for userType in AFConstants.allTypes() {
                StoryboardNavigator.findUserAndShowAppropriateScreen(name: userType, currentUser: currentUser, controller: self)
            }
        } else {
            FirebaseHelpers.firebaseSignOut()
        }
    }

    // MARK: buttons action
    @IBAction func loginAction(_ sender: Any) {

        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            AFAlert.showEmptyTextFieldsAlert(self, completionBlock: {_ in
                self.passwordTextField.text = ""
            })
            return
        }

        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                AFAlert.showLoginFailure(self, error: error!, completionBlock: {_ in
                    self.passwordTextField.text = ""
                })
                return
            }
            StoryboardNavigator.showAppropriateScreen(userType: AFConstants.UserTypes.client, controller: self)
        })
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in

            if let error = error {
               print(error.localizedDescription)
                return
            }
            // User is signed in    
            print("user is signed in")
            if (FBSDKAccessToken.current() != nil) {
                // go to client screen
                let token = FBSDKAccessToken.current().tokenString
                UserDefaults.standard.setValue(token, forKey: "fb_token")
                UserDefaults.standard.synchronize()
                StoryboardNavigator.showAppropriateScreen(userType: AFConstants.UserTypes.client, controller: self)
            }
        })
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FirebaseHelpers.firebaseSignOut()
    }

    @IBAction func registerAction(_ sender: Any) {
        guard let registerViewController = UIViewController.register as? RegisterViewController else {
            fatalError()
        }
        self.present(registerViewController, animated: true, completion: nil)
    }

    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fbbutton.frame = FBPlaceholderButton.frame
        // make round corners for buttons
        loginButton.layer.cornerRadius = 5.0
        registerButton.layer.cornerRadius = 5.0
        //adjust text
        loginButton.titleLabel?.adjustTextUsingDynamicType()
        registerButton.titleLabel?.adjustTextUsingDynamicType()
        usernameTextField.adjustTextUsingDynamicType()
        passwordTextField.adjustTextUsingDynamicType()
        FBLabel.adjustTextUsingDynamicType()
        infoLabel.adjustTextUsingDynamicType()
        noAccountLabel.adjustTextUsingDynamicType()
        fbbutton.titleLabel?.adjustTextUsingDynamicType()
        fbbutton.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }


}


