//
//  ViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/12/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var bg : UIImageView?
    @IBOutlet var loginButton : UIButton?
    @IBOutlet var signupButton : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        bg?.image = UIImage(named: "bg1")
        loginButton?.setImage(UIImage(named:"login_button"), for: .normal)
        signupButton?.setImage(UIImage(named:"signin_button"), for: .normal)
    }


}

