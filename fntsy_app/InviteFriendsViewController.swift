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

class InviteFriendsViewController: UIViewController {

    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var card : UIImageView?
    @IBOutlet var createGroupButton : UIButton?
    @IBOutlet var groupcode : UILabel?
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var league : League?
    var id : Int = 100
    
    override func viewDidLoad() {
    
        DispatchQueue.main.async{
            super.viewDidLoad()
            self.backsplash?.image = UIImage(named: "upper_splash")
            self.card?.image = UIImage(named: "white_card")
            self.createGroupButton?.setImage(UIImage(named:"create_league"), for: .normal)
            self.groupcode!.text = "\(self.league!.leaguecode)"
            self.getIDNum()
        }
        
        ref = Database.database().reference()
    }
    
    @IBAction func onClick(_sender : UIButton) {
        ref.child("leagues").child("\(id)").setValue(["leaguecode":league?.leaguecode, "leaguename":league?.leaguename])
//        ref.child("leagues").child("\(id)").setValue(["leaguename":league?.leaguename])
        
        var i = 0
        for player in league!.players {
            ref.child("leagues").child("\(id)/players").child("\(i)").setValue(["name": player.playername, "description": player.playerdescription, "totalpts": 0])
//            ref.child("leagues").child("\(id)/players").child("\(i)").setValue(["description": player.playerdescription])
//            ref.child("leagues").child("\(id)/players").child("\(i)").setValue(["totalpts": 0])
            i += 1
        }
        
        var j = 0
        for user in league!.users {
            ref.child("leagues").child("\(id)/users").child("\(j)").setValue(["email": user])
            j += 1
        }
        
        self.performSegue(withIdentifier: "InviteToDashboard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "InvitetoDashboard" {
            // send whole league object
            
//            let detailVC = destinationVC as! AssembleLineupViewController
//            detailVC.email = email
//            detailVC.leaguename = leaguename!.text!
//            detailVC.leaguename = leaguecode!.text!
            print("toDashboard with new league")
        }
    }
    
    private func getIDNum() {
        refHandle = ref.child("leagues").observe(DataEventType.value, with: { (snapshot) in
            if let leagues = snapshot.value as? [NSDictionary] {
                self.id = leagues.count
                print("id is: \(self.id)")
            }
        })
    }
}
