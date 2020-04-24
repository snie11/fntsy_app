//
//  EditPointsViewController.swift
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

class EditPointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PointRefresher {
    
    var league : League?
    var leagueid : Int?
    let cellReuseIdentifier = "PlayerPointsCell"
    @IBOutlet var tableView : UITableView!
    @IBOutlet var backsplash : UIImageView?
    @IBOutlet var addPlayer : UIButton!
    private let refreshControl = UIRefreshControl()
    var currPlayer : Player?
    var playerid : Int = 100
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    weak var delegate: PointRefresher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        addPlayer?.setImage(UIImage(named:"􀁍"), for: .normal)
        
        backsplash?.image = UIImage(named: "upper_splash")
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func refreshPoints(league l : League) {
        league = l
        tableView.reloadData()
        delegate?.refreshPoints(league:l)
    }
    
    func setupTableView() {
        if #available(iOS 10.0, *) {
            tableView!.refreshControl = refreshControl
        } else {
            tableView!.addSubview(refreshControl)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return league!.players.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.deselectRow(at: indexPath, animated: true)
        playerid = indexPath.row
        currPlayer = league!.players[indexPath.row]
        self.performSegue(withIdentifier: "PointsToPlayer", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = league!.players[indexPath.row].playername
        cell.imageView?.image = UIImage(systemName: "person")
        cell.imageView?.tintColor = UIColor.init(named: "green")
        cell.detailTextLabel?.text = "\(league!.players[indexPath.row].totalpoints) points"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    @IBAction func onClick(_sender : UIButton) {
        let message = "Enter new player name and description."
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addTextField{ (textField) in
            textField.text = "Player name"
        }
        alertController.addTextField{ (textField) in
            textField.text = "Player description"
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            let name = alertController.textFields![0].text
            let description = alertController.textFields![1].text
            
            let player = Player(playername: name!, playerdescription: description!, playerteam: "", totalpoints: 0, points: [])
            dump(player)
            var playernum : Int = self.league!.players.count
            print(playernum)
            print("\(self.leagueid!)")
            self.ref.child("leagues").child("\(self.leagueid!)").child("players").child("\(playernum)").setValue(["name": name!, "description":description!, "totalpts": 0, "team": ""])
            
            self.league!.players.append(player)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func refreshPlayers(_ sender: UIRefreshControl) {
        print("edit points is refreshing")
        sender.beginRefreshing()
        getPlayers(sender)
    }
    
    private func getPlayers(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "PointsToPlayer" {
            // send whole league object
            
            let detailVC = destinationVC as! PlayerDetailViewController
            detailVC.league = league
            detailVC.leagueid = leagueid
            detailVC.playerid = playerid
            detailVC.delegate = self
//            detailVC.currPlayer = currPlayer
//            detailVC.leaguename = leaguecode!.text!
            print("toPlayer")
        }
    }
}
