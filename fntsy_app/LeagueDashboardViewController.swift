//
//  LeagueDashboardViewController.swift
//  fntsy_app
//
//  Created by Selina Nie on 4/23/20.
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

class LeagueDashboardViewController: UIViewController {
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var card1 : UIImageView?
    @IBOutlet var card2 : UIImageView?
    @IBOutlet var editButton : UIButton?
    @IBOutlet var rankings : UILabel?
    @IBOutlet var topPlayer : UILabel?
    @IBOutlet var topPlayerTeam : UILabel?
    @IBOutlet var welcome : UILabel?
    
    var leaguename : String = ""
    var league : League?
    var id : Int = 0
    
    override func viewDidLoad() {
    
        DispatchQueue.main.async{
            super.viewDidLoad()
            self.backsplash?.image = UIImage(named: "upper_splash")
            self.welcome?.text = self.leaguename;
            self.card1?.image = UIImage(named: "white_card")
            self.card2?.image = UIImage(named: "white_card")
            self.editButton?.setImage(UIImage(named:"edit_button"), for: .normal)
        }
        ref = Database.database().reference()
        getLeague()
    }
    
    @IBAction func onClick(_sender : UIButton) {
//        self.performSegue(withIdentifier: "InviteToDashboard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "DetailsToPoints" {
            // send whole league object
//            let detailVC = destinationVC as! DashboardViewController
//            detailVC.email = email
//            detailVC.leaguename = leaguename!.text!
//            detailVC.leaguename = leaguecode!.text!
            print("to points")
        }
    }
    
    private func getLeague() {
        refHandle = ref.child("leagues/\(id)").observe(DataEventType.value, with: { (snapshot) in
            if let l = snapshot.value as? NSDictionary {
                print("got here 1")
//                dump(l)
                if let leaguecode = l["leaguecode"] as? Int, let ps = l["players"] as? [NSDictionary], let us = l["users"] as? [NSDictionary] {
                    print("got here 2")
                    var players : [Player] = []
                    var users : [String] = []
                    
                    for p in ps {
                        if let pname = p["name"] as? String, let pteam = p["team"] as? String, let ppts = p["pts"] as? NSArray, let ptotalpts = p["totalpts"] as? Int {
                            print("got here miraculously")
//                            var points : [Int] = []

                        }
                    }
                }
            }
        })
    }
}
