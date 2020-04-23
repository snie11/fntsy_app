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
    @IBOutlet var rankings : UITextView?
    @IBOutlet var rankingsnums : UITextView?
    @IBOutlet var topPlayer : UILabel?
    @IBOutlet var topPlayerTeam : UILabel?
    @IBOutlet var welcome : UILabel?
    
    var leaguename : String = ""
    var league : League?
    var id : Int = 0
    var topScore : Int = 0
    var topScorePlayer : String = "No points yet."
    var topScoreTeam : String = "No team yet."
    
    var scoreMap : [String : Int] = [:]
    
    override func viewDidLoad() {
    
        DispatchQueue.main.async{
            super.viewDidLoad()
            self.backsplash?.image = UIImage(named: "upper_splash")
            self.welcome?.text = self.leaguename;
            self.card1?.image = UIImage(named: "white_card")
            self.card2?.image = UIImage(named: "white_card2")
            self.editButton?.setImage(UIImage(named:"edit_add"), for: .normal)
        }
        ref = Database.database().reference()
        var scoreMap : [String : Int] = [:]
        getLeague()
    }
    
    private func updateFields() {
        
        DispatchQueue.main.async{
            self.welcome?.text = self.league?.leaguename;
            self.topPlayer?.text = self.topScorePlayer
            self.topPlayerTeam?.text = self.topScoreTeam
            
            var scoreField : String = ""
            var scoreNumField : String = ""
            
            let sorted = self.scoreMap.sorted { $0.1 > $1.1 }
            
            var i : Int = 5
            for (player, score) in sorted {
                if (i > 0) {
                    scoreField += "\(player)\n"
                    scoreNumField += "\(score)\n"
                    i -= 1
                }
            }
            
            if (self.scoreMap.count == 0) {
                scoreField = "No ranks, click below to add."
            }
            
            dump(self.scoreMap)
            
            self.rankings?.text = scoreField
            self.rankingsnums?.text = scoreNumField
        }
    }
    
    @IBAction func onClick(_sender : UIButton) {
//        self.performSegue(withIdentifier: "InviteToDashboard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "LeagueDashtoEditPts" {
            // send whole league object
            let detailVC = destinationVC as! EditPointsViewController
            detailVC.league = league
            detailVC.leagueid = id
//            detailVC.leaguename = leaguecode!.text!
            print("to points")
        }
    }
    
    private func getLeague() {
        refHandle = ref.child("leagues/\(id)").observe(DataEventType.value, with: { (snapshot) in
            if let l = snapshot.value as? NSDictionary {
                print("got here 1")
                if let leaguenm = l["leaguename"] as? String, let leaguecode = l["leaguecode"] as? String, let ps = l["players"] as? [NSDictionary], let us = l["users"] as? [NSDictionary] {
                    print("got here 2")
                    var players : [Player] = []
                    var users : [String] = []
                    var scoreMap : [String : Int] = [:]
                    
                    for p in ps {
                        if let pname = p["name"] as? String, let pteam = p["team"] as? String, let pdescription = p["description"] as? String, let ppts = p["pts"] as? [NSDictionary], let ptotalpts = p["totalpts"] as? Int {
                            print("got here miraculously")
                            var points : [Int] = []
                            for pt in ppts {
                                if let week = pt["pts"] as? Int {
                                    print(week)
                                    points.append(week as! Int)
                                }
                            }
                            
                            if ptotalpts > self.topScore {
                                self.topScore = ptotalpts
                                self.topScorePlayer = pname
                                self.topScoreTeam = pteam
                            }
                            
                            if let curr = self.scoreMap[pteam] as? Int {
                                self.scoreMap[pteam]! += ptotalpts
                            } else {
                                self.scoreMap[pteam] = ptotalpts
                            }
                                
                            let player1 = Player(playername: pname, playerdescription: pdescription, playerteam: pteam, totalpoints: ptotalpts, points: points)
                            players.append(player1)
                            
                        } else if let pname = p["name"] as? String, let pdescription = p["description"] as? String, let ptotalpts = p["totalpts"] as? Int {
                            print("got here no team assignments")
                            let player1 = Player(playername: pname, playerdescription: pdescription, playerteam: "No team yet.", totalpoints: ptotalpts, points: [])
                            players.append(player1)
                        }
                    }
                    
                    for u in us {
                        if let uemail = u["email"] as? String {
                            users.append(uemail)
                        }
                    }
                    
                    self.league = League(leaguename: leaguenm, leaguecode: leaguecode, players: players, users: users)
                    self.updateFields()
                }
            }
        })
    }
}
