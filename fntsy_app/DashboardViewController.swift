//
//  DashboardViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/15/20.
//  Copyright © 2020 Selina Nie. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class DashboardViewController: UIViewController {

    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var card : UIImageView?
    @IBOutlet var bottomNav : UIImageView?
    @IBOutlet var lightning : UIImageView?
    @IBOutlet var newLeagueButton : UIButton?
    @IBOutlet var joinLeagueButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backsplash?.image = UIImage(named: "upper_splash")
        card?.image = UIImage(named: "white_card")
        bottomNav?.image = UIImage(named: "bottom_nav")
        lightning?.image = UIImage(named: "􀋩@x1")
        
//        loginButton?.setImage(UIImage(named:"login_button"), for: .normal)
//        signupButton?.setImage(UIImage(named:"signin_button"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // handle user change login state
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}
