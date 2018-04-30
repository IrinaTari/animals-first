//
//  ViewController.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 4/23/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

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
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // setup FB button
        fbbutton.frame = FBPlaceholderButton.frame
        FBPlaceholderButton.isHidden = true
        self.view.addSubview(fbbutton)

        // make round corners for buttons
        loginButton.layer.cornerRadius = 5.0
        registerButton.layer.cornerRadius = 5.0

        loginButton.titleLabel?.adjustTextUsingDynamicType()
        registerButton.titleLabel?.adjustTextUsingDynamicType()
        usernameTextField.adjustTextUsingDynamicType()
        passwordTextField.adjustTextUsingDynamicType()
        FBLabel.adjustTextUsingDynamicType()
        infoLabel.adjustTextUsingDynamicType()
        noAccountLabel.adjustTextUsingDynamicType()
        fbbutton.titleLabel?.adjustTextUsingDynamicType()
        fbbutton.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true

        // read fb permissions
        fbbutton.readPermissions = ["public_profile", "email"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // handle didcomplete
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //handle did log out
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fbbutton.frame = FBPlaceholderButton.frame
    }
}

extension UILabel {
    func adjustTextUsingDynamicType() {
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = true
    }
}

extension UITextField {
    func adjustTextUsingDynamicType() {
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = true
    }
}
