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
    var users : [String]
}

struct Player {
    var playername : String
    var playerdescription : String
    var playerteam : String
    var totalpoints : Int
    var points : [Int]
}

class NewLeagueViewController: UIViewController {

    @IBOutlet var bg : UIImageView?
    @IBOutlet var card1 : UIImageView?
    @IBOutlet var card2 : UIImageView?
    @IBOutlet var continueButton : UIButton?
    @IBOutlet var leaguename : UITextField?
    @IBOutlet var leaguecode : UITextField?
    var email : String = ""
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bg?.image = UIImage(named: "upper_splash")
        card1?.image = UIImage(named: "white_card")
        card2?.image = UIImage(named: "white_card")
        leaguename?.text = ""
        leaguecode?.text = ""
        continueButton?.setImage(UIImage(named:"ContLineup"), for: .normal)
    }
    
    @IBAction func onClick(_sender : UIButton) {
        if (leaguename!.text! == "" || leaguecode!.text! == "") {
            let message = "Enter both fields."
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
            }
            alertController.addAction(submitAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "CreateLeaguetoAssemble", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "CreateLeaguetoAssemble" {
            let detailVC = destinationVC as! AssembleLineupViewController
            detailVC.email = email
            detailVC.leaguename = leaguename!.text!
            detailVC.leaguecode = leaguecode!.text!
            detailVC.username = username
            print("toAssemble with \(email), \(leaguename!.text!), \(leaguecode!.text!)")
        }
    }
}
