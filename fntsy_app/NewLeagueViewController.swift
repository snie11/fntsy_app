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

struct League {
    var leaguename : String
    var leaguecode : String
    var players : [Player]
}

struct Player {
    var playername : String
    var playerdescription : String
    var points : [Int]
}

class NewLeagueViewController: UIViewController {

    @IBOutlet var bg : UIImageView?
    @IBOutlet var card1 : UIImageView?
    @IBOutlet var card2 : UIImageView?
    @IBOutlet var continueButton : UIButton?
    @IBOutlet var leaguename : UITextField?
    @IBOutlet var leaguecode : UITextField?
    var username : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        bg?.image = UIImage(named: "upper_splash")
        card1?.image = UIImage(named: "white_card")
        card2?.image = UIImage(named: "white_card")
        continueButton?.setImage(UIImage(named:"ContLineup"), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as UIViewController
//        if segue.identifier == "loginToDashboard" {
//            let detailVC = destinationVC as! DashboardViewController
//            detailVC.email = emailTextField!.text!
//            print("toDashboard with email \(emailTextField!.text)")
    }
        
        
//        else if segue.identifier == "toACVC" {
//            print("toDashboard")
//            let navVC = destinationVC as! UINavigationController
//            let addContactVC = navVC.topViewController as! AddContactViewController
//            addContactVC.delegate = self
//        }
}
