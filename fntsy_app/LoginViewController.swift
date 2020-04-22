//
//  LoginViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/15/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var bg : UIImageView?
    @IBOutlet var loginButton : UIButton?
    @IBOutlet var emailTextField : UITextField?
    @IBOutlet var passwordTextField : UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        bg?.image = UIImage(named: "bg2")
        loginButton?.setImage(UIImage(named:"login_button"), for: .normal)
    }
}
