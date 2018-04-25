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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let fbbutton = FBSDKLoginButton(frame: loginButton.frame)
        self.view.addSubview(fbbutton)
        fbbutton.frame.origin.y = FBLabel.frame.origin.y + fbbutton.frame.height + 8
        self.view.addConstraint(NSLayoutConstraint(item: fbbutton, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 8))
        loginButton.layer.cornerRadius = 5.0
        registerButton.layer.cornerRadius = 5.0
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

}
