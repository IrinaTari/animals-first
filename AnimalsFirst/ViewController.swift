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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var FBLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let fbbutton = FBSDKLoginButton(frame: CGRect(x: Int(FBLabel.frame.origin.x), y: Int(FBLabel.frame.origin.y) + 20, width: 100, height: 28))

        self.view.addSubview(fbbutton)
        self.view.addConstraint(NSLayoutConstraint(item: fbbutton, attribute: .top, relatedBy: .equal, toItem: FBLabel, attribute: .bottom, multiplier: 1, constant: 20))
        self.view.addConstraint(NSLayoutConstraint(item: fbbutton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100))
        self.view.addConstraint(NSLayoutConstraint(item: fbbutton, attribute: .centerX, relatedBy: .equal, toItem: FBLabel, attribute: .centerX, multiplier: 1, constant: 0))
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

