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

//struct League {
//    var leaguename : String
//    var leaguecode : String
//    var players : [Player]
//}
//
//struct Player {
//    var playername : String
//    var playerdescription : String
//    var points : [Int]
//}

class JoinLeagueViewController: UIViewController {

    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var card : UIImageView?
    @IBOutlet var createGroupButton : UIButton?
    @IBOutlet var leagueCode : UITextField?
    
    var email : String = ""
    
    override func viewDidLoad() {
    
        DispatchQueue.main.async{
            super.viewDidLoad()
            self.backsplash?.image = UIImage(named: "upper_splash")
            self.card?.image = UIImage(named: "white_card")
            self.createGroupButton?.setImage(UIImage(named:"join_league"), for: .normal)
            print("join league with \(self.email)")
        }
        
        ref = Database.database().reference()
    }
    
    @IBAction func onClick(_sender : UIButton) {
        var code : String = self.leagueCode!.text!
        print("got to onclick with \(code)")
        var found : Bool = false
        refHandle = ref.child("leagues").observe(DataEventType.value, with: { (snapshot) in
            if let leagues = snapshot.value as? [NSDictionary] {
                for i in 0...leagues.count-1 {
                    var l = leagues[i]
                    if let leaguec = l["leaguecode"] as? String, let users = l["users"] as? [NSDictionary] {
                        print(leaguec)
                        if (leaguec == code && found == false) {
                            print("got to here with \(leaguec)")
                            self.ref.child("leagues").child("\(i)/users/\(users.count)").setValue(["email":self.email])
                            found = true
                            let alertController = UIAlertController(title: nil, message: "Successfully joined league.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                                self.performSegue(withIdentifier: "JoinToDashboard", sender: nil)
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                
                if (!found) {
                    let alertController = UIAlertController(title: nil, message: "No league found.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
//        self.performSegue(withIdentifier: "JoinToDashboard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "JoinToDashboard" {
            // send whole league object
            let detailVC = destinationVC as! DashboardViewController
            detailVC.email = email
//            detailVC.leaguename = leaguename!.text!
//            detailVC.leaguename = leaguecode!.text!
            print("toDashboard with joined league")
        }
    }
}
